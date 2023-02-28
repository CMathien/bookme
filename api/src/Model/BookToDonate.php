<?php

namespace Bookme\API\Model;

class BookToDonate extends PossessedBook
{
    public function toArray(): array
    {
        $array = parent::toArray();
        $array["toDonate"] = true;
        return $array;
    }
}
