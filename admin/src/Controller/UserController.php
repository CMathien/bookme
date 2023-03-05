<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Component\Api\Api;
use Bookme\Admin\Controller\BaseController;
use Bookme\Admin\Component\Security\Security;

class UserController extends BaseController
{
    public function __construct()
    {
        $this->title = "Utilisateurs";
        $this->columns = [
            "ID",
            "Pseudo",
            "E-mail",
            "Commentaires publics",
            "Avatar",
            "Balance",
            "Code postal",
            "Administrateur",
            "Bannissement",
        ];
        parent::__construct();
    }

    public function ban(int $id)
    {
        $data = [
            "banned" => 1
        ];
        $this->update($data, $id);
    }
}
