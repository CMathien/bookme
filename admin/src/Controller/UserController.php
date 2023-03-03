<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Controller\BaseController;

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
}
