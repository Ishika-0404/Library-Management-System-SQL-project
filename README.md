# Library Management System using SQL Project

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_db`

This project demonstrates the development of a comprehensive Library Management System using SQL. It covers the entire process of database design, including the creation of tables, management of records, and performing essential CRUD operations (Create, Read, Update, Delete). Additionally, the project implements advanced SQL queries to address real-world scenarios like tracking borrowed books, managing user accounts, calculating overdue fines, and generating reports. The objective is to showcase proficiency in database architecture, data manipulation, and complex querying to solve business-driven problems efficiently.

**Key Features:**

            1.User and book management (adding, updating, deleting).
            2.Tracking borrow/return dates.
            3.Fine calculation for overdue books.
            4.Reports on library activity (e.g., most borrowed books, active borrowers).
            
**SQL Concepts Used:**

            1.Table creation and normalization.
            2.Joins and subqueries.
            3.Aggregate functions.
            4.Transactions and constraints.
            5.Stored procedures
            
## Objectives

1.**Set up the Library Management System Database:**
Design and create a relational database that includes tables for managing various aspects of a library:

            a.Branches: Details about library branches.
            b.Employees: Information about staff managing the library.
            c.Members: Records of library members.
            d.Books: A catalog of available books with relevant metadata (title, author, genre, etc.).
            e.Issued Books: Track the issuance of books to members, including issue dates and return deadlines.
            f.Return Status: Keep records of returned books and track overdue returns for fine calculation.

2.**CRUD Operations:**
Implement essential operations to manage the system's data:

            a. Create: Add new records for books, members, employees, and issue transactions.
            b. Read: Retrieve data like available books, active members, or current borrowed books.
            c. Update: Modify existing records, such as updating return status or book details.
            d. Delete: Remove outdated or erroneous data from the system.

3.**CTAS (Create Table As Select):**
Use CTAS to generate new tables from the result of complex queries. This technique helps in:

            a. Creating summary tables for frequent reports.
            b. Backing up data for analysis.
            c. Simplifying repeated complex queries by storing their results in new tables.

4.**Advanced SQL Queries:**
Develop complex SQL queries to address specific business needs, such as:

            a. Identifying overdue books and calculating fines.
            b. Generating reports on the most borrowed books.
            c. Finding the most active members.
            d. Tracking employee activity based on issued/returned books.
            e. Analyzing book availability across different branches

## Project Structure

### 1. Database Setup

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE Library_management_project;
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
```

### 2. CRUD Operations

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql

update members 
set member_address ='111 main st'
where member_id='C103';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
delete from issued_status 
where issued_id='IS121'
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql

SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
create table Book_count as
select  b.isbn, b.book_title ,
	count(i.issued_id) 
from issued_status i 
join books b 
	on i.issued_book_isbn = b.isbn
group by b.isbn , 
	b.book_title
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
select * from books 
where category = 'Classic'

```

8. **Task 8: Find Total Rental Income by Category**:

```sql
select b.category,
	sum(b.rental_price), 
	count(*) 
from books b 
join issued_status i
	on i.issued_book_isbn = b.isbn
group by category
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
select member_id 
from members 
where reg_date>= current_date - interval '180 day'

```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
    e1.emp_id,
	b.*,
    e1.emp_name,
    e1.position,
    e1.salary,
    
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
create table expensive_books as
select * from books 
where rental_price >7.00

```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
select m.member_id,
	m.member_name, 
	b.book_title,
	issued_date, 
	current_date - i.issued_date as days_overdue
from issued_status i
join members m  
	on m.member_id = i.issued_member_id
join books b 
	on b.isbn=i.issued_book_isbn
left join return_status r 
	on r.issued_id=i.issued_id
where r.return_date is null 
	and 
	(current_date - i.issued_date) > 30 
order by m.member_id
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql


create or replace procedure add_return_record(p_return_id varchar(15) ,p_issued_id varchar(15) , p_book_quality  varchar(15))
language plpgsql
as $$

declare
	v_isbn varchar(25);
	v_book_name varchar(75);

begin
	insert into return_status (return_id, issued_id, return_date, book_quality)
	values (p_return_id, p_issued_id, current_date , p_book_quality);

	select 
	issued_book_isbn, issued_book_name
	into
	v_isbn, v_book_name
	from issued_status
	where issued_id = p_issued_id;

	update books
	set status='yes'
	where isbn = v_isbn;

	raise notice 'Thank you for returning book : %', v_book_name;

end;
$$

--testing function

isbn = IS135

select * from issued_status
where issued_id = 'IS135'

select * from books 
where isbn='978-0-307-58837-1'

-- calling function 

call add_return_record('RS140','IS135', 'Good' );



```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql

CREATE TABLE branch_reports
AS
select br.branch_id, 
	br.manager_id, 
	count(i.issued_id) as num_books_issued,
	count(r.return_id) as num_books_returned,
	sum(b.rental_price) as total_revenue
from branch br 
join employees e
	on br.branch_id = e.branch_id
join issued_status i 
	on e.emp_id= i.issued_emp_id
left join return_status r
	on i.issued_id= r.issued_id
join books b
	on b.isbn= i.issued_book_isbn
group by br.branch_id
order by br.branch_id;


SELECT * FROM branch_reports;
```

**Task 16: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
select e.emp_name,
	b.* ,
	count(i.issued_id)
from employees e 
join branch b 
	on e.branch_id=b.branch_id
join issued_status i
	on e.emp_id = i.issued_emp_id
group by e.emp_id,
	b.branch_id
order by count(i.issued_id) desc limit 3
```

**Task 17: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    
```sql

select e.emp_name, e.emp_id,
	b.book_title,
	count(i.issued_id) as issued_book
from employees e
join issued_status i 
	on e.emp_id = i.issued_emp_id
join books b 
	on i.issued_book_isbn= b.isbn
join return_status r
	on r.issued_id = i.issued_id
group by e.emp_id,
	b.book_title
having count(i.issued_id)>1
order by e.emp_id
	,b.book_title
```

**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

create or replace procedure issue_book(p_issued_id varchar(15), p_issued_member_id varchar(15), p_issued_book_isbn varchar(25), p_issued_emp_id varchar(15))
language plpgsql
as $$

declare
	v_status varchar(15);

begin
-- write logic here
	--if the book is available 
	select 
		status 
		into 
		v_status
	from books 
	where isbn= p_issued_book_isbn;

	If v_status = 'yes' then
		insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn,issued_emp_id) 
		values (p_issued_id, p_issued_member_id, current_date, p_issued_book_isbn, p_issued_emp_id);

	update books
	set status='no'
	where isbn = p_issued_book_isbn;	

	raise notice 'Record updated successfully for book %',p_issued_book_isbn;
	
	Else
		raise notice 'Sorry to inform the book you requested is unavailable and book id %',p_issued_book_isbn;
	

	End IF;

end 
$$

--issued books 
isbn = "978-0-141-44171-6" - yes
isbn = "978-0-7432-7357-1" - no

select * from books where isbn = '978-0-375-50167-0';
select * from issued_status;

--calling dunction
call issue_book('IS156', 'C105', '978-0-7432-7357-1', 'E101');

```



**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
```sql
create table Overdue_books_fine as
select m.member_id,
	count(i.issued_id) as overdue_books,
 	current_date - i.issued_date as days_overdue,
	(0.50 * (current_date - i.issued_date)) as fine
from issued_status i
join members m  
	on m.member_id = i.issued_member_id
join books b 
	on b.isbn=i.issued_book_isbn
left join return_status r 
	on r.issued_id=i.issued_id
where r.return_date is null 
	and 
	(current_date - i.issued_date) > 30 
group by i.issued_id,
	m.member_id,
	b.book_title
order by m.member_id


select * from Overdue_books_fine;

```
## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion
This project showcases the practical application of SQL in building and managing a Library Management System. It covers database setup, data manipulation through CRUD operations, and advanced querying techniques for insightful analysis. By focusing on both the technical and analytical aspects, this project provides a solid foundation in SQL-based data management and business-driven analysis, essential for effective decision-making.
