<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Controller\BaseController;

class AuthorController extends BaseController
{
    public function __construct()
    {
        $this->title = "Auteurs";
        $this->columns = [
            "ID",
            "Prénom",
            "Nom"
        ];
        parent::__construct();
    }
}
