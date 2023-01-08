<?php

namespace Bookme\API\Model;

class BannedUser extends User
{
    private string $date;

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
