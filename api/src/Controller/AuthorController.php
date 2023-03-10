<?php

namespace Bookme\API\Controller;

class AuthorController extends BaseController
{
    public function tryName()
    {
        $datas = $this->readInput();
        $params = [
            "author_last_name = \"" . $datas["lastName"] . "\"",
            "author_first_name = \"" . $datas["firstName"] . "\""
        ];
        $className = $this->getClassName();
        $classDAO = "Bookme\API\DataAccess\\" . $className . "DAO";
        $dao = new $classDAO($this->db);
        $data = $dao->getMany($params);

        $response = [
            'status' => strtoupper($className) . '_FOUND',
            'message' => '',
            'count' => count($data),
            'data' => $data,
        ];
        $this->sendResponse($response, 200);
    }
}
