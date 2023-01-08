<?php

namespace Bookme\API\Model;

class PossessedBook extends Book
{
    protected string $readingStatus;
    protected string $reaction;
    protected string $state;

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
}
