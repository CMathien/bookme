<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Controller\BaseController;

class GenreController extends BaseController
{
    public function __construct()
    {
        $this->title = "Genres";
        $this->columns = [
            "ID",
            "Label"
        ];
        parent::__construct();
    }
}
