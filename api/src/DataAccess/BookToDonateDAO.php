<?php

namespace Bookme\API\DataAccess;

class BookToDonateDAO extends PossessedBookDAO
{
    protected function prepareQuery(string $columns, string $placeholders, array $params): array
    {
        $columns = $this->cleanColumns($columns);
        $columns .= ", possessed_book_to_donate";
        $placeholders .= ", :toDonate";
        $params["toDonate"] = true;
        $statement = $this->connection->prepare("insert into possessed_book ($columns) values ($placeholders)");
        $result = $statement->execute($params);

        return [$statement, $result];
    }
}
