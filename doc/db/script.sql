CREATE TABLE book(
   book_id COUNTER,
   book_title VARCHAR(255) NOT NULL,
   book_release_year INT NOT NULL,
   PRIMARY KEY(book_id)
);

CREATE TABLE author(
   author_id COUNTER,
   author_last_name VARCHAR(255) NOT NULL,
   author_first_name VARCHAR(50) NOT NULL,
   PRIMARY KEY(author_id)
);

CREATE TABLE genre(
   genre_id COUNTER,
   genre_label VARCHAR(50),
   PRIMARY KEY(genre_id)
);

CREATE TABLE zipcode(
   zipcode INT,
   PRIMARY KEY(zipcode)
);

CREATE TABLE country(
   country_id COUNTER,
   country_name VARCHAR(255),
   PRIMARY KEY(country_id)
);

CREATE TABLE isbn(
   isbn COUNTER,
   book_id INT NOT NULL,
   PRIMARY KEY(isbn),
   FOREIGN KEY(book_id) REFERENCES book(book_id)
);

CREATE TABLE reading_status(
   reading_status_id COUNTER,
   reading_status_label VARCHAR(50) NOT NULL,
   PRIMARY KEY(reading_status_id)
);

CREATE TABLE reaction(
   reaction_id COUNTER,
   reaction_label VARCHAR(50),
   PRIMARY KEY(reaction_id)
);

CREATE TABLE status(
   status_id COUNTER,
   status_label VARCHAR(50),
   PRIMARY KEY(status_id)
);

CREATE TABLE state(
   state_id COUNTER,
   state_label VARCHAR(50) NOT NULL,
   PRIMARY KEY(state_id)
);

CREATE TABLE user(
   user_id COUNTER,
   user_pseudo VARCHAR(255) NOT NULL,
   user_email VARCHAR(255) NOT NULL,
   user_password TEXT NOT NULL,
   user_avatar VARCHAR(255),
   user_public_comments LOGICAL NOT NULL,
   user_balance INT,
   user_banned LOGICAL NOT NULL,
   user_admin LOGICAL NOT NULL,
   zipcode INT NOT NULL,
   PRIMARY KEY(user_id),
   UNIQUE(user_pseudo),
   UNIQUE(user_email),
   FOREIGN KEY(zipcode) REFERENCES zipcode(zipcode)
);

CREATE TABLE city(
   city_id COUNTER,
   city_name VARCHAR(255),
   country_id INT NOT NULL,
   PRIMARY KEY(city_id),
   FOREIGN KEY(country_id) REFERENCES country(country_id)
);

CREATE TABLE possessed_book(
   possessed_book_id COUNTER,
   book_id INT NOT NULL,
   state_id INT,
   reaction_id INT,
   reading_status_id INT,
   user_id INT NOT NULL,
   PRIMARY KEY(possessed_book_id),
   FOREIGN KEY(book_id) REFERENCES book(book_id),
   FOREIGN KEY(state_id) REFERENCES state(state_id),
   FOREIGN KEY(reaction_id) REFERENCES reaction(reaction_id),
   FOREIGN KEY(reading_status_id) REFERENCES reading_status(reading_status_id),
   FOREIGN KEY(user_id) REFERENCES user(user_id)
);

CREATE TABLE borrowing(
   possessed_book_id INT,
   borrowing_id COUNTER NOT NULL,
   borrowing_start_date DATETIME NOT NULL,
   borrowing_end_date DATETIME NOT NULL,
   status_id INT NOT NULL,
   user_id INT NOT NULL,
   PRIMARY KEY(possessed_book_id),
   UNIQUE(borrowing_id),
   FOREIGN KEY(possessed_book_id) REFERENCES possessed_book(possessed_book_id),
   FOREIGN KEY(status_id) REFERENCES status(status_id),
   FOREIGN KEY(user_id) REFERENCES user(user_id)
);

CREATE TABLE reminder(
   reminder_id COUNTER,
   reminder_date DATETIME NOT NULL,
   possessed_book_id INT NOT NULL,
   PRIMARY KEY(reminder_id),
   FOREIGN KEY(possessed_book_id) REFERENCES borrowing(possessed_book_id)
);

CREATE TABLE message(
   user_id INT,
   user_id_1 INT,
   message_id COUNTER NOT NULL,
   message_content TEXT NOT NULL,
   message_date DATETIME,
   PRIMARY KEY(user_id, user_id_1),
   UNIQUE(message_id),
   FOREIGN KEY(user_id) REFERENCES user(user_id),
   FOREIGN KEY(user_id_1) REFERENCES user(user_id)
);

CREATE TABLE write(
   book_id INT,
   author_id INT,
   PRIMARY KEY(book_id, author_id),
   FOREIGN KEY(book_id) REFERENCES book(book_id),
   FOREIGN KEY(author_id) REFERENCES author(author_id)
);

CREATE TABLE belong(
   book_id INT,
   genre_id INT,
   PRIMARY KEY(book_id, genre_id),
   FOREIGN KEY(book_id) REFERENCES book(book_id),
   FOREIGN KEY(genre_id) REFERENCES genre(genre_id)
);

CREATE TABLE comment(
   book_id INT,
   user_id INT,
   comment_id COUNTER NOT NULL,
   comment_content TEXT NOT NULL,
   comment_date DATETIME NOT NULL,
   comment_suggestion LOGICAL NOT NULL,
   PRIMARY KEY(book_id, user_id),
   UNIQUE(comment_id),
   FOREIGN KEY(book_id) REFERENCES book(book_id),
   FOREIGN KEY(user_id) REFERENCES user(user_id)
);

CREATE TABLE locate(
   zipcode INT,
   city_id INT,
   PRIMARY KEY(zipcode, city_id),
   FOREIGN KEY(zipcode) REFERENCES zipcode(zipcode),
   FOREIGN KEY(city_id) REFERENCES city(city_id)
);

CREATE TABLE donate(
   possessed_book_id INT,
   donation_date DATETIME,
   user_id INT NOT NULL,
   status_id INT NOT NULL,
   PRIMARY KEY(possessed_book_id),
   FOREIGN KEY(possessed_book_id) REFERENCES possessed_book(possessed_book_id),
   FOREIGN KEY(user_id) REFERENCES user(user_id),
   FOREIGN KEY(status_id) REFERENCES status(status_id)
);
