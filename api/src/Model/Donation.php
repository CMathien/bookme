<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class Donation extends Model
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

    public function toArray(): array
    {
        if ($this->isInitialized("date")) $array['date'] = $this->getDate()->format("Y-m-d");
        if ($this->isInitialized("status")) $array['status'] = $this->getStatus();
        if ($this->isInitialized("bookToDonate")) $array['bookToDonate'] = $this->getBookToDonate()->getId();
        if ($this->isInitialized("user")) $array['user'] = $this->getUser()->getId();
        return $array;
    }

    public function isInitialized($param)
    {
        $rp = new \ReflectionProperty('Bookme\API\Model\Donation', $param);
        return $rp->isInitialized($this);
    }
}
