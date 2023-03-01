<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/public/style/style.css">
    <title><?php $titre ?></title>
</head>
<body>
    <?php require_once '../View/Commons/Menu.php'; ?>
    <div class='template-content'>
        <h1> <?= $titre ?> </h1>
        <?= $content ?>
    </div>
</body>
</html>
