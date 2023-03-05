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

    public function new()
    {
        if (isset($_POST["label"])) {
            $label = htmlentities($_POST['label']);
            if ($label != "") {
                $data = [
                    "label" => $label,
                ];
                $this->post($data);
            } else {
                header('location:/' . $this->route);
                exit;
            }
        } else {
            header('location:/' . $this->route);
            exit;
        }
    }
}
