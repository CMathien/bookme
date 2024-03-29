<?php

namespace Bookme\API\Controller;

use Bookme\API\Logic\UserLogic;
use Bookme\API\DataAccess\PossessedBookDAO;
use Bookme\API\DataAccess\UserDAO;

class UserController extends BaseController
{
    public function listUsersBooks(int $user_id)
    {
        $dao = new PossessedBookDAO($this->db);
        $data = $dao->getMany([$user_id]);

        $response = [
            'status' => 'SUCCESS',
            'message' => '',
            'count' => count($data),
            'data' => $data,
        ];
        $this->sendResponse($response, 200);
    }

    public function checkLoginInfo()
    {
        $datas = $this->readInput();
        $error = 0;
        if (!isset($datas["email"])) {
            $missing = "email";
            $error++;
        }
        if (!isset($datas["password"])) {
            $missing = "password";
            $error++;
        }
        if ($error > 0) {
            $response = [
                'status' => 'MISSING ' . strtoupper($missing),
                'message' => 'Missing ' . $missing . ' in JSON',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        }

        $dao = new UserDAO($this->db);
        $data = $dao->checkPassword($datas["email"]);

        if (!$data) {
            $response = [
                'status' => 'NO LOGIN',
                'message' => 'An error occured when checking the user\'s information',
            ];
            $this->sendResponse($response, 404);
        } else {
            $logic = new UserLogic($this->db);
            if (!$logic->checkPassword($datas["password"], $data["user_password"])) {
                $response = [
                    'status' => 'WRONG PASSWORD'
                ];
                $this->sendResponse($response, 404);
            }
            if (!$logic->checkBanned($data["user_banned"])) {
                $response = [
                    'status' => 'BANNED USER'
                ];
                $this->sendResponse($response, 404);
            }
            $response = [
                'id' => $data["user_id"],
                'admin' => $data["user_admin"],
                'status' => 'AUTHORIZED LOGIN',
            ];
            $this->sendResponse($response, 200);
        }
    }

    public function tryEmail()
    {
        $datas = $this->readInput();
        $params = [
            "user_email = \"" . $datas["email"] . "\""
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

    public function tryPseudo()
    {
        $datas = $this->readInput();
        $params = [
            "user_pseudo = \"" . $datas["pseudo"] . "\""
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
