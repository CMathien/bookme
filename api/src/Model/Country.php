<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class Country extends Model
{
    private int $id;
    private string $country;

    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    public function getCountry()
    {
        return $this->country;
    }

    public function setCountry($country)
    {
        $this->country = $country;

        return $this;
    }
}
