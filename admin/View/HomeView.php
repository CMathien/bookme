<?php ob_start();?>

Hello accueil

<?php
$content = ob_get_clean();
$titre = 'Accueil';
require "Commons/Template.php";
