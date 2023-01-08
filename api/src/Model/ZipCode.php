<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class ZipCode extends Model
{
    private string $zipCode;
    private City $city;

    public function getZipCode()
    {
        return $this->zipCode;
    }

    public function setZipCode($zipCode)
    {
        $this->zipCode = $zipCode;

        return $this;
    }

    public function getCity()
    {
        return $this->city;
    }

    public function setCity($city)
    {
        $this->city = $city;

        return $this;
    }
}
