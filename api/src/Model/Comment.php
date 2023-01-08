<?php

namespace Bookme\API\Model;

class Comment
{
    private string $content;
    private \DateTime $date;
    private bool $suggestion;
    private User $user;
    private PossessedBook $possessedBook;
    
    public function getContent()
    {
        return $this->content;
    }

    public function setContent($content)
    {
        $this->content = $content;

        return $this;
    }

    public function getDate()
    {
        return $this->date;
    }

    public function setDate($date)
    {
        $this->date = $date;

        return $this;
    }

    public function getSuggestion()
    {
        return $this->suggestion;
    }


    public function setSuggestion($suggestion)
    {
        $this->suggestion = $suggestion;

        return $this;
    }

    public function getUser()
    {
        return $this->user;
    }

    public function setUser($user)
    {
        $this->user = $user;

        return $this;
    }

    public function getPossessedBook()
    {
        return $this->possessedBook;
    }

    public function setPossessedBook($possessedBook)
    {
        $this->possessedBook = $possessedBook;

        return $this;
    }
}
