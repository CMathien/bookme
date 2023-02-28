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
