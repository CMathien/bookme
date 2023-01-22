<?php

namespace Bookme\API\Model;

class BannedUser extends User
{
    private \DateTime $banned;

    public function getBanned()
    {
        return $this->banned;
    }

    public function setBanned(\DateTime $date)
    {
        $this->banned = $date;

        return $this;
    }

    public function toArray(): array
    {
        $array = parent::toArray();
        $array["banned"] = $this->getBanned();
        return $array;
    }
}
