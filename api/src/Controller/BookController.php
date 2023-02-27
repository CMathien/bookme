<?php

namespace Bookme\API\Controller;

use Bookme\API\Logic\BookLogic;
use Bookme\API\DataAccess\BookDAO;

class BookController extends BaseController
{
    public function linkToIsbn($book)
    {
        $datas = $this->readInput();
        if (!isset($datas["isbn"])) {
            $response = [
                'status' => 'ISBN NOT FOUND',
                'message' => 'Missing isbn in JSON',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        }

        $logic = new BookLogic($this->db);
        $dao = new BookDAO($this->db);

        if ($logic->isbnExists($book, $datas["isbn"])) {
            $dao->unlinkIsbn($datas["isbn"]);
        }

        $record = $dao->linkToIsbn($book, $datas["isbn"]);

        if (false === $record) {
            $response = [
                'status' => 'ERROR',
                'message' => 'Can not link ISBN to book',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        } else {
            $response = [
                'status' => 'SUCCESS',
                'message' => 'ISBN linked to book',
                'data' => '',
            ];
            $this->sendResponse($response, 200);
        }
    }

    public function unlinkIsbn($isbn)
    {
        $dao = new BookDAO($this->db);
        $record = $dao->unlinkIsbn($isbn);

        if (false === $record) {
            $response = [
                'status' => 'ERROR',
                'message' => 'Can not unlink ISBN',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        } else {
            $response = [
                'status' => 'SUCCESS',
                'message' => 'ISBN unlinked',
                'data' => '',
            ];
            $this->sendResponse($response, 200);
        }
    }

    public function linkToAuthor($book)
    {
        $datas = $this->readInput();
        if (!isset($datas["author_id"])) {
            $response = [
                'status' => 'AUTHOR NOT FOUND',
                'message' => 'Missing author_id in JSON',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        }

        $logic = new BookLogic($this->db);
        $dao = new BookDAO($this->db);

        if ($logic->authorExists($book, $datas["author_id"])) {
            $dao->unlinkAuthor($book, $datas["author_id"]);
        }

        $record = $dao->linkToAuthor($book, $datas["author_id"]);

        if (false === $record) {
            $response = [
                'status' => 'ERROR',
                'message' => 'Can not link author to book',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        } else {
            $response = [
                'status' => 'SUCCESS',
                'message' => 'Author linked to book',
                'data' => '',
            ];
            $this->sendResponse($response, 200);
        }
    }

    public function unlinkAuthor($book, $author)
    {
        $dao = new BookDAO($this->db);
        $record = $dao->unlinkAuthor($book, $author);

        if (false === $record) {
            $response = [
                'status' => 'ERROR',
                'message' => 'Can not unlink author',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        } else {
            $response = [
                'status' => 'SUCCESS',
                'message' => 'Author unlinked',
                'data' => '',
            ];
            $this->sendResponse($response, 200);
        }
    }

    public function linkToGenre($book)
    {
        $datas = $this->readInput();
        if (!isset($datas["genre_id"])) {
            $response = [
                'status' => 'GENRE NOT FOUND',
                'message' => 'Missing genre_id in JSON',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        }

        $logic = new BookLogic($this->db);
        $dao = new BookDAO($this->db);

        if ($logic->genreExists($book, $datas["genre_id"])) {
            $dao->unlinkGenre($book, $datas["genre_id"]);
        }

        $record = $dao->linkToGenre($book, $datas["genre_id"]);

        if (false === $record) {
            $response = [
                'status' => 'ERROR',
                'message' => 'Can not link genre to book',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        } else {
            $response = [
                'status' => 'SUCCESS',
                'message' => 'Genre linked to book',
                'data' => '',
            ];
            $this->sendResponse($response, 200);
        }
    }

    public function unlinkGenre($book, $genre)
    {
        $dao = new BookDAO($this->db);
        $record = $dao->unlinkGenre($book, $genre);

        if (false === $record) {
            $response = [
                'status' => 'ERROR',
                'message' => 'Can not unlink genre',
                'data' => '',
            ];
            $this->sendResponse($response, 404);
        } else {
            $response = [
                'status' => 'SUCCESS',
                'message' => 'Genre unlinked',
                'data' => '',
            ];
            $this->sendResponse($response, 200);
        }
    }
}
