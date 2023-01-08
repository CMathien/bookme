<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class Book extends Model
{
    protected int $id;
    protected string $title;
    protected string $isbn;
    protected int $releaseYear;
    protected Author $author;

    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    public function getTitle()
    {
        return $this->title;
    }

    public function setTitle($title)
    {
        $this->title = $title;

        return $this;
    }

    public function getIsbn()
    {
        return $this->isbn;
    }

    public function setIsbn($isbn)
    {
        $this->isbn = $isbn;

        return $this;
    }

    public function getReleaseYear()
    {
        return $this->releaseYear;
    }

    public function setReleaseYear($releaseYear)
    {
        $this->releaseYear = $releaseYear;

        return $this;
    }

    public function getAuthor()
    {
        return $this->author;
    }

    public function setAuthor($author)
    {
        $this->author = $author;

        return $this;
    }
}
