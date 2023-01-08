<?php

namespace Bookme\API\Model;

class Admin extends User
{
    public function toArray(): array
    {
        $array = parent::toArray();
        $array["admin"] == 1;
        return $array;
    }
}
