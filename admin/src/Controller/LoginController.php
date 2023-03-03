<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Controller\BaseController;

class LoginController extends BaseController
{
    public function display()
    {
        include_once "../View/" . $this->className . "View.php";
    }

    public function login()
    {
        //verifier que l'utilisateur est connecté
        //verfifier isadmin = true
        //aller dans l'api et voir si useremail existe
        $data = new API();
        $dataApiUser = $data->callAPIGet('users');
    }

    public function traitement()
    {
        //aller dans l'api et voir si useremail existe
        $data = new API();
        $dataApiUser = $data->callAPIGet('users');
        $dataApiUser = (json_decode($dataApiUser));
        $emailAPI = $dataApiUser->data[0]->email;
        $pwAPI = $dataApiUser->data[0]->password;
        $isAdminAPI = $dataApiUser->data[0]->isAdmin;
        //recupére les données du post
        if (isset($_POST) && $_POST != null) {
            $email = htmlentities($_POST['email']);
            $pw = htmlentities($_POST['password']);
            //si le mail est ok si le pw est ok et si l'user est admin
            if ($email == $emailAPI && $pwAPI && $isAdminAPI == true) {
                $_SESSION['access'] = 'admin';
                // var_dump($_SESSION);
                header('location:accueil');
            } else {
                //gérer le cas
                echo 'pas le droit';
            }
        }
    }

    public function logOut()
    {
        unset($_SESSION['access']);
        header('location:login');
    }
}
