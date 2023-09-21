CREATE DATABASE testdb;
\c testdb;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(50)
);

INSERT INTO users (username, password) VALUES
('user1', 'password1'),
('user2', 'password2'),
('admin', 'admin');
