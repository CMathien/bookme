<?php

ob_start();
echo "<form class='col-6 mx-auto text-center' method='POST'>";
$inputs = $this->columns;
array_shift($inputs);
foreach ($inputs as $input) {
    echo "<input name='" . strtolower($input) . "' placeholder='" . ucfirst($input) . "' class='form-control m-1' " . ucfirst($input) . ">";
}
echo "<button type='submit' class='btn btn-primary mt-2'>Créer</button>";
echo "</form>";
$content = ob_get_clean();
require "Commons/Template.php";
