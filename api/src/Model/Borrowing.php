<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class Borrowing extends Model
{
    private \DateTime $startDate;
    private \DateTime $endDate;
    private string $status;
    private BookToLend $bookToLend;
    private User $user;

    public function getStartDate()
    {
        return $this->startDate;
    }

    public function setStartDate($startDate)
    {
        $this->startDate = $startDate;

        return $this;
    }

    public function getEndDate()
    {
        return $this->endDate;
    }

    public function setEndDate($endDate)
    {
        $this->endDate = $endDate;

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

    public function getBookToLend()
    {
        return $this->bookToLend;
    }

    public function setBookToLend($bookToLend)
    {
        $this->bookToLend = $bookToLend;

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

    public function returnBook()
    {
    }
}
