<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Component\Security\Security;

abstract class BaseController
{
    protected string $className;

    public function __construct()
    {
        $className = str_replace(["Controller", "Bookme", "Admin", "/", "\\"], "", get_class($this));
        $this->className = $className;
    }

    public function display()
    {
        if (Security::checkAdmin()) {
            include_once "../View/" . $this->className . "View.php";
        } else {
            header('location:login');
        }
    }
}
