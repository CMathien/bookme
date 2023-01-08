<?php

namespace Bookme\API\Component\DataAccess;

use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;
use Bookme\API\Component\Database\Database;
use Bookme\API\Component\Model\Model;
use DateTime;
use InvalidArgumentException;
use PDOStatement;
use ReflectionClass;

abstract class DataAccessObject
{
    protected \PDO              $connection;
    protected \ReflectionClass  $modelReflector;
    protected string            $model;
    protected string            $table;

    public function __construct(Database $connection)
    {
        $explodedClassName = explode("\\", get_class($this));
        $explodedClassName = substr(end($explodedClassName), 0, -3);
        $this->model = "Bookme\API\Model\\" . $explodedClassName;
        $this->table = strtolower($explodedClassName);
        $this->connection = $connection;
        $this->modelReflector = new \ReflectionClass($this->model);
    }

    /**
     * Get one entity
     *
     * @param int $id The id of the entity
     *
     * @return Model
     */
    public function getOne(int $id): ?Model
    {
        $statement = $this->connection->prepare("select * from {$this->table} where {$this->table}_id = :id");
        $result = $statement->execute(['id' => $id]);
        $row = $statement->fetch();

        if (!$result) {
            throw new DatabaseError("Database error: {$statement->errorInfo()}");
        } else {
            if ($row) {
                $instance = $this->modelReflector->newInstance();

                $this->hydrateModel($instance, $row);

                return $instance;
            }

            return null;
        }
    }

    /**
     * Get many entities
     *
     * @param array $options Options for retrieving entities
     *
     * @return Model[]
     */
    public function getMany(array $options = []): array
    {
        $statement = $this->connection->prepare("select * from {$this->table}");
        $result = $statement->execute();
        $rows = $statement->fetchAll();

        if (!$result) {
            throw new DatabaseError("Database error: {$statement->errorInfo()}");
        } else {
            $instances = [];
            foreach ($rows as $row) {
                $instance = new $this->model();

                $this->hydrateModel($instance, $row);

                $instances[] = $instance;
            }

            return $instances;
        }
    }

    /**
     * Persist an entity
     *
     * @param Model $entity The entity to persist
     *
     * @return Model|null
     */
    public function save(Model $entity): ?Model
    {
        if (!$entity instanceof $this->model) {
            throw new InvalidArgumentException(
                "Error: expected instance of {$this->model} got " . get_class($entity)
            );
        }

        if ($this->shouldUpdate($entity)) {
            $this->update($entity);
        } else {
            $id = $this->insert($entity);

            if ($this->modelReflector->hasMethod('setId')) {
                $this->modelReflector->getMethod('setId')->invoke($entity, $id);
            }
        }

        return $entity;
    }

    protected function insert(Model $entity): int
    {
        $columns = [];
        $params = [];
        foreach ($this->columnMap() as $propertyName => $columnName) {
            if ($propertyName === 'id')
                continue;

            $columns[] = $columnName;

            $propertyType = $this->modelReflector->getProperty($propertyName)->getValue($entity);

            if (gettype($propertyType) === "object" && !$propertyType instanceof DateTime) {
                $params[$propertyName] = $entity->{"get" . ucfirst($propertyName)}()->getId();
            } else if ($propertyType instanceof DateTime) {
                $params[$propertyName] = $entity->{"get" . ucfirst($propertyName)}()->format("Y-m-d");
            } else {
                $params[$propertyName] = $this->modelReflector->getProperty($propertyName)->getValue($entity);
            }
        }

        $columns = implode(', ', $columns);
        $placeholders = implode(', ', array_map(fn ($e) => ":$e", array_keys($params)));

        $columns = strtolower(
            preg_replace(
                '/(?<=[a-z])([A-Z]+)/',
                '_$1',
                $columns
            )
        );

        $query = $this->prepareQuery($columns, $placeholders, $params);

        if (!$query[1]) {
            throw new DatabaseError("Database insertion error: {$query[0]->errorInfo()}");
        } else {
            return $this->connection->lastInsertId();
        }
    }

    protected function prepareQuery(string $columns, string $placeholders, array $params): array
    {
        $statement = $this->connection->prepare("insert into {$this->table} ($columns) values ($placeholders)");
        $result = $statement->execute($params);

        return [$statement, $result];
    }

    protected function update(Model $entity): void
    {
        $columns = [];
        $params = [];
        foreach ($this->columnMap() as $propertyName => $columnName) {
            if ($propertyName === 'id')
                continue;

            $columns[] = "$columnName = :$propertyName";
            $params[$propertyName] = $this
                ->modelReflector
                ->getProperty($propertyName)
                ->getValue($entity);
        }


        $columns = implode(', ', $columns);

        $statement = $this->connection->prepare("update {$this->table} set $columns where id = {$entity->{'getId'}()}");
        $result = $statement->execute($params);

        if (!$result) {
            throw new DatabaseError("Database update error: {$statement->errorInfo()}");
        }
    }

    /**
     * Delete an entity
     *
     * @param int $id The id of the entity to be deleted
     *
     * @return bool
     */
    public function delete(int $id): bool
    {
        return true;
    }

    /**
     * Determines whether save will insert a new row or update an existing one.
     *
     * @param Model $entity The model to be persisted.
     *
     * @return bool
     */
    protected function shouldUpdate(Model $entity): bool
    {
        // If the id of the model is uninitialized do an insert, otherwise do an update.
        // This won't work for models that don't have an id property, we could instead test
        // for the existance of a hidden dynamic property that is added after hydration.
        // For now we will just allow derived classes to define their own behaviour.
        return $this->modelReflector->getProperty('id')->isInitialized($entity);
    }

    /**
     * Defines mapping between model properties and database columns.
     *
     * @return array
     */
    protected function columnMap(): array
    {
        $map = [];
        foreach ($this->modelReflector->getProperties() as $property) {
            $name = $property->getName();
            $map[$name] = "{$this->table}_$name";
        }
        return $map;
    }

    protected function hydrateModel(Model $instance, array $row): Model
    {
        foreach ($this->columnMap() as $propertyName => $columnName) {
            $property = $this->modelReflector->getProperty($propertyName);

            // Make sure key exists in array
            if (!isset($row[$columnName])) {
                throw new \Exception(
                    "Failed to initialize property '{$propertyName}' of model '{$this->model}', missing column '$columnName'"
                );
            }

            // TODO: convert the column to the appropriate type if we are able to
            $property->setValue($instance, $row[$columnName]);
        }

        $instance->wasLoaded = true;
        return $instance;
    }
}
