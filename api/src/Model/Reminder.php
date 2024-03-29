<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class Reminder extends Model
{
    private int $id;
    private \DateTime $date;

    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;

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
}
