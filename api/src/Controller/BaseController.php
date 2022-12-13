<?php

namespace Bookme\API\Controller;

use Bookme\API\Component\Database\Database;
use PDO;

abstract class BaseController
{
    protected PDO $db;
    
    public function __construct()
    {
        $this->db = new Database(getenv("PDO_DSN"), getenv("PDO_USER"), getenv("PDO_PASSWORD"));
    }

    protected function readInput(): array
    {
        $body = file_get_contents('php://input');
        $datas = json_decode($body, true);
        if (null === $datas) {
            $response = [
                'status' => 'ERROR_BAD_JSON',
                'message' => 'Received malformed JSON',
                'data' => '',
            ];
            $this->sendResponse($response, 400);
        }

        return $datas;
    }

    protected function sendResponse($body, int $httpCode = 200): void
    {
        http_response_code($httpCode);
        header('Content-Type: application/json');
        echo json_encode($body);
        exit;
    }

    protected function getClassName(): string
    {
        $className = str_replace("Bookme\API\Controller\\", "", substr(get_class($this), 0, -10));
        return $className;
    }

    public function list()
    {
        $className = $this->getClassName();
        $classDAO = "Bookme\API\DataAccess\\" . $className . "DAO";
        $dao = new $classDAO($this->db);
        $data = $dao->getMany();

        $response = [
            'status' => strtoupper($className) . '_FOUND',
            'message' => '',
            'count' => count($data),
            'data' => $data,
        ];
        $this->sendResponse($response, 200);
    }

    public function getById(int $id)
    {
        $className = $this->getClassName();
        $classDAO = "Bookme\API\DataAccess\\" . $className . "DAO";
        $dao = new $classDAO($this->db);
        $record = $dao->getById($id);
        if (null === $record) {
            $response = [
                'status' => strtoupper($className) . '_NOT_FOUND',
                'message' => $className . ' not found',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        }

        $response = [
            'status' => strtoupper($className) . '_GET',
            'message' => '',
            'data' => $record->toArray(),
        ];

        $this->sendResponse($response, 200);
    }

    public function create()
    {
        $datas = $this->readInput();

        $className = $this->getClassName();
        $classDAO = "Bookme\API\DataAccess\\" . $className . "DAO";
        $classLogic = "Bookme\API\Logic\\" . $className . "Logic";
        $logic = new $classLogic($this->db);
        $object = $logic->create($datas);
        if (null === $object) {
            $response = [
                'status' => strtoupper($className) . '_NOT_CREATED',
                'message' => $className . ' could not be created',
                'data' => $logic->getErrors(),
            ];
            $this->sendResponse($response, 400);
        }

        // ajout utilisateur dans la bdd => DAO
        $dao = new $classDAO($this->db);
        $object = $dao->save($object);
        if (null === $object) {
            $response = [
                'status' => strtoupper($className) . '_NOT_CREATED',
                'message' => $className . ' could not be created',
                'data' => '',
            ];
            $this->sendResponse($response, 400);
        }

        $response = [
            'status' => strtoupper($className) . '_CREATED',
            'message' => '',
            'data' => $object->toArray(),
        ];
        $this->sendResponse($response, 201);
    }

    public function replace(int $id)
    {
        $datas = $this->readInput();

        $className = $this->getClassName();
        $classDAO = "Bookme\API\DataAccess\\" . $className . "DAO";
        $classLogic = "Bookme\API\Logic\\" . $className . "Logic";

        $logic = new $classLogic($this->db);
        $object = $logic->create($datas);
        if (null === $object) {
            $response = [
                'status' => strtoupper($className) . '_NOT_UPDATED',
                'message' => $className . ' could not be updated',
                'data' => $logic->getErrors(),
            ];
            $this->sendResponse($response, 400);
        }

        $dao = new $classDAO($this->db);
        $object = $dao->update($object);
        if (null === $object) {
            $response = [
                'status' => strtoupper($className) . '_NOT_UPDATED',
                'message' => $className . ' could not be updated',
                'data' => '',
            ];
            $this->sendResponse($response, 400);
        }

        $response = [
            'status' => strtoupper($className) . '_UPDATED',
            'message' => '',
            'data' => $object->toArray(),
        ];
        $this->sendResponse($response, 200);
    }

    public function update(int $id)
    {
         $datas = $this->readInput();
        
        $className = $this->getClassName();
        $classDAO = "Bookme\API\DataAccess\\" . $className . "DAO";
        $classLogic = "Bookme\API\Logic\\" . $className . "Logic";

        $logic = new $classLogic($this->db);
        $object = $logic->create($datas);
        if (null === $object) {
            $response = [
                'status' => strtoupper($className) . '_NOT_UPDATED',
                'message' => $className . ' could not be updated',
                'data' => $logic->getErrors(),
            ];
            $this->sendResponse($response, 400);
        }

        $dao = new $classDAO($this->db);
        $record = $dao->getById($id);
        if (!$record) {
            $response = [
                'status' => strtoupper($className) . '_NOT_FOUND',
                'message' => 'The ' . strtolower($className) . ' was not found',
            ];
            $this->sendResponse($response, 404);
        }

        $result = $dao->update($object, $id);
        if (!$result) {
            $response = [
                'status' => strtoupper($className) . '_NOT_UPDATED',
                'message' => 'An error occured when updating the ' . strtolower($className),
            ];
            $this->sendResponse($response, 400);
        } else {
            $response = [
                'status' => strtoupper($className) . '_UPDATED',
                'message' => '',
                'data' => $result->toArray(),
            ];
            $this->sendResponse($response, 200);
        }
    }
}
