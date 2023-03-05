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
        if (Security::checkAdmin()) {
            $api = new Api();
            $data = [
                "banned" => 1
            ];
            $result = $api->patch($data, "User", $id);
            $result = json_decode($result, true);
            $logged = true;
            header('location:/users');
            exit;
        } else {
            header('location:login');
            exit;
        }
    }
}
