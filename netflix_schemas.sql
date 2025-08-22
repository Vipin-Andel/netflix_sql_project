-- SCHEMAS of Netflix

CREATE TABLE netflix(
	show_id	VARCHAR(6),
	type VARCHAR(10),
	title TEXT,
	director TEXT,
	casts TEXT,
	country	TEXT,
	date_added TEXT,
	release_year INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in TEXT,
	description TEXT
);
