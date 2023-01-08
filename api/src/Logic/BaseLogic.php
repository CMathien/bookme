<?php

namespace Bookme\API\Logic;

abstract class BaseLogic
{
    protected \PDO $db;
    private array $errors;

    public function __construct(\PDO $db)
    {
        $this->db = $db;
        $this->errors = [];
    }

    public function getErrors(): array
    {
        return $this->errors;
    }

    protected function setErrors(array $errors): void
    {
        $this->errors = $errors;
    }

    protected function getClassName(): string
    {
        $className = str_replace("Bookme\API\Logic\\", "", substr(get_class($this), 0, -5));
        return $className;
    }

    public function iterateProperties($model, $key, $value): void
    {
        $model->{"set" . ucfirst($key)}($value);
    }

    public function create(array $datas): ?object
    {
        $this->validate($datas);
        if (!empty($this->errors)) {
            return null;
        }

        $modelClassName = "Bookme\API\Model\\" . $this->getClassName();
        $model = new $modelClassName();

        foreach ($datas as $key => $value) {
            $this->iterateProperties($model, $key, $value);
        }

        return $model;
    }

    protected function isValidEmail(string $email): bool
    {
        return filter_var($email, FILTER_VALIDATE_EMAIL);
    }

    protected function isValidPassword(string $password): bool
    {
        $uppercase = preg_match('@[A-Z]@', $password) === 1;
        $lowercase = preg_match('@[a-z]@', $password) === 1;
        $number = preg_match('@[0-9]@', $password) === 1;

        return ($uppercase && $lowercase && $number && strlen($password) >= 8);
    }

    protected function validate(array $datas)
    {
        $this->setErrors([]);
    }
}
