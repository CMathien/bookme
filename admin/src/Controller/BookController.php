<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Controller\BaseController;

class BookController extends BaseController
{
    public function __construct()
    {
        $this->title = "Livres";
        $this->columns = [
            "ID",
            "Titre",
            "Date de publication",
            "ISBN",
            "Auteurs",
            "Genres"
        ];
        parent::__construct();
    }
}
