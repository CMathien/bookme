<?php

namespace Bookme\API\Model;

class PossessedBook extends Book
{
    protected int $id;
    protected int $book;
    protected string $readingStatus;
    protected string $reaction;
    protected string $state;
    protected User $user;

    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    public function getBook()
    {
        return $this->book;
    }

    public function setBook($book)
    {
        $this->book = $book;

        return $this;
    }

    public function getReadingStatus()
    {
        return $this->readingStatus;
    }

    public function setReadingStatus($readingStatus)
    {
        $this->readingStatus = $readingStatus;

        return $this;
    }

    public function getReaction()
    {
        return $this->reaction;
    }

    public function setReaction($reaction)
    {
        $this->reaction = $reaction;

        return $this;
    }

    public function getState()
    {
        return $this->state;
    }

    public function setState($state)
    {
        $this->state = $state;

        return $this;
    }

    public function getUser(): User
    {
        return $this->user;
    }

    public function setUser(User $user): PossessedBook
    {
        $this->user = $user;

        return $this;
    }

    public function toArray(): array
    {
        if ($this->isInitialized("id")) $array['id'] = $this->getId();
        if ($this->isInitialized("readingStatus")) $array['readingStatus'] = $this->getReadingStatus();
        if ($this->isInitialized("reaction")) $array['reaction'] = $this->getReaction();
        if ($this->isInitialized("state")) $array['state'] = $this->getState();
        if ($this->isInitialized("user")) $array['user'] = $this->getUser()->getId();
        if ($this->isInitialized("book")) $array['book'] = $this->getBook();
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
        $rp = new \ReflectionProperty('Bookme\API\Model\PossessedBook', $param);
        return $rp->isInitialized($this);
    }
}
