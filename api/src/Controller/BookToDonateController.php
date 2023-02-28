<?php

namespace Bookme\API\Controller;

class BookToDonateController extends PossessedBookController
{
    public function list()
    {
        $classDAO = "Bookme\API\DataAccess\BookToDonateDAO";
        $dao = new $classDAO($this->db);
        $data = $dao->getMany(["possessed_book_to_donate = 1"]);

        $response = [
            'status' => 'BOOK_TO_DONATE_FOUND',
            'message' => '',
            'count' => count($data),
            'data' => $data,
        ];
        $this->sendResponse($response, 200);
    }
}
