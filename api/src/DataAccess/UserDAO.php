<?php

namespace Bookme\API\DataAccess;

use Bookme\API\Component\DataAccess\DataAccessObject;

class UserDAO extends DataAccessObject
{
    protected function prepareQuery(string $columns, string $placeholders, array $params): array
    {
        $columns = str_replace("user_zip_code", "zipcode", $columns);

        $statement = $this->connection->prepare("insert into user ($columns) values ($placeholders)");
        $result = $statement->execute($params);

        return [$statement, $result];
    }
}
