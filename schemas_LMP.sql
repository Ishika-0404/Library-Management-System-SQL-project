drop table if exists Branch;
create table Branch(
	branch_id varchar(10) primary key,
	manager_id varchar(10),
	branch_address varchar(50),
	contact_no varchar(10)
)

alter table Branch 
alter column contact_no type varchar(25)


drop table if exists Employees;
create table Employees(
	emp_id varchar(10) primary key,
	emp_name varchar(25),
	position varchar(25),
	salary int,
	branch_id varchar(25)

)

alter table Employees 
alter column salary type float




drop table if exists Books;
create table Books(
	isbn varchar(25) PRIMARY KEY,
	book_title varchar(75),
	category varchar(15),
	rental_price float,
	status varchar(15),
	author varchar(35),
	publisher VARCHAR(55)

)
alter table books 
alter column category type varchar(25)

select * from books
drop table if exists Members;
create table Members(
	member_id varchar(25) PRIMARY KEY,
	member_name varchar(25),
	member_address varchar(75),
	reg_date date
)

drop table if exists Issued_status;
create table Issued_status(
	issued_id varchar(15) PRIMARY KEY,
	issued_member_id varchar(15),
	issued_book_name varchar(75),
	issued_date date,
	issued_book_isbn varchar(15),
	issued_emp_id varchar(15)
)

alter table Issued_status 
alter column issued_book_isbn type varchar(25)


drop table if exists Return_status;
create table Return_status(
	return_id varchar(15) PRIMARY KEY,
	issued_id varchar(15),
	return_book_name varchar(75),
	return_date date,
	return_book_isbn varchar(25)

)

--foriegn key--

alter table issued_status
add constraint fk_members
foreign key (issued_member_id)
references Members(member_id)


alter table issued_status
add constraint fk_isbn
foreign key (issued_book_isbn)
references books(isbn)

alter table issued_status
add constraint fk_emp_id
foreign key (issued_emp_id)
references Employees(emp_id)

alter table Return_status
add constraint fk_issued_id
foreign key (issued_id)
references issued_status(issued_id)

alter table Employees
add constraint fk_branch
foreign key (branch_id)
references Branch(branch_id)