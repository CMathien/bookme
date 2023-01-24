<?php

namespace Bookme\API\DataAccess;

use Bookme\API\Component\Model\Model;
use Bookme\API\Component\DataAccess\DataAccessObject;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;

class CityDAO extends DataAccessObject
{
    protected function columnMap(): array
    {
        $map = [];
        foreach ($this->modelReflector->getProperties() as $property) {
            $name = $property->getName();
            if ($name === "country") $map[$name] = "country_id";
            else $map[$name] = "{$this->table}_$name";
        }
        return $map;
    }
}
