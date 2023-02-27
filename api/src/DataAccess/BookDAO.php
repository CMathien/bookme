<?php

namespace Bookme\API\DataAccess;

use Bookme\API\Model\Book;
use Bookme\API\Model\Genre;
use Bookme\API\Model\Author;
use Bookme\API\Component\DataAccess\DataAccessObject;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;

class BookDAO extends DataAccessObject
{
    public function getMany(array $options = []): array
    {
        if (!empty($options)) {
            $where = " where " . implode(" and ", $options);
        }
        $query = "select * from books_list";
        if (isset($where)) $query .= $where;
        $statement = $this->connection->prepare($query);
        $result = $statement->execute();
        $rows = $statement->fetchAll();

        $instances = [];
        if (count($rows) > 0) {
            foreach ($rows as $row) {
                $instance = new $this->model();

                $this->hydrateModel($instance, $row);
                $authors = $this->getAuthors($instance->getId());
                foreach ($authors as $author) {
                    $new = new Author();
                    $new->setId($author["id"]);
                    $instance->addAuthor($new);
                }
                $genres = $this->getGenres($instance->getId());
                foreach ($genres as $genre) {
                    $new = new Genre();
                    $new->setId($genre["id"]);
                    $instance->addGenre($new);
                }
                $instances[] = $instance->toArray();
            }
        }
        return $instances;
    }

    public function getOne(int $id): ?Book
    {
        $statement = $this->connection->prepare("select * from books_list where book_id = :id");
        $result = $statement->execute(['id' => $id]);
        $row = $statement->fetch();

        if (!$result) {
            throw new DatabaseError("Database error: {$statement->errorInfo()}");
        } else {
            if ($row) {
                $instance = $this->modelReflector->newInstance();
                $this->hydrateModel($instance, $row);
                $authors = $this->getAuthors($instance->getId());
                foreach ($authors as $author) {
                    $new = new Author();
                    $new->setId($author["id"]);
                    $instance->addAuthor($new);
                }
                $genres = $this->getGenres($instance->getId());
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

    public function linkToIsbn($book_id, $isbn)
    {
        $statement = $this->connection->prepare("insert into isbn (isbn, book_id) values (:isbn, :book_id)");
        if ($statement->execute(['book_id' => $book_id, 'isbn' => $isbn])) {
            return true;
        } else {
            return false;
        }
    }

    public function unlinkIsbn($isbn)
    {
        $statement = $this->connection->prepare("delete from isbn where isbn = :isbn");
        if ($statement->execute(['isbn' => $isbn])) {
            return true;
        } else {
            return false;
        }
    }

    public function getAuthors(int $book, $author = 0)
    {
        $query = "select * from book_author where book_id = :book_id";
        $params["book_id"] = $book;
        if ($author > 0) {
            $query .= " and author_id = :author_id";
            $params["author_id"] = $author;
        }
        $statement = $this->connection->prepare($query);
        $result = $statement->execute($params);
        $rows = $statement->fetchAll();
        $instances = [];
        if (count($rows) > 0) {
            foreach ($rows as $row) {
                $instance = new Author();
                $instances[] = $instance->setId($row["author_id"])->toArray();
            }
        }
        return $instances;
    }

    public function linkToAuthor($book_id, $author_id)
    {
        $statement = $this->connection->prepare("insert into book_author (book_id, author_id) values (:book_id, :author_id)");
        if ($statement->execute(['book_id' => $book_id, 'author_id' => $author_id])) {
            return true;
        } else {
            return false;
        }
    }

    public function unlinkAuthor($book_id, $author_id)
    {
        $statement = $this->connection->prepare("delete from book_author where book_id = :book_id and author_id = :author_id");
        if ($statement->execute(['book_id' => $book_id, 'author_id' => $author_id])) {
            return true;
        } else {
            return false;
        }
    }

    public function getGenres(int $book, $genre = 0)
    {
        $query = "select * from book_genre where book_id = :book_id";
        $params["book_id"] = $book;
        if ($genre > 0) {
            $query .= " and genre_id = :genre_id";
            $params["genre_id"] = $genre;
        }
        $statement = $this->connection->prepare($query);
        $result = $statement->execute($params);
        $rows = $statement->fetchAll();
        $instances = [];
        if (count($rows) > 0) {
            foreach ($rows as $row) {
                $instance = new Genre();
                $instances[] = $instance->setId($row["genre_id"])->toArray();
            }
        }
        return $instances;
    }

    public function linkToGenre($book_id, $genre_id)
    {
        $statement = $this->connection->prepare("insert into book_genre (book_id, genre_id) values (:book_id, :genre_id)");
        if ($statement->execute(['book_id' => $book_id, 'genre_id' => $genre_id])) {
            return true;
        } else {
            return false;
        }
    }

    public function unlinkGenre($book_id, $genre_id)
    {
        $statement = $this->connection->prepare("delete from book_genre where book_id = :book_id and genre_id = :genre_id");
        if ($statement->execute(['book_id' => $book_id, 'genre_id' => $genre_id])) {
            return true;
        } else {
            return false;
        }
    }
}
