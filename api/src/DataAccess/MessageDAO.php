<?php

namespace Bookme\API\DataAccess;

use Bookme\API\Component\DataAccess\DataAccessObject;

class MessageDAO extends DataAccessObject
{
    protected function prepareQuery(string $columns, string $placeholders, array $params): array
    {
        $statement = $this->connection->prepare("insert into {$this->table} ($columns) values ($placeholders)");
        $result = $statement->execute($params);

        return [$statement, $result];
    }
}
