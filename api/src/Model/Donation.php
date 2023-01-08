<?php

namespace Bookme\API\Model;

class Donation
{
    private \DateTime $date;
    private string $status;
    private BookToDonate $bookToDonate;
    private User $user;

    public function getDate()
    {
        return $this->date;
    }

    public function setDate($date)
    {
        $this->date = $date;

        return $this;
    }

    public function getStatus()
    {
        return $this->status;
    }

    public function setStatus($status)
    {
        $this->status = $status;

        return $this;
    }

    public function getBookToDonate()
    {
        return $this->bookToDonate;
    }

    public function setBookToDonate($bookToDonate)
    {
        $this->bookToDonate = $bookToDonate;

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
}
