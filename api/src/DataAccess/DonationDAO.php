<?php

namespace Bookme\API\DataAccess;

use Bookme\API\Component\Model\Model;
use Bookme\API\Component\DataAccess\DataAccessObject;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;

class DonationDAO extends DataAccessObject
{
    protected function shouldUpdate(Model $entity): bool
    {
        return false;
    }

    protected function prepareQuery(string $columns, string $placeholders, array $params): array
    {
        $columns = $this->cleanColumns($columns);
        $statement = $this->connection->prepare("insert into {$this->table} ($columns) values ($placeholders)");
        $result = $statement->execute($params);

        return [$statement, $result];
    }

    private function cleanColumns(string $columns, $update = 0)
    {
        $columns = explode(",", $columns);
        $clean = [];
        foreach ($columns as $column) {
            $column = trim($column);

            if ($update === 0) {
                if ($column === "donation_book_to_donate") $clean[] = "possessed_book_id";
                elseif ($column === "donation_user") $clean[] = "user_id";
                elseif ($column === "donation_status") $clean[] = "status_id";
                else $clean[] = $column;
            } else {
                $column = str_replace("donation_book_to_donate", "possessed_book_id", $column);
                $column = str_replace("donation_user", "user_id", $column);
                $column = str_replace("donation_status", "status_id", $column);
                $clean[] = $column;
            }
        }
        $columns = implode(", ", $clean);

        return $columns;
    }

    public function delete(int $id): bool
    {
        $statement = $this->connection->prepare("delete from donation where possessed_book_id = :id");
        if ($statement->execute(['id' => $id])) {
            return true;
        } else {
            return false;
        }
    }

    public function getOne(int $id): ?Model
    {
        $statement = $this->connection->prepare("select * from donation where possessed_book_id = :id");
        $result = $statement->execute(['id' => $id]);
        $row = $statement->fetch();

        if (!$result) {
            throw new DatabaseError("Database error: {$statement->errorInfo()}");
        } else {
            if ($row) {
                $instance = $this->modelReflector->newInstance();
                $this->hydrateModel($instance, $row);
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

        $bookToDonate = $entity->getBookToDonate()->getId();
        $columns = $this->cleanColumns($columns, 1);
        $statement = $this->connection->prepare("update {$this->table} set $columns where possessed_book_id = {$bookToDonate}");

        $result = $statement->execute($mappedParams);

        if (!$result) {
            throw new DatabaseError("Database update error: {$statement->errorInfo()}");
        }
        return $this->getOne($entity->getBookToDonate()->getId());
    }
}
