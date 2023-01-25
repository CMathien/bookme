<?php

namespace Bookme\API\Controller;

use Bookme\API\DataAccess\ZipCodeDAO;

class ZipCodeController extends BaseController
{
    public function linkToCity($zipcode)
    {
        $datas = $this->readInput();
        if (!isset($datas["city_id"])) {
            $response = [
                'status' => 'CITY NOT FOUND',
                'message' => 'Missing city_id in JSON',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        }
        $dao = new ZipCodeDAO($this->db);
        $record = $dao->linkToCity($zipcode, $datas["city_id"]);

        if (false === $record) {
            $response = [
                'status' => 'ERROR',
                'message' => 'Can not link zipcode to city',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        } else {
            $response = [
                'status' => 'SUCCESS',
                'message' => 'Zipcode linked to city',
                'data' => '',
            ];
            $this->sendResponse($response, 200);
        }
    }

    public function unlinkCity($zipcode)
    {
        $dao = new ZipCodeDAO($this->db);
        $record = $dao->unlinkCity($zipcode);

        if (false === $record) {
            $response = [
                'status' => 'ERROR',
                'message' => 'Can not unlink zipcode',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        } else {
            $response = [
                'status' => 'SUCCESS',
                'message' => 'Zipcode unlinked',
                'data' => '',
            ];
            $this->sendResponse($response, 200);
        }
    }
}
