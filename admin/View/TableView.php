<?php ob_start();?>

<div class="table-responsive">
    <table class="table table-striped table-sm">
<?php
if (isset($entities) && !empty($entities)) {
    echo "<thead><tr>";
    foreach ($this->columns as $column) {
        echo "<td>" . ucfirst($column) . "</td>";
    }
    echo "</tr></thead>";
    echo "<tbody>";
    foreach ($entities as $entity) {
        echo "<tr>";
        foreach ($entity as $k => $property) {
            if (!is_array($property)) {
                if ($k > 0) {
                    if ($property === false || $property === 0) {
                        $value = "<div class='red text-center'>&cross;</div>";
                    } elseif ($property === true || $property === 1) {
                        $value = "<div class='green text-center'>&check;</div>";
                    } elseif ($property === null || $property === "null") {
                        $value = "";
                    } else {
                        $value = $property;
                    }
                } else {
                    $value = $property;
                }
            } else {
                $value = "<ul>";
                foreach ($property as $row) {
                    $value .= "<li>" . $row . "</li>";
                }
                $value .= "</ul>";
            }
            echo "<td>$value</td>";
        }
        echo "</tr>";
        echo "</tbody>";
    }
} else {
    echo "Aucun résultat";
}
?>
        </tbody>
    </table>
</div>


<?php
$content = ob_get_clean();
require "Commons/Template.php";
