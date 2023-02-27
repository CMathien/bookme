<?php

namespace Bookme\API\Logic;

use Bookme\API\Model\Genre;
use Bookme\API\Model\Author;
use Bookme\API\DataAccess\BookDAO;

class BookLogic extends BaseLogic
{
    public function iterateProperties($model, $key, $value): void
    {
        if ($key === "author") {
            $id = $value;
            $value = new Author();
            $value->setId($id);
        }
        if ($key === "genre") {
            $id = $value;
            $value = new Genre();
            $value->setId($id);
        }
        if ($key === "isbn") {
            $value = intval($value);
        }

        parent::iterateProperties($model, $key, $value);
    }

    public function isbnExists(int $book, int $isbn)
    {
        $daoClassName = new BookDAO($this->db);
        $result = $daoClassName->getMany(["book_id = $book", "book_isbn = $isbn"]);
        if (!empty($result)) {
            return true;
        } else {
            return false;
        }
    }

    public function authorExists(int $book, int $author)
    {
        $daoClassName = new BookDAO($this->db);
        $result = $daoClassName->getAuthors($book, $author);
        if (!empty($result)) {
            return true;
        } else {
            return false;
        }
    }

    public function genreExists(int $book, int $genre)
    {
        $daoClassName = new BookDAO($this->db);
        $result = $daoClassName->getGenres($book, $genre);
        if (!empty($result)) {
            return true;
        } else {
            return false;
        }
    }
}
