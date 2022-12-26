<?php

namespace Bookme\API\Component\Authentication;

use Bookme\API\Component\Database\Database;

class Authentication
{
    protected \PDO $db;

    public function __construct()
    {
        $this->db = new Database(getenv("PDO_DSN"), getenv("PDO_USER"), getenv("PDO_PASSWORD"));
    }

	public function generateKey()
	{
		$this->truncateTable();
		$key = md5(uniqid('', true));
		$query = "INSERT INTO api_key (api_key) VALUE (:key);";
		$sth = $this->db->prepare($query);
		$sth->execute(['key' => $key]);
	}

    public function authenticate()
    {
        $key = $_SERVER['HTTP_APIKEY'] ?? '';
		$error = 0;
		if ($key != "") {
			$query = 'SELECT COUNT(1) FROM api_key WHERE api_key = :key;';
			$sth = $this->db->prepare($query);
			$sth->execute(['key' => $key]);
			$result = $sth->fetch();
			if ($result[0] == 0) $error++;
			die;
		}
		else $error++;
		
		if ($error > 0) {
			http_response_code(401);
			echo "Unauthorized";
			exit;
		}
    }

	public function truncateTable()
	{
		$query = "TRUNCATE TABLE api_key;";
        $sth = $this->db->prepare($query);
        $sth->execute();
	}
	
}
