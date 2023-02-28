<?php

namespace Bookme\API\Logic;

use Bookme\API\Model\User;
use Bookme\API\Model\BookToDonate;

class DonationLogic extends BaseLogic
{
    public function iterateProperties($model, $key, $value): void
    {
        if ($key === "bookToDonate") {
            $id = $value;
            $value = new BookToDonate();
            $value->setId($id);
        }
        if ($key === "user") {
            $id = $value;
            $value = new User();
            $value->setId($id);
        }
        if ($key === "date") {
            $value = new \DateTime($value);
        }

        parent::iterateProperties($model, $key, $value);
    }
}
