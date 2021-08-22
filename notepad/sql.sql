create database mysqltest;

use mysqltest;

show databases;

use teccool;
show tables;

desc admin;

show create table admin

CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `createtime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8

use mysqltest;

create table `admin`(
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	username varchar(20) NOT NULL,
	`password` varchar(30) NOT NULL,
	PRIMARY  KEY(`id`)
)ENGINE=INNODB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8

show tables;
desc admin


alter table `admin` add column isdelete int not null;
alter table `admin` change column isdelete is_delete bigint not null default 1;

insert into `admin` (username, `password`) values ('xiaownag', 'sdfjksalg'),("sad", "sdfsadg4151"),("sdafa", "sad4f516asdf");

select * from `admin`;


update `admin` set is_delete = 0 where username='sad'

replace into `admin` (id, username , `password`, is_delete) values(18, "wwo", "sas", 1);

insert into `admin` (id, username, `password`, is_delete) values (18, "wang", "hahah123", 0) on duplicate key update username = "xi", `password` = "123456" , is_delete = 0

create table photo select * from `admin` where username= 'sdafa'

select * from photo


desc photo

create table `students`(
	`id` bigint not null auto_increment,
	`name` varchar(10) not null,
	`score` double not null,
	`class_id` bigint not null,
	`address` varchar(50) not null,
	PRIMARY KEY (`id`)
)ENGINE=INNODB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8



select * from students;

create table `classes`(
	`id` bigint not null auto_increment,
	`class_name` varchar(40) not null,
	`teacher` varchar(20) not null,
	primary key (`id`)
)engine=innodb auto_increment=2 DEFAULT charset=utf8


insert into classes (`class_name`, `teacher`) values ('三年一班', '郑孝军'), ('三年二班', '赵梅'), ('三年三班', '梅田')

update students set class_id = 3 where address='中国'




select ceiling(avg(score)) as avg, count(*) as `count`, address from students group by address 


select s.name, s.score, address, class_name from students s inner join classes c on s.class_id = c.id 


select * from students


select s.name, s.score, address, class_name from students s left join classes c on s.class_id = c.id 

select s.name, s.score, address, class_name from students s right join classes c on s.class_id = c.id 


create table statistics(
	`id` bigint not null auto_increment,
	`count` bigint not null,
	`avg` bigint not null,
	primary key (`id`)
)ENGINE=INNODB auto_increment = 2 default charset=utf8


alter table statistics add column class_id bigint not null

alter table statistics add column `sum` bigint not null

insert into statistics(`count`, `avg`, `class_id`, `sum`) select count(score), avg(score), class_id,sum(score) from students group by class_id


select * from statistics s inner join classes c on s.class_id = c.id 

insert into statistics(`sum`) select SUM(score) from students group by class_id

create table account(
	`id` bigint not null auto_increment,
	`balance` double not null,
	`admin_id` bigint not null,
	primary key (`id`)
)engine=innodb auto_increment=2 default charset=utf8


insert into account (balance, admin_id) values (10000, 1), (2000, 2)

select * from account;

begin;
update account set balance = balance + 2000 where id = 3;
update account set balance = balance - 2000 where id = 2;
commit;
