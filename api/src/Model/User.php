<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class User extends Model
{
    protected int $id;
    protected string $pseudo;
    protected string $email;
    protected string $password;
    protected bool $publicComments;
    protected string $avatar;
    protected int $balance;
    protected ZipCode $zipCode;

    public function __toString()
    {
        return $this->getPseudo();
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

    public function getPseudo()
    {
        return $this->pseudo;
    }

    public function setPseudo($pseudo)
    {
        $this->pseudo = $pseudo;

        return $this;
    }

    public function getEmail()
    {
        return $this->email;
    }

    public function setEmail($email)
    {
        $this->email = $email;

        return $this;
    }

    public function getPassword()
    {
        return $this->password;
    }

    public function setPassword($password)
    {
        $this->password = $password;

        return $this;
    }

    public function getPublicComments()
    {
        return $this->publicComments;
    }

    public function setPublicComments($publicComments)
    {
        $this->publicComments = $publicComments;

        return $this;
    }

    public function getAvatar()
    {
        return $this->avatar;
    }

    public function setAvatar($avatar)
    {
        $this->avatar = $avatar;

        return $this;
    }

    public function getBalance()
    {
        return $this->balance;
    }

    public function setBalance($balance)
    {
        $this->balance = $balance;

        return $this;
    }

    public function getZipCode()
    {
        return $this->zipCode;
    }

    public function setZipCode($zipCode)
    {
        $this->zipCode = $zipCode;

        return $this;
    }

    public function toArray(): array
    {
        if ($this->isInitialized("id")) $array['id'] = $this->getId();
        if ($this->isInitialized("pseudo")) $array['pseudo'] = $this->getPseudo();
        if ($this->isInitialized("email")) $array['email'] = $this->getEmail();
        if ($this->isInitialized("publicComments")) $array['publicComments'] = $this->getPublicComments();
        else $array['publicComments'] = null;
        if ($this->isInitialized("avatar")) $array['avatar'] = $this->getAvatar();
        if ($this->isInitialized("balance")) $array['balance'] = $this->getBalance();
        else $array['balance'] = null;
        if ($this->isInitialized("zipCode")) $array['zipcode'] = ["zipcode" => $this->getZipCode()->getZipCode()];
        $array['admin'] = 0;
        $array['banned'] = null;
        return $array;
    }

    public function isInitialized($param)
    {
        $rp = new \ReflectionProperty('Bookme\API\Model\User', $param);
        return $rp->isInitialized($this);
    }
}
