<?php

namespace Bookme\API\Component\DataAccess;

interface FromColumn
{
    public static function fromColumn(mixed $column): static;
}
