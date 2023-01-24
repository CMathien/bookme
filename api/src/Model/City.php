<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class City extends Model
{
    private int $id;
    private string $name;
    private Country $country;

    public function getId(): int
    {
        return $this->id;
    }

    public function setId(int $id): City
    {
        $this->id = $id;

        return $this;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function setName(string $name): City
    {
        $this->name = $name;

        return $this;
    }

    public function getCountry(): Country
    {
        return $this->country;
    }

    public function setCountry(Country $country): City
    {
        $this->country = $country;

        return $this;
    }

    public function toArray(): array
    {
        return [
            "id" => $this->getId(),
            "name" => $this->getName(),
            "country" => $this->getCountry()->getId(),
        ];
    }
}
