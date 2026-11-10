
Course: Bachelor of Computer Applications (BCA)
Database Name: librarydb2
Software: MySQL Workbench

College Library Management System

 SQL Research Project – Section C

 1. Project Overview

The College Library Management System is a database project developed using MySQL. It is designed to manage library information such as books, members, book-issuing records, and return details.

The project demonstrates how SQL can be used to maintain library records, analyse borrowing patterns, identify overdue books, calculate fines, and automate database operations.

 2. Project Objectives

- To create and manage a college library database.
- To maintain records of books and library members.
- To track issued and returned books.
- To identify the most borrowed books.
- To identify members who have never borrowed books.
- To calculate fines for late book returns.
- To analyse borrowing patterns of students and faculty.
- To implement stored procedures and triggers.

 3. Technologies Used

- Database: MySQL
- Software: MySQL Workbench
- Query Language: SQL
- Project Repository: GitHub

 4. Database Information

Database Name: `librarydb2`

The project contains the following main tables:

| Table | Description |
|---|---|
| members2 | Stores member information |
| books2 | Stores book details and available copies |
| issues2 | Stores book-issuing and return records |
| books_copy2 | Copy of books table used for trigger demonstration |
| issues_copy2 | Copy of issues table used for trigger demonstration |

 5. Entity Relationship Diagram

The database contains three main entities:

- Members: Stores member ID, name, member type, and joining date.
- Books: Stores book ID, title, author, category, price, and available copies.
- Issues: Stores issue ID, member ID, book ID, issue date, due date, and return date.

The Issues table connects Members and Books through foreign keys.

 6. SQL Concepts Implemented

The project covers the following SQL concepts:

1. Database creation and selection.
2. Table creation using CREATE TABLE.
3. Primary keys and foreign keys.
4. Inserting sample records using INSERT INTO.
5. Retrieving records using SELECT.
6. Filtering and sorting data.
7. Aggregate functions such as COUNT and SUM.
8. GROUP BY and HAVING clauses.
9. INNER JOIN and LEFT JOIN.
10. Subqueries.
11. Ranking using the RANK() function.
12. Date calculations using DATEDIFF().
13. Stored procedures.
14. Database triggers.

 7. Project Queries and Analysis

The project includes the following business queries:

- Counting total members, books, and issue records.
- Finding the number of books and available copies in each category.
- Identifying the five most borrowed books.
- Finding members who have never borrowed a book.
- Displaying books that are currently issued.
- Identifying late book returns and calculating fines.
- Calculating total fines for each member.
- Comparing borrowing activity between students and faculty.
- Ranking members based on borrowing activity.
- Identifying the most popular book categories.
- Finding books with no available copies but pending issues.

 8. Stored Procedure

A stored procedure named `member_history` is created to display the borrowing history of a particular member.

It accepts a member ID as input and displays the member's borrowed books, issue dates, due dates, and return dates.

9. Trigger Implementation

A trigger named `after_issue_insert_copy` is created on the `issues_copy2` table.

When a new issue record is inserted into the copied issues table, the trigger automatically decreases the available book copies in `books_copy2`, provided that at least one copy is available.

The trigger is tested using a sample issue record.

Separate copied tables are used to demonstrate the trigger without modifying the original sample data.

10. Key Findings

Based on the sample records:

- Database Systems, Learning SQL, and Python Basics are among the most borrowed books.
- Computer Science is the most popular category.
- Aarav Sharma has the highest number of borrowing records.
- One registered member has never borrowed a book.
- Some members returned books after their due dates and incurred fines.

### 11. Conclusion

The College Library Management System demonstrates the practical application of SQL in managing library operations.

Through this project, I gained practical experience in database creation, data insertion, retrieval, joins, aggregate functions, subqueries, stored procedures, and triggers.

The project shows how database management can help maintain accurate library records, monitor book availability, track overdue returns, and analyse borrowing activities efficiently.

### 12. How to Run the Project

1. Install and open MySQL Workbench.
2. Connect to the MySQL server.
3. Open the `library_project.sql` file.
4. Execute the complete SQL script in a fresh database environment.
5. Verify the database using `SHOW TABLES;`.
6. Run the individual queries to view the results.
7. Test the stored procedure and trigger.

Note: The script creates the database `librarydb2`. If running it again, existing objects may need to be removed before recreating them.


Project Title: College Library Management System  
Course: SQL – Section C  
Project Type: Research Project  
Database: MySQL  
Platform: MySQL Workbench and GitHub