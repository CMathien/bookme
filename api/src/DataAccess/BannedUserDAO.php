<?php

namespace Bookme\API\DataAccess;

use Bookme\API\Component\Model\Model;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;

class BannedUserDAO extends UserDAO
{
    protected function prepareQuery(string $columns, string $placeholders, array $params): array
    {
        $columns = str_replace("banned_user", "user_", $columns);
        $columns = str_replace("user_zip_code", "zipcode", $columns);

        $statement = $this->connection->prepare("insert into user ($columns) values ($placeholders)");
        $result = $statement->execute($params);

        return [$statement, $result];
    }
}
