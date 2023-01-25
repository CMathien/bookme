<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class Zipcode extends Model
{
    private string $zipcode;

    public function getZipcode()
    {
        return $this->zipcode;
    }

    public function setZipcode($zipcode)
    {
        $this->zipcode = $zipcode;

        return $this;
    }

    public function toArray()
    {
        return [
            "zipcode" => $this->zipcode,
        ];
    }
}
