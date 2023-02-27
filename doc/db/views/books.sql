DROP VIEW IF EXISTS books_list;

CREATE VIEW books_list AS SELECT 
b.book_id, b.book_title, b.book_release_year, i.isbn as book_isbn
FROM book b 
LEFT JOIN isbn i ON (b.book_id = i.book_id)
LEFT JOIN author  ON (b.book_id = i.book_id);
