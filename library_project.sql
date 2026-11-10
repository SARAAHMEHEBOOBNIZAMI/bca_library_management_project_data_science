
-- college library management - sql  project

create database librarydb2;
use librarydb2;

create table members2 (member_id int primary key,member_name varchar(100) not null,
member_type enum('Student', 'Faculty') not null,joined_date date);

create table books2 (
    book_id int primary key,
    title varchar(150) not null,
    author varchar(100),
    category varchar(80),
    price decimal(10,2),
    copies_available int not null default 0
);

create table issues2 (
    issue_id int primary key,
    member_id int not null,
    book_id int not null,
    issue_date date not null,
    due_date date not null,
    return_date date null,
    constraint fk_issues_member foreign key (member_id)
        references members2(member_id),
    constraint fk_issues_book foreign key (book_id)
        references books2(book_id)
);

insert into members2 values
(1, 'Aarav Sharma', 'Student', '2025-06-10'),
(2, 'Diya Rao', 'Student', '2025-06-12'),
(3, 'Kabir Khan', 'Faculty', '2024-08-01'),
(4, 'Meera Nair', 'Student', '2025-07-05'),
(5, 'Rohan Das', 'Faculty', '2024-09-15'),
(6, 'Sara Thomas', 'Student', '2025-08-20');

insert into books2 values
(101, 'Database Systems', 'R. Elmasri', 'Computer Science', 650.00, 2),
(102, 'Learning SQL', 'Alan Beaulieu', 'Computer Science', 520.00, 1),
(103, 'Python Basics', 'John Smith', 'Programming', 450.00, 0),
(104, 'Wings of Fire', 'A. P. J. Abdul Kalam', 'Biography', 300.00, 4),
(105, 'The Alchemist', 'Paulo Coelho', 'Fiction', 250.00, 3),
(106, 'Operating Systems', 'Galvin', 'Computer Science', 700.00, 0);

insert into issues2 values
(1001, 1, 101, '2026-10-01', '2026-10-10', '2026-10-12'),
(1002, 2, 102, '2026-10-03', '2026-10-13', '2026-10-13'),
(1003, 1, 103, '2026-10-05', '2026-10-15', null),
(1004, 3, 101, '2026-10-06', '2026-10-16', '2026-10-20'),
(1005, 4, 104, '2026-10-08', '2026-10-18', '2026-10-17'),
(1006, 2, 105, '2026-10-10', '2026-10-20', null),
(1007, 5, 106, '2026-10-11', '2026-10-21', null),
(1008, 1, 102, '2026-10-15', '2026-10-25', '2026-10-27'),
(1009, 3, 103, '2026-10-16', '2026-10-26', '2026-10-26');

use librarydb2;
show tables;

select * from members2 limit 10;
select * from books2 limit 10;
select * from issues2 limit 10;

-- c1: er diagram 



-- c2: count members, books and issue records.
select
    (select count(*) from members2) as total_members,
    (select count(*) from books2) as total_books,
    (select count(*) from issues2) as total_issue_records;

-- c3: number of titles and total copies in each category.
select
    category,
    count(*) as total_titles,
    sum(copies_available) as total_available_copies
from books2
group by category
order by category;

-- c4: top 5 most borrowed books.
select
    b.book_id,
    b.title,
    count(i.issue_id) as times_borrowed
from books2 as b
join issues2 as i on b.book_id = i.book_id
group by b.book_id, b.title
order by times_borrowed desc, b.title
limit 5;

-- c5: members who have never borrowed a book.
select
    m.member_id,
    m.member_name,
    m.member_type
from members2 as m
left join issues2 as i on m.member_id = i.member_id
where i.issue_id is null
order by m.member_id;

-- c6: books currently issued (not returned), with member and due date.
select
    m.member_name,
    b.title,
    i.due_date
from issues2 as i
join members2 as m on i.member_id = m.member_id
join books2 as b on i.book_id = b.book_id
where i.return_date is null
order by i.due_date;

-- c7: books returned late, days late and fine (rs. 2 per day).
select
    m.member_name,
    b.title,
    i.due_date,
    i.return_date,
    datediff(i.return_date, i.due_date) as days_late,
    datediff(i.return_date, i.due_date) * 2 as fine_rupees
from issues2 as i
join members2 as m on i.member_id = m.member_id
join books2 as b on i.book_id = b.book_id
where i.return_date is not null
  and i.return_date > i.due_date
order by days_late desc;

-- c8: total fine per member (only members who owe a fine).
select
    m.member_id,
    m.member_name,
    sum(datediff(i.return_date, i.due_date) * 2) as total_fine_rupees
from members2 as m
join issues2 as i on m.member_id = i.member_id
where i.return_date is not null
  and i.return_date > i.due_date
group by m.member_id, m.member_name
having sum(datediff(i.return_date, i.due_date) * 2) > 0
order by total_fine_rupees desc;

-- c9: compare student vs faculty usage (number of borrowing records).
select
    m.member_type,
    count(i.issue_id) as total_books_borrowed
from members2 as m
left join issues2 as i on m.member_id = i.member_id
group by m.member_type;

-- c10: rank members by number of books borrowed.
select
    m.member_id,
    m.member_name,
    count(i.issue_id) as books_borrowed,
    rank() over (order by count(i.issue_id) desc) as borrowing_rank
from members2 as m
left join issues2 as i on m.member_id = i.member_id
group by m.member_id, m.member_name
order by borrowing_rank, m.member_name;

-- c11: number of issues per category (most popular category first).
select
    b.category,
    count(i.issue_id) as total_issues
from books2 as b
join issues2 as i on b.book_id = i.book_id
group by b.category
order by total_issues desc;

-- c12: books with zero available copies and at least one pending issue.
select
    b.book_id,
    b.title,
    b.copies_available
from books2 as b
where b.copies_available = 0
  and b.book_id in (
      select i.book_id
      from issues2 as i
      where i.return_date is null
  );

-- c13: stored procedure to show a member's borrowing history.
delimiter //
create procedure member_history(in p_member_id int)
begin
    select
        m.member_id,
        m.member_name,
        b.title,
        i.issue_date,
        i.due_date,
        i.return_date
    from issues2 as i
    join members2 as m on i.member_id = m.member_id
    join books2 as b on i.book_id = b.book_id
    where i.member_id = p_member_id
    order by i.issue_date desc;
end //
delimiter ;


call member_history(1);

-- c14: trigger on copy tables so original data is not changed.


create table books_copy2 like books2;
create table issues_copy2 like issues2;

insert into books_copy2 select * from books2;
insert into issues_copy2 select * from issues2;

delimiter //
create trigger after_issue_insert_copy
after insert on issues_copy2
for each row
begin
    update books_copy2
    set copies_available = copies_available - 1
    where book_id = new.book_id
      and copies_available > 0;
end //
delimiter ;

select book_id, title, copies_available
from books_copy2
where book_id = 104;

insert into issues_copy2
    (issue_id, member_id, book_id, issue_date, due_date, return_date)
values
    (9001, 1, 104, curdate(), date_add(curdate(), interval 14 day), null);

select book_id, title, copies_available
from books_copy2
where book_id = 104;



-- c15: project conclusion and business recommendations.

/*
CONCLUSION:

The College Library Management System was successfully
created using MySQL.

The database stores information about library members,
books and book-issuing records.

Based on the sample data, the following findings were observed:

1. Database Systems, Learning SQL and Python Basics
   are among the most borrowed books, with 2 borrowing
   records each.

2. Computer Science is the most popular book category,
   with 5 borrowing records.

3. Aarav Sharma has borrowed the highest number of books,
   with 3 borrowing records.

4. One member has never borrowed a book.

5. Some members returned books late and were charged
   fines at the rate of Rs. 2 per day.

6. Pending book issues can be monitored to identify
   overdue books and calculate pending fines.

RECOMMENDATIONS:

1. Consider purchasing additional copies of popular books.

2. Send reminders to members who have overdue books.

3. Follow up with members who have outstanding fines.

4. Monitor book availability regularly.

5. Use stored procedures to retrieve member borrowing
   history efficiently.

6. Use triggers to automate book-copy updates when
   new issue records are created.

Overall, this project demonstrates how SQL queries,
joins, aggregate functions, subqueries, stored procedures
and triggers can help manage library operations efficiently.
*/
