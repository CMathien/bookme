<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class Author extends Model
{
    private int $id;
    private string $firstName;
    private string $lastName;

    public function __toString()
    {
        $firstName = ucfirst($this->getFirstName());
        $lastName = strtoupper($this->getLastName());
        return $firstName . " " . $lastName;
    }

    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    public function getFirstName()
    {
        return $this->firstName;
    }

    public function setFirstName($firstName)
    {
        $this->firstName = $firstName;

        return $this;
    }

    public function getLastName()
    {
        return $this->lastName;
    }

    public function setLastName($lastName)
    {
        $this->lastName = $lastName;

        return $this;
    }

    public function toArray(): array
    {
        if ($this->isInitialized("id")) $array["id"] = $this->getId();
        if ($this->isInitialized("firstName")) $array["first name"] = $this->getFirstName();
        if ($this->isInitialized("lastName")) $array["last name"] = $this->getLastName();
        return $array;
    }

    public function isInitialized($param)
    {
        $rp = new \ReflectionProperty('Bookme\API\Model\Author', $param);
        return $rp->isInitialized($this);
    }
}
