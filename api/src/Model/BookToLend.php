<?php

namespace Bookme\API\Model;

class BookToLend extends PossessedBook
{
    public function toArray(): array
    {
        $array = parent::toArray();
        $array["toLend"] = true;
        return $array;
    }
}
