DROP DATABASE IF EXISTS bookme_test;
CREATE DATABASE bookme_test;
USE bookme_test;

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
   message_sender INT,
   message_recipient INT,
   message_id INT NOT NULL AUTO_INCREMENT,
   message_content TEXT NOT NULL,
   message_date DATETIME DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY(message_id),
   CONSTRAINT `fk_message_sender`
    FOREIGN KEY (message_sender) REFERENCES user (user_id)
    ON DELETE CASCADE,
   CONSTRAINT `fk_message_recipient`
    FOREIGN KEY (message_recipient) REFERENCES user (user_id)
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

DROP VIEW IF EXISTS books_list;

CREATE VIEW books_list AS SELECT 
b.book_id, b.book_title, b.book_release_year, i.isbn as book_isbn
FROM book b 
LEFT JOIN isbn i ON (b.book_id = i.book_id)
LEFT JOIN author  ON (b.book_id = i.book_id);

DROP VIEW IF EXISTS possessed_books_list;

CREATE VIEW possessed_books_list AS SELECT 
pb.possessed_book_id, pb.possessed_book_to_donate, pb.possessed_book_to_lend, b.book_id as possessed_book_book, b.book_title as possessed_book_title, b.book_release_year as possessed_book_release_year, i.isbn as possessed_book_isbn, s.state_label as possessed_book_state, r.reaction_label as possessed_book_reaction, rs.reading_status_label as possessed_book_reading_status, u.user_id as possessed_book_user
FROM possessed_book pb
LEFT JOIN book b ON (pb.book_id = b.book_id)
LEFT JOIN isbn i ON (pb.book_id = i.book_id)
LEFT JOIN state s ON (pb.state_id = s.state_id)
LEFT JOIN reaction r ON (pb.reaction_id = r.reaction_id)
LEFT JOIN reading_status rs ON (pb.reading_status_id = rs.reading_status_id)
LEFT JOIN user u ON (pb.user_id = u.user_id);

INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (1, 'Rowe', 'Cortez');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (2, 'Miller', 'Callie');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (3, 'Reynolds', 'Estrella');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (4, 'Hirthe', 'Amari');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (5, 'Padberg', 'Isabella');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (6, 'Sanford', 'Cordia');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (7, 'Rippin', 'Horace');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (8, 'Balistreri', 'Cletus');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (9, 'Willms', 'Jude');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (10, 'Ebert', 'Rusty');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (11, 'Funk', 'Monroe');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (12, 'Turner', 'Molly');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (13, 'Abbott', 'Elvis');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (14, 'Renner', 'Carlos');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (15, 'Pacocha', 'Valentin');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (16, 'DuBuque', 'Ceasar');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (17, 'Cronin', 'Chase');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (18, 'Johnson', 'Cameron');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (19, 'Baumbach', 'Sonny');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (20, 'Ward', 'Eulalia');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (21, 'Hermiston', 'Fidel');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (22, 'Willms', 'Donny');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (23, 'Cassin', 'Marguerite');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (24, 'Medhurst', 'Charley');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (25, 'Dare', 'Howard');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (26, 'Powlowski', 'Gennaro');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (27, 'Sipes', 'Kamron');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (28, 'Turcotte', 'Alexandro');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (29, 'Roob', 'Rosamond');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (30, 'Berge', 'Robert');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (31, 'Smith', 'Alessandro');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (32, 'Lakin', 'Ashtyn');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (33, 'Rutherford', 'Cyril');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (34, 'Bashirian', 'Terry');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (35, 'White', 'Eriberto');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (36, 'O\'Hara', 'Junior');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (37, 'Torp', 'Terrell');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (38, 'Murazik', 'Diana');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (39, 'Bashirian', 'Esta');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (40, 'Fay', 'Glennie');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (41, 'Wilkinson', 'Ernestina');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (42, 'Hane', 'Kallie');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (43, 'Gutkowski', 'Lolita');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (44, 'Fadel', 'Nils');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (45, 'Schulist', 'Krystel');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (46, 'Kilback', 'Clyde');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (47, 'Mueller', 'Rosie');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (48, 'Fay', 'Adella');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (49, 'Raynor', 'Makenna');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (50, 'Rolfson', 'Agustin');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (51, 'Lemke', 'Easton');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (52, 'Corkery', 'Ken');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (53, 'Bode', 'Glenna');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (54, 'Goyette', 'Reba');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (55, 'Heller', 'Laverne');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (56, 'Hudson', 'Scarlett');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (57, 'Conroy', 'Ena');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (58, 'Trantow', 'Maximilian');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (59, 'Hand', 'Norma');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (60, 'Weber', 'Paige');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (61, 'Toy', 'Don');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (62, 'Graham', 'Watson');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (63, 'Collier', 'Crystal');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (64, 'Crist', 'Ulices');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (65, 'Prosacco', 'Mason');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (66, 'Swift', 'Sylvia');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (67, 'Hagenes', 'Reece');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (68, 'Wolff', 'Easton');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (69, 'Hansen', 'Ladarius');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (70, 'Lang', 'Dewayne');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (71, 'Monahan', 'Delphia');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (72, 'Medhurst', 'Vincenzo');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (73, 'Schowalter', 'Deven');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (74, 'McCullough', 'Ocie');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (75, 'Feil', 'Drew');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (76, 'Kuvalis', 'Darius');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (77, 'Jerde', 'Gerald');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (78, 'Dare', 'Art');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (79, 'Roob', 'Petra');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (80, 'Abshire', 'Rhea');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (81, 'Walsh', 'Ada');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (82, 'Blanda', 'Opal');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (83, 'Dietrich', 'Kyle');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (84, 'Zboncak', 'Raheem');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (85, 'Roberts', 'Pete');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (86, 'Powlowski', 'Keara');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (87, 'Witting', 'Camille');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (88, 'Rohan', 'Pascale');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (89, 'Keeling', 'America');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (90, 'Stroman', 'Mekhi');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (91, 'Kling', 'Imogene');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (92, 'Labadie', 'Kelli');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (93, 'Bergnaum', 'Ena');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (94, 'Donnelly', 'Kasandra');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (95, 'Leannon', 'Reginald');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (96, 'Mosciski', 'Rosina');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (97, 'Corkery', 'Irma');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (98, 'Adams', 'Makenna');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (99, 'Upton', 'Ottis');
INSERT INTO `author` (`author_id`, `author_last_name`, `author_first_name`) VALUES (100, 'Kozey', 'Agnes');

INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (1, 'Non sint ullam voluptates sed.', 1984);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (2, 'Velit incidunt voluptatibus officia illo mollitia quo.', 1992);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (3, 'Incidunt tenetur non qui omnis numquam.', 2016);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (4, 'Excepturi impedit est quibusdam nostrum voluptas.', 1988);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (5, 'Est assumenda fugiat est nesciunt eligendi repellendus.', 1972);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (6, 'Optio quos labore facilis distinctio sint maxime perferendis.', 1988);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (7, 'Voluptatum ipsum nulla dolor neque nam.', 1996);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (8, 'Necessitatibus dolorem veritatis suscipit facere molestiae cum sapiente.', 2019);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (9, 'Est eum aut quam ipsum blanditiis id.', 1988);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (10, 'Est autem qui quas autem ea.', 1993);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (11, 'Labore velit repudiandae modi placeat accusamus.', 2004);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (12, 'Voluptate perspiciatis facere assumenda earum.', 1998);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (13, 'Rem molestiae nobis suscipit numquam ut est alias.', 2005);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (14, 'Incidunt est velit error ut et.', 2012);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (15, 'Sit dolore quam eos est.', 1975);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (16, 'Unde aliquam quod sint qui porro earum.', 1986);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (17, 'Magni impedit quam nostrum atque id non.', 2000);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (18, 'Optio sint porro est.', 2018);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (19, 'Numquam est mollitia provident.', 2018);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (20, 'Officia quisquam voluptatibus fuga esse qui sint saepe.', 1994);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (21, 'Et aut aut nostrum iste amet.', 2013);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (22, 'Repudiandae voluptatum tempore nobis voluptatum consequatur harum totam.', 2018);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (23, 'Aut perferendis tempore et accusamus et aliquid ad.', 1982);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (24, 'Ut molestiae porro fuga consectetur dignissimos consequuntur ut.', 2014);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (25, 'Repellendus nesciunt at harum odit consequatur vero.', 2008);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (26, 'Cum labore id dolores.', 2017);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (27, 'Distinctio minima necessitatibus accusamus nisi nobis eum voluptatum.', 2003);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (28, 'Culpa dolore cupiditate est sapiente voluptatum vero.', 1987);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (29, 'Quo voluptas molestiae omnis itaque corrupti dolor.', 1986);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (30, 'Totam et quia consectetur suscipit temporibus reiciendis et.', 1977);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (31, 'Quibusdam rerum quod illo non corporis sit.', 1994);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (32, 'Tempora voluptatum sed reprehenderit explicabo consectetur.', 1994);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (33, 'Odit sit nam error qui ea quisquam.', 1994);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (34, 'Et esse impedit et iusto.', 2020);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (35, 'Corrupti harum minima ea rerum dolore eaque.', 1970);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (36, 'Dolore eius velit minus ullam.', 1991);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (37, 'Et dolorem quas iste a sed.', 2010);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (38, 'Mollitia facilis officiis provident.', 2004);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (39, 'Rerum rem velit facere voluptas.', 1989);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (40, 'Possimus odit dolores quidem iusto.', 1984);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (41, 'Veniam voluptas odit suscipit ea sed commodi.', 2020);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (42, 'Labore laudantium iusto aperiam.', 2004);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (43, 'Vitae dicta ut exercitationem molestiae quis odit cumque.', 1983);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (44, 'Impedit laudantium fuga quo non sed vero atque laboriosam.', 1985);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (45, 'Harum harum est quas nihil dignissimos sit.', 1993);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (46, 'A ab molestiae nisi sunt eius aspernatur.', 1974);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (47, 'Velit iste ipsum alias laborum dolorum.', 1975);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (48, 'Nostrum amet optio sit in iste sed nobis.', 1996);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (49, 'Sequi voluptate sint aut hic ut.', 1980);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (50, 'Accusamus sit qui reiciendis et voluptates qui atque.', 1996);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (51, 'Quaerat itaque in dicta ut nisi reiciendis in.', 1989);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (52, 'Eaque enim dolorum ut recusandae.', 1980);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (53, 'Et itaque velit consectetur tempore.', 2011);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (54, 'Consequuntur ipsam eligendi ipsam et eum expedita.', 2002);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (55, 'Quae facere numquam assumenda voluptate odio.', 2002);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (56, 'Nostrum aut voluptate perferendis voluptatem debitis.', 2000);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (57, 'Ut quia non facere omnis hic.', 1989);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (58, 'Eum alias dolorem ipsa fugiat eum dolor minus.', 1973);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (59, 'Laboriosam dolores alias optio expedita enim perspiciatis minus.', 1977);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (60, 'Quam et quas autem delectus quas aliquam maxime totam.', 2019);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (61, 'Explicabo accusantium et facilis reiciendis.', 1999);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (62, 'Voluptates veniam iure aut nesciunt.', 1999);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (63, 'Ullam facere eum enim ipsa nulla.', 1990);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (64, 'Sint ex voluptas omnis minima.', 1994);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (65, 'Voluptatem quia voluptas natus beatae voluptatibus laudantium.', 1992);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (66, 'Tempora omnis est consequatur porro nisi eos.', 1991);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (67, 'Provident non neque fugit laboriosam nostrum unde pariatur.', 1991);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (68, 'Eum magnam ducimus a assumenda nam.', 2020);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (69, 'Quisquam neque et tempora est possimus aut aut.', 1997);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (70, 'Ipsa ut minus eveniet aut harum.', 2014);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (71, 'Omnis ut iure ex quia ut rem dolorem.', 1979);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (72, 'Nulla deleniti quo sit culpa dolores explicabo.', 2013);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (73, 'Assumenda provident nihil aut amet pariatur culpa assumenda.', 2020);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (74, 'Est pariatur voluptates vel praesentium occaecati quia.', 2003);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (75, 'Repellendus accusamus quia minima odio optio fuga.', 2021);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (76, 'Aut dolor pariatur cupiditate.', 1977);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (77, 'Labore ut eveniet hic eum.', 1994);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (78, 'Nesciunt explicabo dolorem ea aperiam et.', 1998);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (79, 'Non eum dicta ullam eligendi.', 2010);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (80, 'Quidem reiciendis consequatur blanditiis omnis dolorem.', 2002);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (81, 'Sit voluptate doloremque fuga distinctio non provident voluptatem.', 1974);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (82, 'Voluptatum aut sunt corrupti tempora eveniet.', 2000);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (83, 'Maxime earum aliquam quo reiciendis error aut consequatur.', 1975);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (84, 'Libero aut beatae nam autem.', 1998);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (85, 'Rerum perferendis nihil iure aut est voluptatem sapiente.', 2022);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (86, 'Distinctio officiis occaecati ea maiores quos rem.', 1982);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (87, 'Ut provident commodi harum eaque omnis ipsam.', 2009);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (88, 'Aliquam illo unde et modi ducimus eum harum.', 1992);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (89, 'In dolor inventore vitae quia consequatur maxime.', 1986);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (90, 'Veniam officia consequatur magni.', 1993);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (91, 'Fugiat beatae sit delectus quis et esse quia quibusdam.', 1998);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (92, 'Saepe qui dignissimos doloremque non architecto.', 1993);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (93, 'Ex dicta quae cum porro rem ducimus.', 1974);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (94, 'Aut tenetur excepturi ut enim minima reiciendis.', 1971);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (95, 'Voluptates dolorum ex saepe laborum aliquam voluptates.', 2006);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (96, 'Rem placeat consequatur ut fugit omnis ea qui.', 2022);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (97, 'Eos qui doloribus cumque asperiores dolores omnis.', 1984);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (98, 'Ut ratione quibusdam minus et.', 1995);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (99, 'Aut voluptas a dignissimos et veniam qui.', 2010);
INSERT INTO `book` (`book_id`, `book_title`, `book_release_year`) VALUES (100, 'Non aut molestias rerum.', 1983);

INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (1, 'Langoshstad', 1);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (2, 'Bettyeberg', 2);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (3, 'Helgashire', 3);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (4, 'Jeaniebury', 4);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (5, 'Courtneyland', 5);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (6, 'O\'Konville', 6);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (7, 'New Oceaneberg', 7);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (8, 'Jabariland', 8);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (9, 'East Delmershire', 9);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (10, 'East Antwan', 10);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (11, 'South Evalyn', 11);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (12, 'Lake Henryside', 12);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (13, 'New Elmira', 13);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (14, 'Alaynahaven', 14);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (15, 'South Abigale', 15);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (16, 'Port Florida', 16);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (17, 'New Keven', 17);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (18, 'Keeblerton', 18);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (19, 'Kalimouth', 19);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (20, 'Murraymouth', 20);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (21, 'West Anjalifurt', 21);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (22, 'Nitzscheshire', 22);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (23, 'Hermannbury', 23);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (24, 'Chaimside', 24);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (25, 'West Jedediahside', 25);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (26, 'South Chesley', 26);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (27, 'Adamsmouth', 27);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (28, 'Lake Laurencefort', 28);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (29, 'West Meaganstad', 29);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (30, 'Ziemannborough', 30);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (31, 'West Sylvan', 31);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (32, 'Luettgenhaven', 32);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (33, 'Jacquelynfort', 33);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (34, 'Gustaveton', 34);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (35, 'Reyview', 35);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (36, 'Hoytchester', 36);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (37, 'New Chesleyburgh', 37);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (38, 'South Rosalyntown', 38);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (39, 'Rodgermouth', 39);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (40, 'Port Nat', 40);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (41, 'Framimouth', 41);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (42, 'Funkside', 42);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (43, 'Marquesside', 43);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (44, 'Borerfort', 44);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (45, 'West Juwanport', 45);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (46, 'Ornmouth', 46);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (47, 'Port Iciebury', 47);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (48, 'West Sarinaland', 48);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (49, 'North Rebekah', 49);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (50, 'Jacobimouth', 50);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (51, 'Port Lyla', 51);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (52, 'Olsonberg', 52);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (53, 'North Tyreekfurt', 53);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (54, 'Johnschester', 54);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (55, 'Brandoville', 55);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (56, 'New Adahmouth', 56);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (57, 'Maggiostad', 57);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (58, 'Mullerbury', 58);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (59, 'Wiegandberg', 59);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (60, 'Shanamouth', 60);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (61, 'Nellefurt', 61);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (62, 'Cronamouth', 62);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (63, 'Schneiderburgh', 63);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (64, 'Lake Thaliaville', 64);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (65, 'Kuphalside', 65);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (66, 'Kelvinville', 66);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (67, 'Dooleyville', 67);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (68, 'East Itzel', 68);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (69, 'Lake Marleneport', 69);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (70, 'Port Kraigside', 70);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (71, 'Lakinhaven', 71);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (72, 'North Ronbury', 72);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (73, 'New Elissahaven', 73);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (74, 'Schuppetown', 74);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (75, 'Wizaton', 75);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (76, 'East Hipolitomouth', 76);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (77, 'Soniafort', 77);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (78, 'Barrowsview', 78);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (79, 'East Caleb', 79);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (80, 'Schillerfurt', 80);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (81, 'Niashire', 81);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (82, 'Port Damaris', 82);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (83, 'Cruickshankchester', 83);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (84, 'Lake Terryberg', 84);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (85, 'Runolfssonmouth', 85);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (86, 'Effertzborough', 86);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (87, 'Hayesmouth', 87);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (88, 'Alexieburgh', 88);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (89, 'Ritchiefort', 89);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (90, 'Jordaneside', 90);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (91, 'Hipolitotown', 91);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (92, 'Lake Abigale', 92);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (93, 'Homenickland', 93);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (94, 'North Aniya', 94);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (95, 'Adolphusbury', 95);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (96, 'West Adellside', 96);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (97, 'Blickfort', 97);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (98, 'Mistytown', 98);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (99, 'Micaelaport', 99);
INSERT INTO `city` (`city_id`, `city_name`, `country_id`) VALUES (100, 'Port Warren', 100);

INSERT INTO `country` (`country_id`, `country_name`) VALUES (1, 'Tunisia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (2, 'Norway');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (3, 'Singapore');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (4, 'Tanzania');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (5, 'Bosnia and Herzegovina');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (6, 'Kiribati');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (7, 'Monaco');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (8, 'Albania');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (9, 'Korea');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (10, 'Micronesia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (11, 'Yemen');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (12, 'Trinidad and Tobago');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (13, 'Malaysia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (14, 'Northern Mariana Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (15, 'Vietnam');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (16, 'Puerto Rico');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (17, 'Bosnia and Herzegovina');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (18, 'Gibraltar');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (19, 'Latvia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (20, 'Argentina');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (21, 'Ethiopia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (22, 'Hungary');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (23, 'Libyan Arab Jamahiriya');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (24, 'Kyrgyz Republic');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (25, 'United Kingdom');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (26, 'Angola');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (27, 'Singapore');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (28, 'Bermuda');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (29, 'Armenia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (30, 'Denmark');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (31, 'Jamaica');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (32, 'Macedonia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (33, 'Niue');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (34, 'Nauru');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (35, 'Hungary');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (36, 'Brazil');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (37, 'Bahrain');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (38, 'Nepal');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (39, 'Malaysia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (40, 'Spain');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (41, 'Guernsey');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (42, 'Argentina');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (43, 'Egypt');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (44, 'Congo');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (45, 'Argentina');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (46, 'Kiribati');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (47, 'Bahamas');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (48, 'Georgia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (49, 'Saint Martin');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (50, 'Norway');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (51, 'Germany');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (52, 'Japan');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (53, 'Angola');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (54, 'Belgium');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (55, 'Kazakhstan');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (56, 'Tuvalu');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (57, 'Zambia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (58, 'Philippines');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (59, 'Indonesia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (60, 'Italy');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (61, 'Kiribati');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (62, 'Sierra Leone');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (63, 'Botswana');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (64, 'Northern Mariana Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (65, 'Ireland');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (66, 'Belarus');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (67, 'Uruguay');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (68, 'Mayotte');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (69, 'Cocos (Keeling) Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (70, 'Gibraltar');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (71, 'Bermuda');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (72, 'Pitcairn Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (73, 'Guinea');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (74, 'Senegal');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (75, 'Fiji');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (76, 'Timor-Leste');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (77, 'New Caledonia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (78, 'Belgium');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (79, 'Suriname');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (80, 'Italy');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (81, 'Guyana');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (82, 'Djibouti');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (83, 'Cape Verde');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (84, 'Vietnam');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (85, 'Lebanon');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (86, 'Tanzania');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (87, 'Sudan');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (88, 'Palau');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (89, 'South Africa');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (90, 'Solomon Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (91, 'American Samoa');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (92, 'Mozambique');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (93, 'Cuba');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (94, 'French Southern Territories');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (95, 'Chile');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (96, 'Falkland Islands (Malvinas)');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (97, 'Sweden');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (98, 'Libyan Arab Jamahiriya');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (99, 'Moldova');
INSERT INTO `country` (`country_id`, `country_name`) VALUES (100, 'Andorra');

INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (1, 'perspiciatis');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (2, 'modi');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (3, 'dicta');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (4, 'maiores');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (5, 'quibusdam');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (6, 'repellat');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (7, 'harum');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (8, 'qui');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (9, 'pariatur');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (10, 'maxime');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (11, 'omnis');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (12, 'est');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (13, 'fugit');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (14, 'recusandae');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (15, 'dolor');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (16, 'quae');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (17, 'eum');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (18, 'eos');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (19, 'et');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (20, 'vitae');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (21, 'iste');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (22, 'veritatis');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (23, 'aliquid');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (24, 'cupiditate');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (25, 'qui');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (26, 'eaque');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (27, 'et');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (28, 'soluta');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (29, 'omnis');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (30, 'odio');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (31, 'occaecati');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (32, 'dolorum');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (33, 'doloremque');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (34, 'amet');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (35, 'qui');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (36, 'exercitationem');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (37, 'officia');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (38, 'tempora');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (39, 'sed');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (40, 'qui');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (41, 'ut');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (42, 'occaecati');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (43, 'ab');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (44, 'consequatur');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (45, 'eius');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (46, 'suscipit');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (47, 'id');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (48, 'sint');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (49, 'aut');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (50, 'et');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (51, 'quisquam');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (52, 'eos');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (53, 'enim');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (54, 'reiciendis');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (55, 'voluptate');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (56, 'qui');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (57, 'eos');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (58, 'dolores');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (59, 'nesciunt');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (60, 'esse');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (61, 'voluptas');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (62, 'et');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (63, 'cum');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (64, 'consequatur');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (65, 'iste');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (66, 'dolor');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (67, 'optio');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (68, 'ipsum');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (69, 'omnis');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (70, 'omnis');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (71, 'ratione');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (72, 'temporibus');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (73, 'animi');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (74, 'et');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (75, 'pariatur');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (76, 'iure');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (77, 'accusantium');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (78, 'est');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (79, 'esse');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (80, 'nesciunt');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (81, 'sit');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (82, 'aliquam');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (83, 'quo');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (84, 'repellat');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (85, 'nobis');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (86, 'id');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (87, 'rerum');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (88, 'distinctio');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (89, 'doloremque');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (90, 'ex');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (91, 'repudiandae');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (92, 'qui');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (93, 'ut');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (94, 'dolorem');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (95, 'asperiores');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (96, 'doloribus');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (97, 'quas');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (98, 'quia');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (99, 'et');
INSERT INTO `genre` (`genre_id`, `genre_label`) VALUES (100, 'perspiciatis');

INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6961560330430', 1);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6477547115384', 2);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3389494489599', 3);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8336999427590', 4);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('4605838062839', 5);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3170664061673', 6);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1517941282680', 7);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9848648675133', 8);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('0697739201930', 9);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('7105757943389', 10);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('2371860632631', 11);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8856441701028', 12);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6700533114659', 13);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3623675583509', 14);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5442158470406', 15);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1646784704650', 16);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8187820565178', 17);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1958864546884', 18);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('0648350279303', 19);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9447148944864', 20);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('4753593744917', 21);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('2492566301949', 22);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9911179656015', 23);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1288654328001', 24);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('2198101186766', 25);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8249238085102', 26);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3769457654958', 27);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1937224130482', 28);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('7039427256182', 29);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3301506356613', 30);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5543819066300', 31);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9286733286886', 32);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8632086854820', 33);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1584902295485', 34);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5706624693103', 35);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9632224822109', 36);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8085683359692', 37);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8935367474480', 38);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6372659255143', 39);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3802815463509', 40);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('2084290796032', 41);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1056941416768', 42);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5579606085049', 43);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3441368165159', 44);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9648500844956', 45);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5886634189473', 46);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('7295903336537', 47);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3228450523338', 48);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5169775936626', 49);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8887772719420', 50);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5355261666966', 51);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('7868787805125', 52);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5686987655539', 53);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3122216537402', 54);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('4425682744794', 55);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('4086961500656', 56);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('7503694237781', 57);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6006142242067', 58);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3210881608159', 59);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8074147225789', 60);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('4925058233735', 61);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('2112417327354', 62);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1800251770948', 63);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9188418604063', 64);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1358353042543', 65);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('2156307123268', 66);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('0011022675107', 67);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('2296331477606', 68);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3452040422705', 69);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3616046202758', 70);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8259671856207', 71);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9374660952308', 72);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('4426397341834', 73);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8371999317649', 74);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5972767903977', 75);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6991092465829', 76);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6737676379966', 77);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('7423102070369', 78);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8362150431175', 79);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('3896193391301', 80);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('0803925266199', 81);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1738359992378', 82);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8972160969225', 83);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6113548142737', 84);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('2069662693850', 85);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('2016856153966', 86);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('0894861047775', 87);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6886332192675', 88);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6132437767226', 89);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6326898434456', 90);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('5567172515275', 91);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('6992584232622', 92);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9133470244641', 93);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('7395620900636', 94);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8193893201509', 95);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('8539476483212', 96);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('9142519062696', 97);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('0663551102823', 98);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('1079769317444', 99);
INSERT INTO `isbn` (`isbn`, `book_id`) VALUES ('0969669677339', 100);

INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (1, 1, 1, 1, 1, 1, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (2, 2, 2, 2, 2, 2, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (3, 3, 3, 3, 3, 3, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (4, 4, 4, 4, 4, 4, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (5, 5, 5, 5, 5, 5, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (6, 6, 6, 6, 6, 6, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (7, 7, 7, 7, 7, 7, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (8, 8, 8, 8, 8, 8, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (9, 9, 9, 9, 9, 9, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (10, 10, 10, 10, 10, 10, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (11, 11, 11, 11, 11, 11, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (12, 12, 12, 12, 12, 12, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (13, 13, 13, 13, 13, 13, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (14, 14, 14, 14, 14, 14, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (15, 15, 15, 15, 15, 15, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (16, 16, 16, 16, 16, 16, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (17, 17, 17, 17, 17, 17, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (18, 18, 18, 18, 18, 18, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (19, 19, 19, 19, 19, 19, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (20, 20, 20, 20, 20, 20, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (21, 21, 21, 21, 21, 21, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (22, 22, 22, 22, 22, 22, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (23, 23, 23, 23, 23, 23, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (24, 24, 24, 24, 24, 24, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (25, 25, 25, 25, 25, 25, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (26, 26, 26, 26, 26, 26, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (27, 27, 27, 27, 27, 27, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (28, 28, 28, 28, 28, 28, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (29, 29, 29, 29, 29, 29, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (30, 30, 30, 30, 30, 30, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (31, 31, 31, 31, 31, 31, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (32, 32, 32, 32, 32, 32, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (33, 33, 33, 33, 33, 33, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (34, 34, 34, 34, 34, 34, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (35, 35, 35, 35, 35, 35, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (36, 36, 36, 36, 36, 36, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (37, 37, 37, 37, 37, 37, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (38, 38, 38, 38, 38, 38, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (39, 39, 39, 39, 39, 39, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (40, 40, 40, 40, 40, 40, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (41, 41, 41, 41, 41, 41, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (42, 42, 42, 42, 42, 42, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (43, 43, 43, 43, 43, 43, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (44, 44, 44, 44, 44, 44, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (45, 45, 45, 45, 45, 45, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (46, 46, 46, 46, 46, 46, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (47, 47, 47, 47, 47, 47, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (48, 48, 48, 48, 48, 48, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (49, 49, 49, 49, 49, 49, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (50, 50, 50, 50, 50, 50, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (51, 51, 51, 51, 51, 1, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (52, 52, 52, 52, 52, 2, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (53, 53, 53, 53, 53, 3, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (54, 54, 54, 54, 54, 4, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (55, 55, 55, 55, 55, 5, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (56, 56, 56, 56, 56, 6, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (57, 57, 57, 57, 57, 7, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (58, 58, 58, 58, 58, 8, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (59, 59, 59, 59, 59, 9, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (60, 60, 60, 60, 60, 10, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (61, 61, 61, 61, 61, 11, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (62, 62, 62, 62, 62, 12, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (63, 63, 63, 63, 63, 13, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (64, 64, 64, 64, 64, 14, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (65, 65, 65, 65, 65, 15, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (66, 66, 66, 66, 66, 16, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (67, 67, 67, 67, 67, 17, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (68, 68, 68, 68, 68, 18, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (69, 69, 69, 69, 69, 19, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (70, 70, 70, 70, 70, 20, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (71, 71, 71, 71, 71, 21, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (72, 72, 72, 72, 72, 22, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (73, 73, 73, 73, 73, 23, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (74, 74, 74, 74, 74, 24, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (75, 75, 75, 75, 75, 25, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (76, 76, 76, 76, 76, 26, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (77, 77, 77, 77, 77, 27, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (78, 78, 78, 78, 78, 28, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (79, 79, 79, 79, 79, 29, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (80, 80, 80, 80, 80, 30, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (81, 81, 81, 81, 81, 31, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (82, 82, 82, 82, 82, 32, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (83, 83, 83, 83, 83, 33, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (84, 84, 84, 84, 84, 34, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (85, 85, 85, 85, 85, 35, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (86, 86, 86, 86, 86, 36, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (87, 87, 87, 87, 87, 37, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (88, 88, 88, 88, 88, 38, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (89, 89, 89, 89, 89, 39, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (90, 90, 90, 90, 90, 40, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (91, 91, 91, 91, 91, 41, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (92, 92, 92, 92, 92, 42, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (93, 93, 93, 93, 93, 43, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (94, 94, 94, 94, 94, 44, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (95, 95, 95, 95, 95, 45, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (96, 96, 96, 96, 96, 46, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (97, 97, 97, 97, 97, 47, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (98, 98, 98, 98, 98, 48, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (99, 99, 99, 99, 99, 49, 0, 0);
INSERT INTO `possessed_book` (`possessed_book_id`, `book_id`, `state_id`, `reaction_id`, `reading_status_id`, `user_id`, `possessed_book_to_donate`, `possessed_book_to_lend`) VALUES (100, 100, 100, 100, 100, 50, 0, 0);

INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (1, 'porro');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (2, 'tempora');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (3, 'ullam');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (4, 'saepe');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (5, 'accusamus');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (6, 'quasi');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (7, 'dolor');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (8, 'officia');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (9, 'accusamus');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (10, 'doloremque');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (11, 'sed');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (12, 'ipsam');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (13, 'pariatur');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (14, 'blanditiis');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (15, 'ducimus');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (16, 'aut');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (17, 'molestias');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (18, 'sed');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (19, 'distinctio');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (20, 'nihil');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (21, 'eaque');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (22, 'amet');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (23, 'occaecati');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (24, 'omnis');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (25, 'quibusdam');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (26, 'adipisci');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (27, 'vitae');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (28, 'hic');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (29, 'cum');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (30, 'nam');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (31, 'enim');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (32, 'non');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (33, 'saepe');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (34, 'et');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (35, 'consectetur');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (36, 'aut');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (37, 'qui');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (38, 'praesentium');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (39, 'nihil');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (40, 'soluta');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (41, 'dolore');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (42, 'ullam');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (43, 'praesentium');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (44, 'earum');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (45, 'rerum');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (46, 'inventore');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (47, 'quis');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (48, 'neque');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (49, 'fugiat');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (50, 'consequuntur');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (51, 'ex');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (52, 'incidunt');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (53, 'aut');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (54, 'nobis');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (55, 'rem');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (56, 'ab');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (57, 'ratione');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (58, 'voluptas');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (59, 'fugit');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (60, 'laborum');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (61, 'eum');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (62, 'nesciunt');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (63, 'ut');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (64, 'inventore');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (65, 'sit');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (66, 'consequatur');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (67, 'vel');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (68, 'ut');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (69, 'sunt');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (70, 'tempore');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (71, 'incidunt');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (72, 'quam');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (73, 'quos');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (74, 'cupiditate');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (75, 'nisi');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (76, 'illum');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (77, 'ut');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (78, 'expedita');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (79, 'molestiae');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (80, 'eligendi');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (81, 'iste');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (82, 'voluptas');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (83, 'temporibus');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (84, 'quis');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (85, 'eum');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (86, 'iure');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (87, 'asperiores');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (88, 'fugiat');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (89, 'velit');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (90, 'iusto');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (91, 'ducimus');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (92, 'blanditiis');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (93, 'hic');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (94, 'rem');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (95, 'nulla');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (96, 'numquam');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (97, 'ullam');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (98, 'temporibus');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (99, 'reiciendis');
INSERT INTO `reaction` (`reaction_id`, `reaction_label`) VALUES (100, 'tempora');

INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (1, 'qui');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (2, 'saepe');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (3, 'ut');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (4, 'aut');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (5, 'vero');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (6, 'sapiente');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (7, 'ipsa');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (8, 'fugit');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (9, 'impedit');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (10, 'eligendi');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (11, 'quibusdam');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (12, 'quibusdam');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (13, 'molestias');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (14, 'quis');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (15, 'accusamus');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (16, 'voluptas');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (17, 'ipsa');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (18, 'soluta');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (19, 'ut');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (20, 'qui');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (21, 'et');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (22, 'ut');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (23, 'id');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (24, 'iste');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (25, 'asperiores');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (26, 'alias');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (27, 'non');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (28, 'rerum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (29, 'quam');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (30, 'consectetur');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (31, 'qui');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (32, 'nobis');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (33, 'sit');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (34, 'ut');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (35, 'esse');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (36, 'quia');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (37, 'eum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (38, 'excepturi');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (39, 'in');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (40, 'qui');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (41, 'dolorum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (42, 'unde');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (43, 'quod');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (44, 'molestiae');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (45, 'iure');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (46, 'expedita');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (47, 'alias');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (48, 'et');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (49, 'perferendis');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (50, 'omnis');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (51, 'aspernatur');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (52, 'tempore');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (53, 'error');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (54, 'doloribus');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (55, 'quam');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (56, 'eum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (57, 'explicabo');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (58, 'cum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (59, 'dicta');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (60, 'autem');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (61, 'tempore');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (62, 'ut');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (63, 'aperiam');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (64, 'officia');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (65, 'dolorum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (66, 'id');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (67, 'quis');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (68, 'consequatur');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (69, 'quos');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (70, 'totam');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (71, 'consequatur');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (72, 'aut');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (73, 'beatae');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (74, 'ad');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (75, 'quia');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (76, 'quos');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (77, 'enim');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (78, 'nihil');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (79, 'earum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (80, 'dolorum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (81, 'eveniet');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (82, 'ut');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (83, 'dolorem');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (84, 'similique');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (85, 'asperiores');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (86, 'autem');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (87, 'doloremque');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (88, 'maiores');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (89, 'minus');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (90, 'rem');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (91, 'rerum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (92, 'veritatis');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (93, 'id');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (94, 'fugiat');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (95, 'ullam');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (96, 'doloribus');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (97, 'qui');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (98, 'pariatur');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (99, 'earum');
INSERT INTO `reading_status` (`reading_status_id`, `reading_status_label`) VALUES (100, 'aliquid');

INSERT INTO `state` (`state_id`, `state_label`) VALUES (1, 'non');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (2, 'sed');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (3, 'sit');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (4, 'et');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (5, 'impedit');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (6, 'eos');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (7, 'et');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (8, 'reiciendis');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (9, 'possimus');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (10, 'sed');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (11, 'dolor');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (12, 'quo');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (13, 'facere');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (14, 'a');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (15, 'blanditiis');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (16, 'nemo');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (17, 'quos');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (18, 'nobis');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (19, 'ad');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (20, 'dolor');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (21, 'nisi');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (22, 'maxime');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (23, 'placeat');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (24, 'sit');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (25, 'incidunt');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (26, 'ab');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (27, 'itaque');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (28, 'sit');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (29, 'ipsa');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (30, 'qui');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (31, 'quam');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (32, 'excepturi');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (33, 'voluptatem');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (34, 'autem');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (35, 'voluptates');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (36, 'autem');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (37, 'quaerat');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (38, 'praesentium');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (39, 'repudiandae');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (40, 'est');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (41, 'beatae');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (42, 'aliquid');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (43, 'omnis');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (44, 'numquam');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (45, 'quas');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (46, 'non');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (47, 'sequi');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (48, 'est');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (49, 'repellat');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (50, 'aut');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (51, 'omnis');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (52, 'non');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (53, 'molestiae');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (54, 'sint');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (55, 'est');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (56, 'aut');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (57, 'quia');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (58, 'voluptatem');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (59, 'maxime');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (60, 'explicabo');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (61, 'dolorem');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (62, 'fugit');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (63, 'nam');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (64, 'tenetur');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (65, 'quo');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (66, 'esse');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (67, 'quisquam');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (68, 'atque');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (69, 'saepe');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (70, 'qui');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (71, 'laboriosam');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (72, 'soluta');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (73, 'quam');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (74, 'qui');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (75, 'accusamus');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (76, 'et');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (77, 'odio');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (78, 'aliquam');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (79, 'voluptas');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (80, 'excepturi');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (81, 'quaerat');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (82, 'eveniet');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (83, 'aspernatur');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (84, 'deserunt');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (85, 'et');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (86, 'tempora');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (87, 'vel');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (88, 'atque');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (89, 'facere');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (90, 'maxime');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (91, 'itaque');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (92, 'odio');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (93, 'occaecati');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (94, 'eligendi');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (95, 'maiores');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (96, 'ea');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (97, 'libero');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (98, 'aut');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (99, 'minima');
INSERT INTO `state` (`state_id`, `state_label`) VALUES (100, 'id');

INSERT INTO `status` (`status_id`, `status_label`) VALUES (1, 'debitis');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (2, 'laudantium');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (3, 'possimus');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (4, 'ab');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (5, 'doloribus');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (6, 'et');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (7, 'vel');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (8, 'ut');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (9, 'fugiat');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (10, 'deserunt');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (11, 'culpa');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (12, 'harum');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (13, 'numquam');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (14, 'beatae');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (15, 'corrupti');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (16, 'laudantium');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (17, 'incidunt');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (18, 'culpa');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (19, 'sapiente');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (20, 'vel');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (21, 'est');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (22, 'enim');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (23, 'ducimus');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (24, 'placeat');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (25, 'numquam');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (26, 'id');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (27, 'tenetur');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (28, 'laudantium');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (29, 'sit');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (30, 'eius');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (31, 'velit');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (32, 'sed');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (33, 'ducimus');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (34, 'id');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (35, 'at');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (36, 'deleniti');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (37, 'dolore');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (38, 'cumque');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (39, 'voluptas');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (40, 'in');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (41, 'amet');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (42, 'quod');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (43, 'totam');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (44, 'autem');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (45, 'et');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (46, 'reprehenderit');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (47, 'corrupti');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (48, 'quia');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (49, 'eaque');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (50, 'doloribus');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (51, 'consequatur');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (52, 'explicabo');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (53, 'atque');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (54, 'quidem');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (55, 'autem');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (56, 'quis');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (57, 'similique');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (58, 'dignissimos');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (59, 'quisquam');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (60, 'labore');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (61, 'quibusdam');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (62, 'placeat');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (63, 'velit');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (64, 'eum');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (65, 'aliquid');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (66, 'voluptate');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (67, 'ut');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (68, 'magni');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (69, 'fugiat');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (70, 'recusandae');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (71, 'ab');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (72, 'non');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (73, 'est');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (74, 'quo');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (75, 'soluta');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (76, 'saepe');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (77, 'necessitatibus');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (78, 'quaerat');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (79, 'esse');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (80, 'quo');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (81, 'corporis');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (82, 'quis');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (83, 'est');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (84, 'asperiores');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (85, 'perspiciatis');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (86, 'accusantium');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (87, 'delectus');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (88, 'nesciunt');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (89, 'impedit');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (90, 'rerum');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (91, 'officia');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (92, 'in');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (93, 'aut');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (94, 'qui');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (95, 'ut');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (96, 'quaerat');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (97, 'quasi');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (98, 'sunt');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (99, 'ut');
INSERT INTO `status` (`status_id`, `status_label`) VALUES (100, 'quia');

INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (1, 'quia', 'cormier.della@example.com', 'b29655ba8fc2c8d2aa1d016d7e87a4e0c25b5290', '/a1afa0a0e561b6ca31709334f3ddece1.jpg', 1, 3, '1972-09-05 02:11:18', 0, 35);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (2, 'qui', 'xweimann@example.com', '06869a3bd472166e62391a3047a05d6b9399fed2', '/eaefa18677dcec938932441676497896.jpg', 0, 6, '1975-05-12 16:07:40', 0, 72);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (3, 'est', 'jakob13@example.com', '2452837ee3ffe416c8c4c68cb8202a17517ff274', '/e52226a52f7a72cf688cc64d186420f6.jpg', 0, 5, '1989-10-12 04:40:51', 0, 141);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (4, 'sunt', 'hermina.koss@example.com', '1c2bd9557875050c36c3b823cc005bbf9d3886c2', '/3672f096e969ca07d6693edc49534d24.jpg', 1, 9, '2013-06-07 20:50:49', 0, 1709);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (5, 'nisi', 'sbednar@example.com', 'cf56440b3015d4f589f4ee1a8f61ee47076e9867', '/b971e7e553b6420c3c9a34683e907558.jpg', 1, 3, '1989-11-24 10:15:57', 0, 2288);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (6, 'rerum', 'daisha.eichmann@example.org', '0f7cb6a694ae8dced552c41669478f50da425659', '/51bcb7abad23c19069e130d0ddccd4a6.jpg', 1, 2, '2007-12-10 17:33:19', 0, 4973);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (7, 'itaque', 'willms.citlalli@example.net', '65a0230ed0ad57f35602552ccf5e11cbb5b6f01c', '/002b36e57adc29bf7d856759f457f219.jpg', 1, 5, '2002-10-29 02:13:55', 0, 6383);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (8, 'quas', 'kendra78@example.org', 'd9bef49b21816a7f43144de86b5b8944f3e04581', '/7fdb3275fbfcaa58d08ba25fd5acea5c.jpg', 1, 6, '1970-07-28 14:04:47', 0, 6733);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (9, 'ea', 'etromp@example.net', '37dc5bdbb76b7bab601335efefa921a68eb7d617', '/a01a1e6a996df3c072f6f120c569c2bc.jpg', 0, 0, '2014-02-18 01:54:34', 0, 8087);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (10, 'aut', 'efren10@example.net', 'a51837cadc281652067cadcfdc521d0cbad4be00', '/e2fc39e7cee2f078b1452fb24fc1678d.jpg', 1, 7, '1997-05-15 00:01:26', 0, 8290);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (11, 'quidem', 'norberto.roberts@example.net', '89c1ab38d3d0ba6e735c80b23d77738df1c19aea', '/ca660f87310bfb25360f68e492d2350f.jpg', 0, 8, '1993-08-14 05:06:59', 0, 8501);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (12, 'et', 'lgibson@example.com', 'f7ea19b97789b1f7eff874876d1e27703f4b9e67', '/5adb1cd163750ae8e8f62d6184fe9c3f.jpg', 0, 2, '2011-09-03 17:06:33', 0, 8933);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (13, 'aliquam', 'schuppe.emmanuelle@example.net', '34e83a238425cee71bb32725c895379bf698462b', '/f8b6f4212b27aadf8dc96aa84bd1fa39.jpg', 1, 0, '2018-05-01 23:19:45', 0, 10423);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (14, 'delectus', 'kaci45@example.com', '895ee67042b048ae6175d1f71899a837b8ce1ef4', '/efdb0ec87146d373abd3a2ba7ebf1f7a.jpg', 0, 6, '2018-01-07 10:21:45', 0, 11055);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (15, 'consectetur', 'johan12@example.net', '2e435b4fa1b6d9bc51796e21c224601902d249df', '/f0ed77acfd3160d444108977e1abe3eb.jpg', 1, 1, '1973-01-23 19:21:32', 0, 11099);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (16, 'omnis', 'pjohnston@example.net', '200f4d979919ee269f3ffcbc5c0b3722bba4821c', '/f7a64c2d1b4bea7b18f39a53eb7cbcb3.jpg', 0, 6, '2014-05-08 02:38:16', 0, 11226);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (17, 'magni', 'geovanni.miller@example.org', '48cced4f800e32398e9bac70398b51a340ac5155', '/84a7843bbc6b31e0361367601562334c.jpg', 1, 9, '1987-06-25 13:04:50', 0, 11291);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (18, 'enim', 'collins.abe@example.org', '7630ccd986998086c398caf2de09b5a0d89db23a', '/bfb6b2c9b0ef6bbac824612455a5bfdc.jpg', 0, 6, '1983-02-03 14:11:03', 0, 11584);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (19, 'sed', 'lucy.schuppe@example.com', '04e79ac97ea5d90d5437d31b2f5a42d26ba2dae0', '/8b78533f8ada0fefbc070203c1348bb8.jpg', 0, 5, '1971-07-25 09:29:24', 0, 11657);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (20, 'nostrum', 'ffeeney@example.org', 'ddd7c962b3eb6fc8273630ec0f6bc4dcb2f5f7e7', '/ddaf23afc401be38ebab99890c64d3a3.jpg', 1, 7, '1992-06-18 19:32:01', 0, 13991);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (21, 'perferendis', 'harmon14@example.com', '7e811dc8a724769e4c8727203158b9d67d2eb10a', '/c65ee9dc60d95704c3330727ec186ea1.jpg', 0, 2, '1997-10-27 20:31:29', 0, 14525);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (22, 'illo', 'tconsidine@example.net', 'a4aa3f79e9106a39d50134639d50de51326c11e3', '/4cc41e8e051465c9d384593f623bed92.jpg', 1, 6, '2002-01-01 00:50:48', 0, 14978);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (23, 'vero', 'kathlyn.hauck@example.com', '87f088cae885089640fb40977284c5f8bbccc6d1', '/184384ae5020f3c6eaae5303cf5bbc3c.jpg', 1, 9, '1993-10-15 19:08:47', 0, 15613);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (24, 'voluptatum', 'ewehner@example.com', '8bf8d40b84e391020a5a96ce4050a4f007df65d7', '/3281cb62028b76d922fec48818d2ea35.jpg', 0, 7, '1975-11-02 11:52:57', 0, 16005);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (25, 'officiis', 'vonrueden.creola@example.com', 'c89612512596614b7db1c5bbc8b835cee5a428ed', '/1f7220acff11dbaf325e3d0085ba8f4a.jpg', 0, 7, '2012-02-29 03:20:06', 0, 18230);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (26, 'animi', 'rosalee.kassulke@example.com', 'f7a1d510687517f8d1ea15811dd218b1d5dd5b82', '/db7941c4a6da43b18e29d0796ca5f172.jpg', 0, 5, '2019-10-24 19:16:08', 0, 18441);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (27, 'dolore', 'jacky.boyle@example.com', '7614cc573ee013d97a7d52742c5f9c9d5dd1da3e', '/4d3dc81cf14553c432a4ff4403eb0fd5.jpg', 0, 9, '2014-08-07 13:46:53', 0, 19621);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (28, 'non', 'reichert.hester@example.com', '23f5d90c0f946628f5abd57a4533af07ddb477b6', '/6dfc25aabc9f565c8d368b8a7e5862d2.jpg', 0, 8, '1970-10-14 03:38:03', 0, 19693);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (29, 'quod', 'hboyer@example.net', 'ca1c7fb9457b538868ca0d989e82156fba231b75', '/1071f8cd34718498f0331a9118de942d.jpg', 0, 8, '2018-06-09 03:02:52', 0, 20073);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (30, 'maiores', 'alexane.vandervort@example.net', '909e6b22cfce5b24ae75aead18f55e9c61c1a115', '/5284d45e61f6c696e8642fcdc00c4c64.jpg', 1, 6, '2003-08-05 03:30:48', 0, 21732);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (31, 'repellendus', 'hortense18@example.net', '143f0969fa8f95f5d548fc102855bc8dbacbac18', '/ea8c0a2904f5e8fa579c8f69cbc5784c.jpg', 1, 7, '1997-03-27 18:31:05', 0, 22579);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (32, 'minima', 'mraz.jesus@example.org', '8e4529edb5253beda9df91a3eda5c48469285586', '/37691c527c95202d957770b580653825.jpg', 0, 1, '1993-08-05 23:27:39', 0, 22610);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (33, 'alias', 'sheridan.kirlin@example.com', '6f1b2edf1f891d025e2e3387db872c3032ecaffe', '/c970edccc4bc13687aa4698e7082eb7a.jpg', 1, 5, '1996-03-16 01:22:07', 0, 22971);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (34, 'inventore', 'metz.kelvin@example.com', '21a2ed1ee4ccbb46a46e2f2abd13207ddd6d2907', '/c9ff0dc58f73df2d3821442f68c8c2b1.jpg', 1, 1, '2009-01-25 16:48:43', 0, 24353);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (35, 'ex', 'khintz@example.net', 'b7628af6bae9e65db4c989f6df257569901d568e', '/11241cd3244d6eff801cbf6c3120c998.jpg', 0, 0, '1988-12-19 14:13:46', 0, 24733);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (36, 'porro', 'ylarson@example.net', '55a8d156e6a7b88a3f21a84522feb682c4434062', '/eb44a82d4367521f3046728bcf664762.jpg', 1, 0, '2013-01-26 19:57:29', 0, 24761);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (37, 'sint', 'kdooley@example.net', 'b8252c8ede75e03d082d76441da5844ff6165e5b', '/f0afadecac70732ef93bf73929105827.jpg', 0, 0, '2015-08-05 07:16:31', 0, 25461);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (38, 'eum', 'brenna.larson@example.org', '7e0fe57d2636360f2396860cb0a01116fe597820', '/8d42102f7f31e4eb32274a5a1533f7f2.jpg', 1, 5, '1990-06-27 04:16:45', 0, 25612);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (39, 'aliquid', 'dudley.pacocha@example.org', '78a7083afc7af6b40c4f26997ff3838f72190cc2', '/80469e0049b69d87c279e7f63a6d3268.jpg', 1, 8, '1997-09-15 07:27:10', 0, 27435);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (40, 'incidunt', 'dax83@example.net', 'bb4ad8765b25a6593ff674da22d537d5f84d149e', '/95a750e45929289cc62bf44aab033f39.jpg', 0, 5, '1972-04-28 23:55:37', 0, 27685);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (41, 'reiciendis', 'cartwright.julien@example.net', '439d5c5333bc40a9c98128947ddbabf993f52de2', '/de7c4c1ae58740cd801826bd004cbe68.jpg', 0, 2, '1976-03-13 19:24:32', 0, 28311);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (42, 'eos', 'alessia.schmitt@example.org', 'b6b18998da1c3b11e2757b2ac3aca53bfd0917be', '/b1a11b947f0326fc039e1bdc98f032d3.jpg', 0, 6, '2010-07-04 12:43:57', 0, 29800);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (43, 'cum', 'graham49@example.org', 'd1462ef9f4661b98fe13942d02021de5ed1e61f5', '/b2061657c5bb26dd073d50688f0382a4.jpg', 0, 9, '1973-11-09 08:47:50', 0, 29862);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (44, 'rem', 'marco.hammes@example.net', 'a3102030e1d3c6394b6963d797a162eb5516d2d1', '/e18467ac8095691937df42204d28e2aa.jpg', 0, 8, '2001-12-03 20:00:57', 0, 31375);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (45, 'numquam', 'ivon@example.com', '5c5734413faa53c0cd0ad0549ce4a7a88f4a5552', '/7032d7a887ef10938f31d25a44508919.jpg', 0, 4, '2011-12-15 15:20:49', 0, 32355);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (46, 'quibusdam', 'sjohns@example.org', 'c5d776fd6f80f4629842731be29cc065920f95ee', '/b915062f1d9314be70e78a5e888a584b.jpg', 1, 2, '1973-05-04 16:08:42', 0, 34183);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (47, 'sit', 'dawson62@example.org', '29f4399dc3a5ec0a67a8c587d4d78884160e041f', '/81c4e0dfddd9d5c83fd448fa573267ed.jpg', 1, 6, '2001-06-09 10:53:16', 0, 34329);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (48, 'mollitia', 'darrel90@example.net', 'bd665bfece625fec63e37dd7f94059c707d7efa8', '/75e427e54d7301a0fd6485b3561edd1c.jpg', 1, 2, '2017-05-16 09:56:48', 0, 34468);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (49, 'repudiandae', 'gorczany.prudence@example.com', '81194e4485c84650900ab550e949612669e44875', '/21d1f22511195e590d842a7017ba4e14.jpg', 0, 2, '1998-08-19 05:12:19', 0, 35378);
INSERT INTO `user` (`user_id`, `user_pseudo`, `user_email`, `user_password`, `user_avatar`, `user_public_comments`, `user_balance`, `user_banned`, `user_admin`, `zipcode`) VALUES (50, 'veritatis', 'parker.domenick@example.org', '9efff2d2a92d9b95a2a43f011c839a1405029411', '/78547796155988683f9ca78519c1eda5.jpg', 0, 5, '1994-06-13 00:28:33', 0, 37162);

INSERT INTO `zipcode` (`zipcode`) VALUES (35);
INSERT INTO `zipcode` (`zipcode`) VALUES (72);
INSERT INTO `zipcode` (`zipcode`) VALUES (141);
INSERT INTO `zipcode` (`zipcode`) VALUES (1709);
INSERT INTO `zipcode` (`zipcode`) VALUES (2288);
INSERT INTO `zipcode` (`zipcode`) VALUES (4973);
INSERT INTO `zipcode` (`zipcode`) VALUES (6383);
INSERT INTO `zipcode` (`zipcode`) VALUES (6733);
INSERT INTO `zipcode` (`zipcode`) VALUES (8087);
INSERT INTO `zipcode` (`zipcode`) VALUES (8290);
INSERT INTO `zipcode` (`zipcode`) VALUES (8501);
INSERT INTO `zipcode` (`zipcode`) VALUES (8933);
INSERT INTO `zipcode` (`zipcode`) VALUES (10423);
INSERT INTO `zipcode` (`zipcode`) VALUES (11055);
INSERT INTO `zipcode` (`zipcode`) VALUES (11099);
INSERT INTO `zipcode` (`zipcode`) VALUES (11226);
INSERT INTO `zipcode` (`zipcode`) VALUES (11291);
INSERT INTO `zipcode` (`zipcode`) VALUES (11584);
INSERT INTO `zipcode` (`zipcode`) VALUES (11657);
INSERT INTO `zipcode` (`zipcode`) VALUES (13991);
INSERT INTO `zipcode` (`zipcode`) VALUES (14525);
INSERT INTO `zipcode` (`zipcode`) VALUES (14978);
INSERT INTO `zipcode` (`zipcode`) VALUES (15613);
INSERT INTO `zipcode` (`zipcode`) VALUES (16005);
INSERT INTO `zipcode` (`zipcode`) VALUES (18230);
INSERT INTO `zipcode` (`zipcode`) VALUES (18441);
INSERT INTO `zipcode` (`zipcode`) VALUES (19621);
INSERT INTO `zipcode` (`zipcode`) VALUES (19693);
INSERT INTO `zipcode` (`zipcode`) VALUES (20073);
INSERT INTO `zipcode` (`zipcode`) VALUES (21732);
INSERT INTO `zipcode` (`zipcode`) VALUES (22579);
INSERT INTO `zipcode` (`zipcode`) VALUES (22610);
INSERT INTO `zipcode` (`zipcode`) VALUES (22971);
INSERT INTO `zipcode` (`zipcode`) VALUES (24353);
INSERT INTO `zipcode` (`zipcode`) VALUES (24733);
INSERT INTO `zipcode` (`zipcode`) VALUES (24761);
INSERT INTO `zipcode` (`zipcode`) VALUES (25461);
INSERT INTO `zipcode` (`zipcode`) VALUES (25612);
INSERT INTO `zipcode` (`zipcode`) VALUES (27435);
INSERT INTO `zipcode` (`zipcode`) VALUES (27685);
INSERT INTO `zipcode` (`zipcode`) VALUES (28311);
INSERT INTO `zipcode` (`zipcode`) VALUES (29800);
INSERT INTO `zipcode` (`zipcode`) VALUES (29862);
INSERT INTO `zipcode` (`zipcode`) VALUES (31375);
INSERT INTO `zipcode` (`zipcode`) VALUES (32355);
INSERT INTO `zipcode` (`zipcode`) VALUES (34183);
INSERT INTO `zipcode` (`zipcode`) VALUES (34329);
INSERT INTO `zipcode` (`zipcode`) VALUES (34468);
INSERT INTO `zipcode` (`zipcode`) VALUES (35378);
INSERT INTO `zipcode` (`zipcode`) VALUES (37162);
INSERT INTO `zipcode` (`zipcode`) VALUES (38780);
INSERT INTO `zipcode` (`zipcode`) VALUES (39125);
INSERT INTO `zipcode` (`zipcode`) VALUES (39167);
INSERT INTO `zipcode` (`zipcode`) VALUES (39655);
INSERT INTO `zipcode` (`zipcode`) VALUES (41511);
INSERT INTO `zipcode` (`zipcode`) VALUES (42041);
INSERT INTO `zipcode` (`zipcode`) VALUES (42645);
INSERT INTO `zipcode` (`zipcode`) VALUES (42729);
INSERT INTO `zipcode` (`zipcode`) VALUES (43124);
INSERT INTO `zipcode` (`zipcode`) VALUES (46475);
INSERT INTO `zipcode` (`zipcode`) VALUES (46692);
INSERT INTO `zipcode` (`zipcode`) VALUES (46761);
INSERT INTO `zipcode` (`zipcode`) VALUES (48147);
INSERT INTO `zipcode` (`zipcode`) VALUES (48790);
INSERT INTO `zipcode` (`zipcode`) VALUES (49462);
INSERT INTO `zipcode` (`zipcode`) VALUES (50428);
INSERT INTO `zipcode` (`zipcode`) VALUES (50878);
INSERT INTO `zipcode` (`zipcode`) VALUES (51419);
INSERT INTO `zipcode` (`zipcode`) VALUES (55386);
INSERT INTO `zipcode` (`zipcode`) VALUES (55593);
INSERT INTO `zipcode` (`zipcode`) VALUES (58217);
INSERT INTO `zipcode` (`zipcode`) VALUES (60691);
INSERT INTO `zipcode` (`zipcode`) VALUES (61419);
INSERT INTO `zipcode` (`zipcode`) VALUES (62568);
INSERT INTO `zipcode` (`zipcode`) VALUES (63076);
INSERT INTO `zipcode` (`zipcode`) VALUES (63222);
INSERT INTO `zipcode` (`zipcode`) VALUES (63694);
INSERT INTO `zipcode` (`zipcode`) VALUES (65759);
INSERT INTO `zipcode` (`zipcode`) VALUES (66501);
INSERT INTO `zipcode` (`zipcode`) VALUES (68093);
INSERT INTO `zipcode` (`zipcode`) VALUES (68604);
INSERT INTO `zipcode` (`zipcode`) VALUES (70512);
INSERT INTO `zipcode` (`zipcode`) VALUES (72999);
INSERT INTO `zipcode` (`zipcode`) VALUES (76299);
INSERT INTO `zipcode` (`zipcode`) VALUES (76952);
INSERT INTO `zipcode` (`zipcode`) VALUES (78798);
INSERT INTO `zipcode` (`zipcode`) VALUES (80223);
INSERT INTO `zipcode` (`zipcode`) VALUES (81204);
INSERT INTO `zipcode` (`zipcode`) VALUES (81875);
INSERT INTO `zipcode` (`zipcode`) VALUES (82038);
INSERT INTO `zipcode` (`zipcode`) VALUES (83603);
INSERT INTO `zipcode` (`zipcode`) VALUES (88660);
INSERT INTO `zipcode` (`zipcode`) VALUES (91834);
INSERT INTO `zipcode` (`zipcode`) VALUES (93474);
INSERT INTO `zipcode` (`zipcode`) VALUES (93709);
INSERT INTO `zipcode` (`zipcode`) VALUES (94439);
INSERT INTO `zipcode` (`zipcode`) VALUES (94821);
INSERT INTO `zipcode` (`zipcode`) VALUES (97989);
INSERT INTO `zipcode` (`zipcode`) VALUES (98708);
INSERT INTO `zipcode` (`zipcode`) VALUES (99073);

INSERT INTO `api_key`(`api_key`) VALUES ('');