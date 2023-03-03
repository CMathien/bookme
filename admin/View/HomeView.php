<?php ob_start();?>
<main class="px-3 text-center">
    <img class="mb-4 img-thumbnail" src="public/img/bookme-logo.png">
</main>
<?php
$content = ob_get_clean();
require "Commons/Template.php";
