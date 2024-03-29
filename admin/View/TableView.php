<?php
 
ob_start();
if ($this->className === "Genre") {
    echo "<div class='row text-end'><a href='/genres/new'><span class='btn btn-primary'>+ Genre</span></a></div>";
}
?>

<div class="table-responsive">
    <table class="table table-striped table-sm">
<?php
if (isset($entities) && !empty($entities)) {
    echo "<thead><tr>";
    foreach ($this->columns as $column) {
        echo "<td>" . ucfirst($column) . "</td>";
    }
    echo "<td></td>";
    echo "</tr></thead>";

    foreach ($entities as $entity) {
        echo "<tr>";
        $id = $entity[0];
        foreach ($entity as $k => $property) {
            if (!is_array($property)) {
                if ($k > 0) {
                    if (($this->className === "User" && $k === 3 && $property === null) || $property === false || $property === 0) {
                        $value = "<div class='red text-center'>&cross;</div>";
                    } elseif ($property === true || $property === 1) {
                        $value = "<div class='green text-center'>&check;</div>";
                    } elseif ($property === null || $property === "null") {
                        if ($this->className === "User" && $k === 8) {
                            $value = "<a href='/users/$id/ban' class='btn btn-primary'>Bannir</a>";
                        } else $value = "";
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

        echo "<td align=right>
                <a href='/" . $this->route . "/$id/delete'>
                    <div class='icon-trash'>
                        <div class='trash-lid' style='background-color: red'></div>
                        <div class='trash-container' style='background-color: red'></div>
                        <div class='trash-line-1'></div>
                        <div class='trash-line-2'></div>
                        <div class='trash-line-3'></div>
                    </div>
                </a>
            </td>";

        echo "</tr>";
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
