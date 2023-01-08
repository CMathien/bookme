<?php

namespace Bookme\API\Logic;

use Bookme\API\Model\ZipCode;

class UserLogic extends BaseLogic
{
    public function iterateProperties($model, $key, $value): void
    {
        if ($key === "password") {
            $value = password_hash($value, PASSWORD_DEFAULT);
        } elseif ($key === "zipCode") {
            $id = $value;
            $value = new ZipCode();
            $value->setZipCode($id);
        }

        $model->{"set" . ucfirst($key)}($value);
    }

    protected function validate(array $datas)
    {
        $errors = [];

        if (!$this->isValidEmail($datas["email"])) {
            array_push($errors, ["error" => "invalid email", "message" => "the email is not valid"]);
        }

        if (!$this->isValidPassword($datas["password"])) {
            array_push(
                $errors,
                [
                    "error" => "invalid password",
                    "message" => "password must contain at least 8 characters and must include number, uppercase and lowercase letters"
                ]
            );
        }

        $this->setErrors($errors);
    }

    public function create(array $datas): ?object
    {
        $this->validate($datas);
        if (!empty($this->errors)) {
            return null;
        }

        if ($datas["admin"] == 1) $modelClassName = "Bookme\API\Model\Admin";
        else $modelClassName = "Bookme\API\Model\\" . $this->getClassName();
        $model = new $modelClassName();

        foreach ($datas as $key => $value) {
            if ($key != "admin") $this->iterateProperties($model, $key, $value);
        }

        return $model;
    }
}
