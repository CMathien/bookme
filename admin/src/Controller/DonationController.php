<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Controller\BaseController;

class DonationController extends BaseController
{
    public function __construct()
    {
        $this->title = "Dons";
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
