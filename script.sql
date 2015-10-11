CREATE DATABASE terminos;
USE terminos;
CREATE TABLE terminos (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    terminos text not null,
    cantidad int(12) not null,
    peso text not null,
    path text not null
);
CREATE TABLE links_doc (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    path text not null,
    link text not null,
    num_pal int(12) not null
);
