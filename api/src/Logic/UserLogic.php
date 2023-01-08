<?php

namespace Bookme\API\Logic;

class UserLogic extends BaseLogic
{
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
}
