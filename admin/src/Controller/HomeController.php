<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Controller\BaseController;

class HomeController extends BaseController
{
    public function __construct()
    {
        $this->title = "Tableau de bord";
        parent::__construct();
    }
}
