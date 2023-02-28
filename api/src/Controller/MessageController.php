<?php

namespace Bookme\API\Controller;

class MessageController extends BaseController
{
    public function listAllUserMessages(int $id)
    {
        $className = $this->getClassName();
        $classDAO = "Bookme\API\DataAccess\\" . $className . "DAO";
        $dao = new $classDAO($this->db);
        $data = $dao->getMany(["(message_sender = $id or message_recipient = $id)"]);

        $response = [
            'status' => strtoupper($className) . '_FOUND',
            'message' => '',
            'count' => count($data),
            'data' => $data,
        ];
        $this->sendResponse($response, 200);
    }

    public function listUsersMessagesWithSpecificUser(int $id, int $id2)
    {
        $className = $this->getClassName();
        $classDAO = "Bookme\API\DataAccess\\" . $className . "DAO";
        $dao = new $classDAO($this->db);
        $params = [
            "(message_sender = $id or message_recipient = $id)",
            "(message_sender = $id2 or message_recipient = $id2)"
        ];
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
