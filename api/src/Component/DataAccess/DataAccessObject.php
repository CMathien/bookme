<?php

namespace Bookme\API\Component\DataAccess;

use DateTime;
use PDOStatement;
use ReflectionClass;
use InvalidArgumentException;
use Bookme\API\DataAccess\BookDAO;
use Bookme\API\Component\Model\Model;
use Bookme\API\Component\Database\Database;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;

abstract class DataAccessObject
{
    const MODEL_PATH = "Bookme\API\Model\\";
    protected \PDO $connection;
    protected \ReflectionClass $modelReflector;
    protected string $model;
    protected string $table;

    public function __construct(Database $connection)
    {
        $explodedClassName = explode("\\", get_class($this));
        $explodedClassName = substr(end($explodedClassName), 0, -3);
        $this->model = "Bookme\API\Model\\" . $explodedClassName;
        $this->table = strtolower($explodedClassName);
        if ($this->table === "admin") $this->table = "user";
        elseif ($this->table === "banneduser") $this->table = "user";
        elseif ($this->table === "possessedbook") $this->table = "possessed_book";
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
        if (!empty($options)) {
            $where = " where " . implode(" and ", $options);
        }
        $query = "select * from {$this->table}";
        if (isset($where)) $query .= $where;
        $statement = $this->connection->prepare($query);
        $result = $statement->execute();
        $rows = $statement->fetchAll();

        $instances = [];
        if (count($rows) > 0) {
            foreach ($rows as $row) {
                $instance = new $this->model();

                $this->hydrateModel($instance, $row);

                $instances[] = $instance->toArray();
            }
        }
        return $instances;
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
            throw new InvalidArgumentException("Error: expected instance of {$this->model} got " . get_class($entity));
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
            $rp = new \ReflectionProperty(get_class($entity), $propertyName);
            if ($rp->isInitialized($entity)) {
                $columns[] = $columnName;

                $propertyType = $this->modelReflector->getProperty($propertyName)->getValue($entity);

                if (gettype($propertyType) === "object" && !$propertyType instanceof DateTime) {
                    if ($propertyName == "zipCode") $params[$propertyName] = $entity->{"get" . ucfirst($propertyName)}()->getZipCode();
                    else $params[$propertyName] = $entity->{"get" . ucfirst($propertyName)}()->getId();
                } else if ($propertyType instanceof DateTime) {
                    $params[$propertyName] = $entity->{"get" . ucfirst($propertyName)}()->format("Y-m-d H:i:s");
                } else {
                    $params[$propertyName] = $this->modelReflector->getProperty($propertyName)->getValue($entity);
                }
            }
        }

        $columns = implode(', ', $columns);
        $placeholders = implode(', ', array_map(fn ($e) => ":$e", array_keys($params)));
        $columns = $this->switchCaseType($columns);

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

    public function update(Model $entity): ?Model
    {
        $columns = [];
        $params = [];

        foreach ($this->columnMap() as $propertyName => $columnName) {
            if ($propertyName === 'id')
                continue;
            $rp = new \ReflectionProperty(get_class($entity), $propertyName);
            if ($rp->isInitialized($entity)) {
                $columns[] = "{$this->switchCaseType($columnName)} = :$propertyName";
                $params[$propertyName] = $this
                    ->modelReflector
                    ->getProperty($propertyName)
                    ->getValue($entity);
            }
        }

        $columns = implode(', ', $columns);

        $mappedParams = array_map(
            function ($e) {
                if ($e instanceof Model) {
                    return $e->{'getId'}();
                } else if ($e instanceof \DateTime) {
                    if ($e != null) {
                        return $e->format('Y-m-d H:i:s');
                    } else return null;
                }
                return $e;
            },
            $params
        );

        $statement = $this->connection->prepare("update {$this->table} set $columns where {$this->table}_id = {$entity->{'getId'}()}");

        $result = $statement->execute($mappedParams);

        if (!$result) {
            throw new DatabaseError("Database update error: {$statement->errorInfo()}");
        }
        return $this->getOne($entity->{'getId'}());
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
        $statement = $this->connection->prepare("delete from {$this->table} where {$this->table}_id = :id");
        if ($statement->execute(['id' => $id])) {
            return true;
        } else {
            return false;
        }
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

            $reflectionProperty = new \ReflectionProperty($property->class, $property->name);
            $type = $reflectionProperty->getType()->getName();

            $columnName = $this->switchCaseType($columnName);
            if ($columnName == "user_zip_code") $columnName = "zipcode";
            elseif ($columnName == "city_country") $columnName = "country_id";

            if (!isset($row[$columnName])
                && $columnName != "user_banned"
                && $columnName != "book_author"
                && $columnName != "book_isbn"
                && $columnName != "book_genre"
                && $columnName != "possessed_book_author"
                && $columnName != "possessed_book_isbn"
                && $columnName != "possessed_book_genre"
                && $columnName != "possessed_book_reaction"
            ) {
                throw new \Exception(
                    "Failed to initialize property '{$propertyName}' of model '{$this->model}', missing column '$columnName'"
                );
            }

            if ($type === "DateTime") {
                if ($row[$columnName] != null) {
                    $property->setValue($instance, new DateTime($row[$columnName]));
                }
            } else if (str_starts_with($type, self::MODEL_PATH)) {
                $object = new $type();
                if ($type == "Bookme\API\Model\ZipCode") $object->setZipCode($row[$columnName]);
                else $object->setId($row[$columnName]);
                $property->setValue($instance, $object);
            } else if ($columnName === "book_author"
                || $columnName === "book_genre"
                || $columnName === "possessed_book_author"
                || $columnName === "possessed_book_genre"
            ) {
                continue;
            } else {
                if ($row[$columnName] != null) $property->setValue($instance, $row[$columnName]);
            }
        }
        return $instance;
    }

    protected function switchCaseType(string $attribute): string
    {
        return strtolower(
            preg_replace(
                '/(?<=[a-z])([A-Z]+)/',
                '_$1',
                $attribute
            )
        );
    }
}
