book = (book_id COUNTER, book_title VARCHAR(255), book_release_year INT);
author = (author_id COUNTER, author_last_name VARCHAR(255), author_first_name VARCHAR(50));
genre = (genre_id COUNTER, genre_label VARCHAR(50));
zipcode = (zipcode INT);
country = (country_id COUNTER, country_name VARCHAR(255));
isbn = (isbn COUNTER, #book_id);
reading_status = (reading_status_id COUNTER, reading_status_label VARCHAR(50));
reaction = (reaction_id COUNTER, reaction_label VARCHAR(50));
status = (status_id COUNTER, status_label VARCHAR(50));
state = (state_id COUNTER, state_label VARCHAR(50));
user = (user_id COUNTER, user_pseudo VARCHAR(255), user_email VARCHAR(255), user_password TEXT, user_avatar VARCHAR(255), user_public_comments LOGICAL, user_balance INT, user_banned LOGICAL, user_admin LOGICAL, #zipcode);
city = (city_id COUNTER, city_name VARCHAR(255), #country_id);
possessed_book = (possessed_book_id COUNTER, #book_id, #state_id*, #reaction_id*, #reading_status_id*, #user_id);
borrowing = (#possessed_book_id, borrowing_id COUNTER, borrowing_start_date DATETIME, borrowing_end_date DATETIME, #status_id, #user_id);
reminder = (reminder_id COUNTER, reminder_date DATETIME, #(#possessed_book_id));
message = (#user_id, #user_id_1, message_id COUNTER, message_content TEXT, message_date DATETIME);
write = (#book_id, #author_id);
belong = (#book_id, #genre_id);
comment = (#book_id, #user_id, comment_id COUNTER, comment_content TEXT, comment_date DATETIME, comment_suggestion LOGICAL);
locate1 = (#zipcode, #city_id);
donate = (#possessed_book_id, donation_date DATETIME, #user_id, #status_id);