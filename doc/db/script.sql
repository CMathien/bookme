DROP DATABASE IF EXISTS bookme;
CREATE DATABASE bookme;
USE bookme;

DROP TABLE IF EXISTS book;
CREATE TABLE book(
   book_id INT NOT NULL AUTO_INCREMENT,
   book_title VARCHAR(255) NOT NULL,
   book_release_year INT NOT NULL,
   PRIMARY KEY(book_id)
);

DROP TABLE IF EXISTS author;
CREATE TABLE author(
   author_id INT NOT NULL AUTO_INCREMENT,
   author_last_name VARCHAR(255) NOT NULL,
   author_first_name VARCHAR(50) NOT NULL,
   PRIMARY KEY(author_id)
);

DROP TABLE IF EXISTS genre;
CREATE TABLE genre(
   genre_id INT NOT NULL AUTO_INCREMENT,
   genre_label VARCHAR(50),
   PRIMARY KEY(genre_id)
);

DROP TABLE IF EXISTS zipcode;
CREATE TABLE zipcode(
   zipcode INT,
   PRIMARY KEY(zipcode)
);

DROP TABLE IF EXISTS country;
CREATE TABLE country(
   country_id INT NOT NULL AUTO_INCREMENT,
   country_name VARCHAR(255),
   PRIMARY KEY(country_id)
);

DROP TABLE IF EXISTS isbn;
CREATE TABLE isbn(
   isbn VARCHAR(14) NOT NULL,
   book_id INT NOT NULL,
   PRIMARY KEY(isbn),
   CONSTRAINT `fk_isbn_book`
    FOREIGN KEY (book_id) REFERENCES book (book_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS reading_status;
CREATE TABLE reading_status(
   reading_status_id INT NOT NULL AUTO_INCREMENT,
   reading_status_label VARCHAR(50) NOT NULL,
   PRIMARY KEY(reading_status_id)
);

DROP TABLE IF EXISTS reaction;
CREATE TABLE reaction(
   reaction_id INT NOT NULL AUTO_INCREMENT,
   reaction_label VARCHAR(50),
   PRIMARY KEY(reaction_id)
);

DROP TABLE IF EXISTS status;
CREATE TABLE status(
   status_id INT NOT NULL AUTO_INCREMENT,
   status_label VARCHAR(50),
   PRIMARY KEY(status_id)
);

DROP TABLE IF EXISTS state;
CREATE TABLE state(
   state_id INT NOT NULL AUTO_INCREMENT,
   state_label VARCHAR(50) NOT NULL,
   PRIMARY KEY(state_id)
);

DROP TABLE IF EXISTS user;
CREATE TABLE user(
   user_id INT NOT NULL AUTO_INCREMENT,
   user_pseudo VARCHAR(255) NOT NULL,
   user_email VARCHAR(255) NOT NULL,
   user_password TEXT NOT NULL,
   user_avatar VARCHAR(255),
   user_public_comments BOOLEAN NOT NULL DEFAULT TRUE,
   user_balance INT,
   user_banned DATETIME NULL DEFAULT NULL,
   user_admin BOOLEAN NOT NULL DEFAULT FALSE,
   zipcode INT NOT NULL,
   PRIMARY KEY(user_id),
   UNIQUE(user_pseudo),
   UNIQUE(user_email),
   FOREIGN KEY(zipcode) REFERENCES zipcode(zipcode)
);

DROP TABLE IF EXISTS city;
CREATE TABLE city(
   city_id INT NOT NULL AUTO_INCREMENT,
   city_name VARCHAR(255),
   country_id INT NOT NULL,
   PRIMARY KEY(city_id),
   CONSTRAINT `fk_city_country`
    FOREIGN KEY (country_id) REFERENCES country (country_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS possessed_book;
CREATE TABLE possessed_book(
   possessed_book_id INT NOT NULL AUTO_INCREMENT,
   book_id INT NOT NULL,
   state_id INT,
   reaction_id INT,
   reading_status_id INT,
   user_id INT NOT NULL,
   possessed_book_to_donate BOOLEAN DEFAULT FALSE,
   possessed_book_to_lend BOOLEAN DEFAULT FALSE,
   PRIMARY KEY(possessed_book_id),
   CONSTRAINT `fk_pbook_book`
    FOREIGN KEY (book_id) REFERENCES book (book_id)
    ON DELETE CASCADE,
   FOREIGN KEY(state_id) REFERENCES state(state_id),
   FOREIGN KEY(reaction_id) REFERENCES reaction(reaction_id),
   FOREIGN KEY(reading_status_id) REFERENCES reading_status(reading_status_id),
   CONSTRAINT `fk_pbook_user`
    FOREIGN KEY (user_id) REFERENCES user (user_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS borrowing;
CREATE TABLE borrowing(
   possessed_book_id INT,
   borrowing_id INT NOT NULL AUTO_INCREMENT,
   borrowing_start_date DATETIME NOT NULL,
   borrowing_end_date DATETIME NOT NULL,
   status_id INT NOT NULL,
   user_id INT NOT NULL,
   PRIMARY KEY(possessed_book_id),
   UNIQUE(borrowing_id),
   CONSTRAINT `fk_borrowing_possessed_book`
    FOREIGN KEY (possessed_book_id) REFERENCES possessed_book (possessed_book_id)
    ON DELETE CASCADE,
   FOREIGN KEY(status_id) REFERENCES status(status_id),
   CONSTRAINT `fk_borrowing_user`
    FOREIGN KEY (user_id) REFERENCES user (user_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS reminder;
CREATE TABLE reminder(
   reminder_id INT NOT NULL AUTO_INCREMENT,
   reminder_date DATETIME NOT NULL,
   possessed_book_id INT NOT NULL,
   PRIMARY KEY(reminder_id),
   FOREIGN KEY(possessed_book_id) REFERENCES borrowing(possessed_book_id) ON DELETE 
   CONSTRAINT `fk_reminder_possessed_book`
    FOREIGN KEY (possessed_book_id) REFERENCES possessed_book (possessed_book_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS message;
CREATE TABLE message(
   user_id INT,
   user_id_1 INT,
   message_id INT NOT NULL AUTO_INCREMENT,
   message_content TEXT NOT NULL,
   message_date DATETIME,
   PRIMARY KEY(user_id, user_id_1),
   UNIQUE(message_id),
   CONSTRAINT `fk_message_user`
    FOREIGN KEY (user_id) REFERENCES user (user_id)
    ON DELETE CASCADE,
   CONSTRAINT `fk_message_user_1`
    FOREIGN KEY (user_id_1) REFERENCES user (user_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS book_author;
CREATE TABLE book_author(
   book_id INT,
   author_id INT,
   PRIMARY KEY(book_id, author_id),
   CONSTRAINT `fk_book_author_author`
    FOREIGN KEY (author_id) REFERENCES author (author_id)
    ON DELETE CASCADE,
   CONSTRAINT `fk_book_author_book`
    FOREIGN KEY (book_id) REFERENCES book (book_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS book_genre;
CREATE TABLE book_genre(
   book_id INT,
   genre_id INT,
   PRIMARY KEY(book_id, genre_id),
   CONSTRAINT `fk_book_genre_book`
    FOREIGN KEY (book_id) REFERENCES book (book_id)
    ON DELETE CASCADE,
   CONSTRAINT `fk_book_genre_genre`
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS comment;
CREATE TABLE comment(
   book_id INT,
   user_id INT,
   comment_id INT NOT NULL AUTO_INCREMENT,
   comment_content TEXT NOT NULL,
   comment_date DATETIME NOT NULL,
   comment_suggestion BOOLEAN NOT NULL DEFAULT FALSE,
   PRIMARY KEY(book_id, user_id),
   UNIQUE(comment_id),
   CONSTRAINT `fk_comment_book`
    FOREIGN KEY (book_id) REFERENCES book (book_id)
    ON DELETE CASCADE,
   CONSTRAINT `fk_comment_user`
    FOREIGN KEY (user_id) REFERENCES user (user_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS zipcode_city;
CREATE TABLE zipcode_city(
   zipcode INT,
   city_id INT,
   PRIMARY KEY(zipcode, city_id),
   CONSTRAINT `fk_zipcode_city_zipcode`
    FOREIGN KEY (zipcode) REFERENCES zipcode (zipcode)
    ON DELETE CASCADE,
   CONSTRAINT `fk_zipcode_city_city`
    FOREIGN KEY (city_id) REFERENCES city (city_id)
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS donation;
CREATE TABLE donation(
   possessed_book_id INT,
   donation_date DATETIME,
   user_id INT NOT NULL,
   status_id INT NOT NULL,
   PRIMARY KEY(possessed_book_id),
   CONSTRAINT `fk_donation_possessed_book`
    FOREIGN KEY (possessed_book_id) REFERENCES possessed_book (possessed_book_id)
    ON DELETE CASCADE,
   CONSTRAINT `fk_donation_user`
    FOREIGN KEY (user_id) REFERENCES user (user_id)
    ON DELETE CASCADE,
   FOREIGN KEY(status_id) REFERENCES status(status_id)
);

DROP TABLE IF EXISTS api_key;
CREATE TABLE api_key(
   api_key VARCHAR(255) NOT NULL,
   PRIMARY KEY (api_key)
);
