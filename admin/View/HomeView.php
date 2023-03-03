<?php ob_start();?>

Hello accueil

<?php
$content = ob_get_clean();
$titre = 'Accueil';
$logged = true;
require "Commons/Template.php";
