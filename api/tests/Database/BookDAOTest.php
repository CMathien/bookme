<?php

namespace Bookme\API\Tests\Database;

use Bookme\API\Model\Book;
use PHPUnit\Framework\TestCase;
use Bookme\API\DataAccess\BookDAO;
use Bookme\API\Component\Database\Database;
use Bookme\API\Component\DataAccess\Exceptions\DatabaseError;

class BookDAOTest extends TestCase
{
    public function testInstanciateBookDAOAndDatabase()
    {
        $this->expectNotToPerformAssertions();
        $database = new Database(getenv("PDO_DSN"), getenv("PDO_USER"), getenv("PDO_PASSWORD"));
        $bookDAO = new BookDAO($database);

        return [
            "dao" => $bookDAO,
            "database" => $database,
        ];
    }

    /**
     * Test get many items
     *
     * @param array $config configuration
     *
     * @depends testInstanciateBookDAOAndDatabase
     *
     * @return void
     */
    public function testGetManyItems(array $config)
    {
        $dao = $config["dao"];
        $books = $dao->getMany([]);

        $this->assertIsArray($books);
    }

    /**
     * Test Create Book
     *
     * @param array $config configuration
     *
     * @depends testInstanciateBookDAOAndDatabase
     *
     * @return void
     */
    public function testCreateBook(array $config)
    {
        $dao = $config["dao"];
        $book = new Book();
        $book->setTitle("My book")->setReleaseYear(2000);

        /**
         * Declared created Book
         *
         * @var Book $createdBook created Book
         */
        $createdBook = $dao->save($book);

        $this->assertSame($createdBook->getTitle(), "My book");
        $this->assertSame($createdBook->getReleaseYear(), 2000);

        $config["book"] = $createdBook;

        return $config;
    }

    /**
     * Test get one book
     *
     * @param array $config configuration
     *
     * @depends testCreateBook
     *
     * @return void
     */
    public function testGetOneBook(array $config)
    {
        $dao = $config["dao"];
        $book = $config["book"];

        /**
         * Declared retrieved Book
         *
         * @var Book $data retrieved Book
         */
        $data = $dao->getOne($book->getId());

        $this->assertNotNull($data);
        $this->assertSame($data->getId(), $book->getId());
        $this->assertSame($data->getTitle(), $book->getTitle());
        $this->assertSame($data->getReleaseYear(), $book->getReleaseYear());
    }

    /**
     * Test cannot get not found book
     *
     * @param array $config configuration
     *
     * @depends testCreateBook
     *
     * @return void
     */
    public function testCannotGetNotFoundBook(array $config)
    {
        $dao = $config["dao"];
        $book = $dao->getOne(999);
        $this->assertNull($book);
    }

    /**
     * Test update Book
     *
     * @param array $config configuration
     *
     * @depends testCreateBook
     *
     * @return void
     */
    public function testUpdateBook(array $config)
    {
        $dao = $config["dao"];
        $book = $config["book"];

        $newBook = new Book();
        $newBook->setTitle("My book upd")->setReleaseYear(2001)->setId($book->getId());

        $updatedBook = $dao->update($newBook);

        $this->assertNotNull($updatedBook);
        $this->assertSame($updatedBook->getTitle(), "My book upd");
        $this->assertSame($updatedBook->getReleaseYear(), 2001);
    }

    /**
     * Test delete book
     *
     * @param array $config configuration
     *
     * @depends testCreateBook
     *
     * @return void
     */
    public function testDeleteBook(array $config)
    {
        $db = $config["database"];
        $dao = $config["dao"];
        $book = $config["book"];

        $delete = $dao->delete($book->getId());

        $this->assertTrue($delete);
    }
}
