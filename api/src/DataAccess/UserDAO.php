<?php

namespace Bookme\API\DataAccess;

use Bookme\API\Model\Admin;
use Bookme\API\Model\BannedUser;
use Bookme\API\Component\Model\Model;
use Bookme\API\Component\DataAccess\DataAccessObject;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;

class UserDAO extends DataAccessObject
{
    protected function prepareQuery(string $columns, string $placeholders, array $params): array
    {
        $columns = str_replace("user_zip_code", "zipcode", $columns);

        $statement = $this->connection->prepare("insert into user ($columns) values ($placeholders)");
        $result = $statement->execute($params);

        return [$statement, $result];
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

        if (get_class($entity) === "Bookme\API\Model\User") {
            $params["banned"] = null;
            $columns[] = "user_banned = :banned";
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

        $statement = $this->connection->prepare("update {$this->table} set $columns where {$this->table}_id = {$entity->{'getId'}()}");

        $result = $statement->execute($mappedParams);

        if (!$result) {
            throw new DatabaseError("Database update error: {$statement->errorInfo()}");
        }
        return $this->getOne($entity->{'getId'}());
    }

    public function checkPassword(string $email)
    {
        $statement = $this->connection
            ->prepare("select user_id, user_banned, user_admin, user_password from user where user_email = :email");
        $result = $statement->execute(['email' => $email]);
        $row = $statement->fetch();

        if (!$result) {
            throw new DatabaseError("Database error: {$statement->errorInfo()}");
        } else {
            return $row;
        }
    }

    public function getMany(array $options = []): array
    {
        if (!empty($options)) {
            $where = " where " . implode(" and ", $options);
        }
        $query = "select * from {$this->table}";
        if (isset($where)) $query .= $where;
        $statement = $this->connection->prepare($query);
        $result = $statement->execute();
        $rows = $statement->fetchAll();

        $instances = [];
        if (count($rows) > 0) {
            foreach ($rows as $row) {
                if (isset($row["user_admin"]) && $row["user_admin"] == 1) {
                    $instance = new Admin();
                    $this->modelReflector = new \ReflectionClass("Bookme\API\Model\Admin");
                } elseif (isset($row["user_banned"]) && $row["user_banned"] != null) {
                    $instance = new BannedUser();
                    $this->modelReflector = new \ReflectionClass("Bookme\API\Model\BannedUser");
                } else {
                    $instance = new $this->model();
                    $this->modelReflector = new \ReflectionClass("Bookme\API\Model\User");
                }
                $this->hydrateModel($instance, $row);

                $instances[] = $instance->toArray();
            }
        }
        return $instances;
    }
}
