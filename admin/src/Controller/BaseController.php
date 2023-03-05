<?php

namespace Bookme\Admin\Controller;

use Bookme\Admin\Component\API\API;
use Bookme\Admin\Component\Security\Security;

abstract class BaseController
{
    protected string $className;
    protected string $title;
    protected array $columns;

    public function __construct()
    {
        $className = str_replace(["Controller", "Bookme", "Admin", "/", "\\"], "", get_class($this));
        $this->className = $className;
    }

    public function display()
    {
        if (Security::checkAdmin()) {
            $entity = $this->className;
            $logged = true;
            include_once "../View/" . $this->className . "View.php";
        } else {
            header('location:login');
            exit;
        }
    }

    public function list()
    {
        if (Security::checkAdmin()) {
            $api = new Api();
            $entity = $this->className;
            $result = $api->list($entity);
            $result = json_decode($result, true);
            if (isset($result["data"]) && $result["data"] != "") {
                $entities = $result["data"];
                $entities = $this->loadSubData($entities);
            }
            $logged = true;
            include_once "../View/TableView.php";
        } else {
            header('location:login');
            exit;
        }
    }

    public function getOneAPI(string $entity, int $id)
    {
        $entities = "";
        if (Security::checkAdmin()) {
            $api = new Api();
            $result = $api->getOne($entity, $id);
            $result = json_decode($result, true);
            if (isset($result["data"]) && $result["data"] != "") {
                $entities = $result["data"];
            }
        } else {
            header('location:login');
            exit;
        }
        return $entities;
    }

    public function getOne(int $id)
    {
        if (Security::checkAdmin()) {
            $result = $this->getOneAPI($this->className, $id);
            $entities = json_decode($result, true);
            $logged = true;
            include_once "../View/TableView.php";
        } else {
            header('location:login');
            exit;
        }
    }

    public function loadSubData($entities)
    {
        $clean = [];
        foreach ($entities as $entity) {
            $row = [];
            foreach ($entity as $key => $property) {
                if (!is_array($property)) {
                    $row[] = $property;
                } else {
                    if ($key == "zipcode") {
                        $row[] = $property["zipcode"];
                    } elseif ($key == "author") {
                        $authors = [];
                        foreach ($property as $author) {
                            $new = $this->getOneAPI("author", $author["id"]);
                            $fn = ucfirst($new["first name"]);
                            $ln = strtoupper($new["last name"]);
                            $authors[] = $fn . " " . $ln;
                        }
                        $row[] = $authors;
                    } elseif ($key == "genre") {
                        $genres = [];
                        foreach ($property as $genre) {
                            $new = $this->getOneAPI("genre", $genre["id"]);
                            $genres[] = $new["label"];
                        }
                        $row[] = $genres;
                    } elseif ($key == "banned") {
                        $date = new \DateTime($property["date"]);
                        $row[] = $date->format("d/m/Y");
                    }
                }
            }
            $clean[] = $row;
        }
        return $clean;
    }
}
