<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Component\API\API;
use Bookme\Admin\Controller\BaseController;
use Bookme\Admin\Component\Security\Security;

class LoginController extends BaseController
{
    public function __construct()
    {
        $this->title = "Se connecter";
        parent::__construct();
    }
    public function display($unauthorized = 0)
    {
        if (Security::checkAdmin()) {
            header('location:home');
            exit;
        } else {
            $logged = false;

            include_once "../View/" . $this->className . "View.php";
        }
    }

    public function logIn()
    {
        unset($_SESSION['admin']);
        if (isset($_POST["email"]) && isset($_POST["password"])) {
            $email = htmlentities($_POST['email']);
            $password = htmlentities($_POST['password']);
            if ($email != "" && $password != "") {
                $data = [
                    "email" => $email,
                    "password" => $password,
                ];
                $api = new API();
                $result = $api->login($data);

                $result = json_decode($result, true);
                if (isset($result["admin"]) && $result["admin"] == 1) {
                    $_SESSION['admin'] = "admin";
                    header("location:home");
                    exit;
                } else {
                    $this->display(1);
                }
            }
        }
    }

    public function logOut()
    {
        unset($_SESSION['admin']);
        header('location:login');
        exit;
    }
}
