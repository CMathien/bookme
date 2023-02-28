<?php

namespace Bookme\API\Logic;

use Bookme\API\Model\User;

class MessageLogic extends BaseLogic
{
    public function iterateProperties($model, $key, $value): void
    {
        if ($key === "sender" || $key === "recipient") {
            $id = $value;
            $value = new User();
            $value->setId($id);
        }

        parent::iterateProperties($model, $key, $value);
    }
}
