<?php

namespace Bookme\Admin\Controller;

use PHPUnit\Framework\MockObject\Api;
use Bookme\Admin\Controller\BaseController;
use Bookme\Admin\Component\Security\Security;

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
