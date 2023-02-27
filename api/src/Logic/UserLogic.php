<?php

namespace Bookme\API\Logic;

use Bookme\API\Model\Zipcode;
use Bookme\API\DataAccess\UserDAO;
use DateTime;

class UserLogic extends BaseLogic
{
    public function iterateProperties($model, $key, $value): void
    {
        if ($key === "password") {
            $value = password_hash($value, PASSWORD_DEFAULT);
        } elseif ($key === "zipCode") {
            $id = $value;
            $value = new Zipcode();
            $value->setZipCode($id);
        }

        $model->{"set" . ucfirst($key)}($value);
    }

    protected function validate(array $datas)
    {
        if (isset($datas["email"])) {
            if (!$this->isValidEmail($datas["email"])) {
                array_push($this->errors, ["error" => "invalid email", "message" => "the email is not valid"]);
            }
            $this->emailAlreadyExists($datas["email"]);
        }
        if (isset($datas["pseudo"])) $this->pseudoAlreadyExists($datas["pseudo"]);

        if (isset($datas["password"]) && !$this->isValidPassword($datas["password"])) {
            array_push(
                $this->errors,
                [
                    "error" => "invalid password",
                    "message" => "password must contain at least 8 characters and must include number, uppercase and lowercase letters"
                ]
            );
        }

        $this->setErrors($this->errors);
    }

    public function create(array $datas): ?object
    {
        $this->validate($datas);
        if (!empty($this->errors)) {
            return null;
        }

        if (isset($datas["banned"]) && $datas["banned"] != null) $modelClassName = "Bookme\API\Model\BannedUser";
        elseif (isset($datas["admin"]) && $datas["admin"] == 1) $modelClassName = "Bookme\API\Model\Admin";
        else $modelClassName = "Bookme\API\Model\\" . $this->getClassName();
        $model = new $modelClassName();
        foreach ($datas as $key => $value) {
            if ($key != "admin" && $key != "banned") $this->iterateProperties($model, $key, $value);
        }
        if (isset($datas["banned"]) && $datas["banned"] != null) {
            $date = new \DateTime();
            $model->setBanned($date);
        }
        return $model;
    }

    public function pseudoAlreadyExists(string $pseudo)
    {
        $daoClassName = new UserDAO($this->db);
        $result = $daoClassName->getMany(["user_pseudo = \"$pseudo\""]);
        if (!empty($result)) {
            array_push(
                $this->errors,
                [
                    "error" => "invalid pseudo",
                    "message" => "the pseudo already exists"
                ]
            );
        }
    }

    public function emailAlreadyExists(string $email)
    {
        $daoClassName = new UserDAO($this->db);
        $result = $daoClassName->getMany(["user_email = \"$email\""]);
        if (!empty($result)) {
            array_push(
                $this->errors,
                [
                    "error" => "invalid email",
                    "message" => "the email already exists"
                ]
            );
        }
    }

    public function checkPassword($password, $hash)
    {
        if (password_verify($password, $hash)) {
            return true;
        } else {
            return false;
        }
    }

    public function checkBanned($banned)
    {
        if ($banned === 1) {
            return false;
        } else {
            return true;
        }
    }
}
