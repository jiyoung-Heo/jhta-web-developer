-- comments.sql
create table movie
(
	mnum number(5) primary key,
	title varchar2(20),
	content varchar2(100),
	director varchar2(20)
);
create table comments
(
	num number(5) primary key,
	mnum number(5) references movie(mnum),
	id varchar2(10),
	comments varchar2(50)
);
create sequence movie_seq;
create sequence comments_seq;
insert into movie values(movie_seq.nextval,'무서운영화1','무서운이야기','김감독');
insert into movie values(movie_seq.nextval,'재밌는영화1','재미있는이야기','이감독');
commit;
