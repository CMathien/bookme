<?php

namespace Bookme\API\Logic;

use Bookme\API\DataAccess\GenreDAO;

class GenreLogic extends BaseLogic
{
    protected function validate(array $datas)
    {
        $this->labelAlreadyExists($datas["label"]);
        $this->setErrors($this->errors);
    }

    public function labelAlreadyExists(string $label)
    {
        $daoClassName = new GenreDAO($this->db);
        $result = $daoClassName->getMany(["genre_label = \"$label\""]);
        if (!empty($result)) {
            array_push(
                $this->errors,
                [
                    "error" => "invalid label",
                    "message" => "the label already exists"
                ]
            );
        }
    }
}
