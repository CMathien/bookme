<?php

namespace Bookme\API\Logic;

use Bookme\API\Model\Country;
use Bookme\API\DataAccess\CityDAO;

class CityLogic extends BaseLogic
{
    public function iterateProperties($model, $key, $value): void
    {
        if ($key === "country") {
            $id = $value;
            $value = new Country();
            $value->setId($id);
        }

        $model->{"set" . ucfirst($key)}($value);
    }

    protected function validate(array $datas)
    {
        $this->cityAlreadyExists($datas["name"], $datas["country"]);
        $this->setErrors($this->errors);
    }

    public function cityAlreadyExists(string $name, int $country)
    {
        $daoClassName = new CityDAO($this->db);
        $result = $daoClassName->getMany(["city_name = \"$name\" and country_id = \"$country\""]);
        if (!empty($result)) {
            array_push(
                $this->errors,
                [
                    "error" => "invalid city",
                    "message" => "the city already exists"
                ]
            );
        }
    }
}
