<?php

namespace Bookme\API\Logic;

use Bookme\API\DataAccess\AuthorDAO;

class AuthorLogic extends BaseLogic
{
    protected function validate(array $datas)
    {
        $this->authorAlreadyExists($datas["firstName"], $datas["lastName"]);
        $this->setErrors($this->errors);
    }

    public function authorAlreadyExists(string $firstname, string $lastname)
    {
        $daoClassName = new AuthorDAO($this->db);
        $result = $daoClassName->getMany(["author_first_name = \"$firstname\"", "author_last_name = \"$lastname\""]);
        if (!empty($result)) {
            array_push(
                $this->errors,
                [
                    "error" => "invalid author",
                    "message" => "the author already exists"
                ]
            );
        }
    }
}
