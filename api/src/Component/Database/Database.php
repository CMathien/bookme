<?php

namespace Bookme\API\Component\Database;

use PDO;
use PDOException;

class Database extends PDO
{
    public function __construct(string $dsn, string $user, string $password)
    {
        try {
            parent::__construct($dsn, $user, $password);
        } catch (PDOException $exception) {
            http_response_code(500);
            echo json_encode(["error" => "Database error", "message" => 'Connection failed: ' . $exception->getMessage()]);
            exit;
        }
    }
}
