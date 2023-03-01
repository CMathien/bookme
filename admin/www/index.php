<?php

session_start();

require '../vendor/autoload.php';

$app = new Bookme\Admin\App\App();
$app->run();
