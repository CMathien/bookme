<?php

namespace Bookme\API\DataAccess;

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
}
