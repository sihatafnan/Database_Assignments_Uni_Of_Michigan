create table books

(

bookid int primary key,

title varchar(20) not null,

usd_price numeric(6,2) check (usd_price >= 0)

);

create table ebooks

(

bookid int primary key references books(bookId), format char(3) not null
);

create table authors

(

authorId int primary key,

name varchar(20) unique not null

);

create table publications

(

authorId int references authors(authorId) not null, bookId int references books(bookId) not null, constraint pk primary key (authorId, bookId)

);

create table citations

(

citingBookId int references books(bookId) not null, citedBookId int references books(bookId) not null, constraint noSelfCitations check (citingBookId<>citedBookId)

);
