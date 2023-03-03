<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="apple-touch-icon" sizes="180x180" href="public/img/bookme-apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="public/img/bookme-favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="public/img/bookme-favicon-16x16.png">
    <link rel="manifest" href="public/site.webmanifest">
    <link rel="stylesheet" href="/public/style/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Radley">
    <link rel="stylesheet" href="/public/style/style.css">
    <title><?php $titre ?></title>
</head>
<body>
    <?php
    if ($logged === true) require_once '../View/Commons/Header.php'; ?>
    <?= $content ?>
    <?php if ($logged === true) require_once '../View/Commons/Footer.php'; ?>
</body>
<script type='application/javascript' src='/public/js/bootstrap.bundle.min.js'></script>
<script type='application/javascript' src='/public/js/feather.min.js'></script>
</html>
