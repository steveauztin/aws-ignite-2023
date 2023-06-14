CREATE DATABASE bootcamp;
USE bootcamp;
CREATE TABLE address (id INT(4) NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(30), phone VARCHAR(30), email VARCHAR(30));
INSERT INTO address (name, phone, email) VALUES ( "Bob", "630-555-1254", "bob@fakeaddress.com");
INSERT INTO address (name, phone, email) VALUES ( "Alice", "571-555-4875", "alice@address2.us" );
INSERT INTO address (name, phone, email) VALUES ( "Dante", "971-555-7875", "dante@address2.us" );