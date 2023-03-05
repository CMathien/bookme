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
        if ($this->isInitialized("banned")) $array["banned"] = $this->getBanned();
        return $array;
    }
    public function isInitialized($param)
    {
        $rp = new \ReflectionProperty('Bookme\API\Model\BannedUser', $param);
        return $rp->isInitialized($this);
    }
}
