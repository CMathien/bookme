<?php

namespace Bookme\API\Logic;

use Bookme\API\Model\User;

class PossessedBookLogic extends BookLogic
{
    public function iterateProperties($model, $key, $value): void
    {
        if ($key === "user") {
            $id = $value;
            $value = new User();
            $value->setId($id);
        }

        $model->{"set" . ucfirst($key)}($value);
    }
}
