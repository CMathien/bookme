<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class Genre extends Model
{
    private int $id;
    private string $label;

    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    public function getLabel()
    {
        return $this->label;
    }

    public function setLabel($label)
    {
        $this->label = $label;

        return $this;
    }

    public function toArray(): array
    {
        return [
            "id" => $this->getId(),
            "label" => $this->getLabel(),
        ];
    }
}
