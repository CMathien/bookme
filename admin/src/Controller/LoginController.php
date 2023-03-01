<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Controller\BaseController;

class LoginController extends BaseController
{
    public function display()
    {
        include_once "../View/" . $this->className . "View.php";
    }
}
