<?php

namespace Bookme\API\Model;

use Bookme\API\Model\Genre;
use Bookme\API\Component\Model\Model;

class Book extends Model
{
    protected int $id;
    protected string $title;
    protected string $isbn;
    protected int $releaseYear;
    protected array $author;
    protected array $genre;

    public function __toString()
    {
        return $this->title;
    }

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

    public function getAuthor(): array
    {
        return $this->author;
    }

    public function setAuthor(array $author)
    {
        $this->author = $author;

        return $this;
    }

    public function addAuthor(Author $author)
    {
        $this->author[] = $author;
    }

    public function getGenre(): array
    {
        return $this->genre;
    }

    public function setGenre(array $genre)
    {
        $this->genre = $genre;

        return $this;
    }

    public function addGenre(Genre $genre)
    {
        $this->genre[] = $genre;
    }

    public function toArray(): array
    {
        if ($this->isInitialized("id")) $array['id'] = $this->getId();
        if ($this->isInitialized("title")) $array['title'] = $this->getTitle();
        if ($this->isInitialized("releaseYear")) $array['releaseYear'] = $this->getReleaseYear();
        if ($this->isInitialized("isbn")) $array['isbn'] = $this->getIsbn();
        if ($this->isInitialized("author")) {
            foreach ($this->getAuthor() as $author) {
                $array['author'][] = $author->toArray();
            }
        }
        if ($this->isInitialized("genre")) {
            foreach ($this->getGenre() as $genre) {
                $array['genre'][] = $genre->toArray();
            }
        }
        return $array;
    }

    public function isInitialized($param)
    {
        $rp = new \ReflectionProperty('Bookme\API\Model\Book', $param);
        return $rp->isInitialized($this);
    }
}
