<?php

namespace Bookme\API\DataAccess;

use Bookme\API\Component\Model\Model;
use Bookme\API\Component\DataAccess\DataAccessObject;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;

class ZipCodeDAO extends DataAccessObject
{
    protected function columnMap(): array
    {
        $map = [];
        foreach ($this->modelReflector->getProperties() as $property) {
            $name = $property->getName();
            $map[$name] = "$name";
        }
        return $map;
    }

    public function getOne(int $id): ?Model
    {
        $statement = $this->connection->prepare("select * from {$this->table} where zipcode = :id");
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

    protected function shouldUpdate(Model $entity): bool
    {
        return false;
    }

    public function delete(int $id): bool
    {
        $statement = $this->connection->prepare("delete from {$this->table} where zipcode = :id");
        if ($statement->execute(['id' => $id])) {
            return true;
        } else {
            return false;
        }
    }

    public function linkToCity($zipcode, $city)
    {
        $statement = $this->connection->prepare("insert into zipcode_city (zipcode, city_id) values (:zipcode, :id)");
        if ($statement->execute(['id' => $city, 'zipcode' => $zipcode])) {
            return true;
        } else {
            return false;
        }
    }

        
    public function unlinkCity($zipcode)
    {
        $statement = $this->connection->prepare("delete from zipcode_city where zipcode = :zipcode");
        if ($statement->execute(['zipcode' => $zipcode])) {
            return true;
        } else {
            return false;
        }
    }
}
