<?php

namespace Bookme\Admin\Component\Security;

class Security
{
    public static function checkAdmin()
    {
        return (isset($_SESSION['admin']) && $_SESSION['admin'] === "admin");
    }
}
