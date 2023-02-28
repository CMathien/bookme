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
        if ($key !== "toDonate" && $key !== "toLend")
            $model->{"set" . ucfirst($key)}($value);
    }

    public function create(array $datas): ?object
    {
        $this->validate($datas);
        if (!empty($this->errors)) {
            return null;
        }

        if (isset($datas["toDonate"]) && $datas["toDonate"] == 1) $modelClassName = "Bookme\API\Model\BookToDonate";
        else $modelClassName = "Bookme\API\Model\\" . $this->getClassName();
        $model = new $modelClassName();

        foreach ($datas as $key => $value) {
            $this->iterateProperties($model, $key, $value);
        }

        return $model;
    }
}
