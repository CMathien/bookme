<?php

namespace Bookme\API\Controller;

use Bookme\API\Model\BookToDonate;

class DonationController extends BaseController
{
    public function update(int $id)
    {
        $datas = $this->readInput();
        
        if (isset($datas["banned"]) && $datas["banned"] != null) $className = "BannedUser";
        elseif (isset($datas["admin"]) && $datas["admin"] == 1) $className = "Admin";
        elseif (isset($datas["toDonate"]) && $datas["toDonate"] == 1) $className = "BookToDonate";
        else $className = $this->getClassName();
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
        $record = $dao->getOne($id);
        if (!$record) {
            $response = [
                'status' => strtoupper($className) . '_NOT_FOUND',
                'message' => 'The ' . strtolower($className) . ' was not found',
            ];
            $this->sendResponse($response, 404);
        }
        $bookToDonate = new BookToDonate();
        $bookToDonate->setId($id);
        $object->setBookToDonate($bookToDonate);
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
