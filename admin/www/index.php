<?php

session_start();

require '../vendor/autoload.php';
header('Content-type: text/html; charset=UTF-8');
$app = new Bookme\Admin\App\App();
$app->run();
