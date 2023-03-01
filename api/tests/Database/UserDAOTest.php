<?php

namespace Bookme\API\Tests\Database;

use Bookme\API\Model\User;
use Bookme\API\Model\ZipCode;
use PHPUnit\Framework\TestCase;
use Bookme\API\DataAccess\UserDAO;
use Bookme\API\Component\Database\Database;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;

class UserDAOTest extends TestCase
{
    public function testInstanciateUserDAOAndDatabase()
    {
        $this->expectNotToPerformAssertions();
        $database = new Database(getenv("PDO_DSN"), getenv("PDO_USER"), getenv("PDO_PASSWORD"));
        $userDAO = new UserDAO($database);

        return [
            "dao" => $userDAO,
            "database" => $database,
        ];
    }

    /**
     * Test get many items
     *
     * @param array $config configuration
     *
     * @depends testInstanciateUserDAOAndDatabase
     *
     * @return void
     */
    public function testGetManyItems(array $config)
    {
        $dao = $config["dao"];
        $users = $dao->getMany([]);

        $this->assertIsArray($users);
    }

    /**
     * Test Create User
     *
     * @param array $config configuration
     *
     * @depends testInstanciateUserDAOAndDatabase
     *
     * @return void
     */
    public function testCreateUser(array $config)
    {
        $dao = $config["dao"];
        $user = new User();
        $zipcode = new ZipCode();
        $zipcode->setZipCode(99073);
        $user->setPseudo("usertest")
            ->setEmail("fake@fake.com")
            ->setPassword("Password123")
            ->setAvatar("null")
            ->setPublicComments(1)
            ->setBalance(5)
            ->setZipCode($zipcode);

        /**
         * Declared created User
         *
         * @var User $createdUser created User
         */
        $createdUser = $dao->save($user);

        $this->assertSame($createdUser->getPseudo(), "usertest");
        $this->assertSame($createdUser->getEmail(), "fake@fake.com");
        $this->assertSame($createdUser->getPublicComments(), true);
        $this->assertSame($createdUser->getBalance(), 5);
        $this->assertSame($createdUser->getZipCode()->getZipcode(), "99073");

        $config["user"] = $createdUser;

        return $config;
    }

    /**
     * Test get one user
     *
     * @param array $config configuration
     *
     * @depends testCreateUser
     *
     * @return void
     */
    public function testGetOneUser(array $config)
    {
        $dao = $config["dao"];
        $user = $config["user"];

        /**
         * Declared retrieved User
         *
         * @var User $data retrieved User
         */
        $data = $dao->getOne($user->getId());

        $this->assertNotNull($data);
        $this->assertSame($data->getId(), $user->getId());
        $this->assertSame($data->getPseudo(), $user->getPseudo());
        $this->assertSame($data->getEmail(), $user->getEmail());
        $this->assertSame($data->getPublicComments(), $user->getPublicComments());
        $this->assertSame($data->getBalance(), $user->getBalance());
        $this->assertSame($data->getZipCode()->getZipcode(), $user->getZipCode()->getZipcode());
    }

    /**
     * Test cannot get not found user
     *
     * @param array $config configuration
     *
     * @depends testCreateUser
     *
     * @return void
     */
    public function testCannotGetNotFoundUser(array $config)
    {
        $dao = $config["dao"];
        $user = $dao->getOne(999);
        $this->assertNull($user);
    }

    /**
     * Test update User
     *
     * @param array $config configuration
     *
     * @depends testCreateUser
     *
     * @return void
     */
    public function testUpdateUser(array $config)
    {
        $dao = $config["dao"];
        $user = $config["user"];

        $newUser = new User();

        $newUser->setId($user->getId())
            ->setEmail("fake2@fake2.com")
            ->setAvatar("null")
            ->setBalance(10);

        $updatedUser = $dao->update($newUser);

        $this->assertNotNull($updatedUser);
        $this->assertSame($updatedUser->getPseudo(), "usertest");
        $this->assertSame($updatedUser->getEmail(), "fake2@fake2.com");
        $this->assertSame($updatedUser->getBalance(), 10);
    }

    /**
     * Test delete user
     *
     * @param array $config configuration
     *
     * @depends testCreateUser
     *
     * @return void
     */
    public function testDeleteUser(array $config)
    {
        $db = $config["database"];
        $dao = $config["dao"];
        $user = $config["user"];

        $delete = $dao->delete($user->getId());

        $this->assertTrue($delete);
    }
}
