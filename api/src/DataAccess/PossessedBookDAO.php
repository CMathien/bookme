<?php

namespace Bookme\API\DataAccess;

use Bookme\API\Model\Genre;
use Bookme\API\Model\Author;
use Bookme\API\Model\PossessedBook;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;
use Bookme\API\Component\Model\Model;

class PossessedBookDAO extends BookDAO
{
    protected function prepareQuery(string $columns, string $placeholders, array $params): array
    {
        $columns = explode(",", $columns);
        $clean = [];
        foreach ($columns as $column) {
            $column = str_replace("possessed_book_", "", $column);
            $column .= "_id";
            $clean[] = $column;
        }
        $columns = implode(",", $clean);
        $colums = $this->cleanColumns($columns);
        $statement = $this->connection->prepare("insert into {$this->table} ($columns) values ($placeholders)");
        $result = $statement->execute($params);

        return [$statement, $result];
    }

    public function getMany(array $options = []): array
    {
        if (!empty($options)) {
            $where = " where " . implode(" and ", $options);
        }
        $query = "select * from possessed_books_list";
        if (isset($where)) $query .= $where;
        $statement = $this->connection->prepare($query);
        $result = $statement->execute();
        $rows = $statement->fetchAll();

        $instances = [];
        if (count($rows) > 0) {
            foreach ($rows as $row) {
                $instance = new $this->model();

                $this->hydrateModel($instance, $row);
                $authors = $this->getAuthors($instance->getBook());
                if (!empty($authors)) {
                    foreach ($authors as $author) {
                        $new = new Author();
                        $new->setId($author["id"]);
                        $instance->addAuthor($new);
                    }
                }

                $genres = $this->getGenres($instance->getBook());
                if (!empty($genres)) {
                    foreach ($genres as $genre) {
                        $new = new Genre();
                        $new->setId($genre["id"]);
                        $instance->addGenre($new);
                    }
                }

                $instances[] = $instance->toArray();
            }
        }
        return $instances;
    }

    public function getOne(int $id): ?PossessedBook
    {
        $statement = $this->connection->prepare("select * from possessed_books_list where possessed_book_id = :id");
        $result = $statement->execute(['id' => $id]);
        $row = $statement->fetch();

        if (!$result) {
            throw new DatabaseError("Database error: {$statement->errorInfo()}");
        } else {
            if ($row) {
                $instance = $this->modelReflector->newInstance();
                $this->hydrateModel($instance, $row);
                $authors = $this->getAuthors($instance->getBook());
                foreach ($authors as $author) {
                    $new = new Author();
                    $new->setId($author["id"]);
                    $instance->addAuthor($new);
                }
                $genres = $this->getGenres($instance->getBook());
                foreach ($genres as $genre) {
                    $new = new Genre();
                    $new->setId($genre["id"]);
                    $instance->addGenre($new);
                }
                return $instance;
            }

            return null;
        }
    }

    public function update(Model $entity): ?Model
    {
        $columns = [];
        $params = [];

        foreach ($this->columnMap() as $propertyName => $columnName) {
            if ($propertyName === 'id')
                continue;
            $rp = new \ReflectionProperty(get_class($entity), $propertyName);
            if ($rp->isInitialized($entity)) {
                $columns[] = "{$this->switchCaseType($columnName)} = :$propertyName";
                $params[$propertyName] = $this
                    ->modelReflector
                    ->getProperty($propertyName)
                    ->getValue($entity);
            }
        }

        $columns = implode(', ', $columns);
        $columns = $this->cleanColumns($columns, 1);
        $mappedParams = array_map(
            function ($e) {
                if ($e instanceof Model) {
                    return $e->{'getId'}();
                } else if ($e instanceof \DateTime) {
                    if ($e != null) {
                        return $e->format('Y-m-d H:i:s');
                    } else return null;
                }
                return $e;
            },
            $params
        );
        $statement = $this->connection->prepare("update {$this->table} set $columns where {$this->table}_id = {$entity->{'getId'}()}");

        $result = $statement->execute($mappedParams);

        if (!$result) {
            throw new DatabaseError("Database update error: {$statement->errorInfo()}");
        }
        return $this->getOne($entity->{'getId'}());
    }

    private function cleanColumns($columns, $update = 0)
    {
        $columns = explode(",", $columns);
        $clean = [];
        foreach ($columns as $column) {
            $column = str_replace("possessed_book_", "", $column);
            if ($update === 1) $column = str_replace(" =", "_id =", $column);
            else $column .= "_id";
            $clean[] = $column;
        }
        $columns = implode(",", $clean);
        return $columns;
    }
}
