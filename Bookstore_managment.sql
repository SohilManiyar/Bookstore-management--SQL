create database OnlineBookStore;

use OnlineBookStore;

CREATE TABLE Books (
    Book_ID serial PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price numeric(10, 2),
    Stock INT
);


CREATE TABLE Customer (
    Customer_ID serial PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    City VARCHAR(100),
    Country VARCHAR(100)
);
CREATE TABLE Orders (
    Order_ID serial PRIMARY KEY,
    Customer_ID INT references Customer(Customer_ID),
    Book_ID INT references Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10, 2)
   
);



select*from Orders;
 select*from Customer;
select*from  Books;


-- 1> Retreve all books in the "Fiction" genre
select * from books where Genre='Fiction';


-- 2) Find books published after the year 1950:
select count(*)from books where Published_year>1950;  

-- 3) List all customers from the Canada:
select* from customer where country='Canada'; -- 3
select*from orders where Order_Date='2023-11' ;   -- not execute query

-- 4) Show orders placed in November 2023:
select *from orders where order_date Between '2023-11-01' AND '2023-11-30';


-- 5) Retrieve the total stock of books available:
select sum(stock)from books group by stock;

-- 6) Find the details of the most expensive book:
select * from Books where Price=( select max(price)from Books ) ;   --     ISE lImit ki help se bhe kr skte order by price  desc   limit 1 

-- 7) Show all customers who ordered more than 1 quantity of a book:
select *from orders where Quantity >1;   

-- 8) Retrieve all orders where the total amount exceeds $20:
select*from orders where Total_Amount >20;  

-- 9) List all genres available in the Books table:
select distinct  Genre from Books; -- 9

-- 10) Find the book with the lowest stock:
select*from Books where stock=(Select MIN(stock)from books  ); 

-- 11) Calculate the total revenue generated from all orders:
select sum(Total_Amount) AS Total_Revenue from orders ;



            --    ADVANCED QUERY 
 -- 1) Retrieve the total number of books sold for each genre:

 select 	Genre,count(genre)  from books group by Genre order by genre desc  ;

-- 2) Find the average price of books in the "Fantasy" genre:
select sum(price) from books where Genre='Fantasy';

 select*from books where price =(select avg(price)from books where Genre='Fantasy');   -- 2
 
-- 3) List customers who have placed at least 2 orders:
 select *from Customer  where Customer_ID IN  (select Customer_id from Orders where quantity>2);
 -- 4) Find the most frequently ordered book:
select Genre ,count(genre)from books  group by Genre order by count(*) desc ;  

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select author,genre ,Price from books where Genre='Fantasy' order by Price  desc  limit 5;  -- 5
-- 6) Retrieve the total quantity of books sold by each author:
select   B.Author,sum(O.Quantity) as qunatity  from Books B join Orders O on B.Book_ID=O.Book_ID Group by B.Author;

-- 2nd method 
SELECT B.Book_ID, B.Author, SUM(O.Quantity) AS quantity
FROM Books B
JOIN Orders O ON B.Book_ID = O.Book_ID
GROUP BY B.Book_ID, B.Author order by B.Book_id;
  

-- List the cities where customer who spent over $30 are located    -- 7   

 Select distinct C.customer_id ,C.city,O.Total_Amount from Customer C join  Orders O  on C.Customer_ID=O.Customer_ID  where Total_Amount> 30;
 
 
 
 -- 8 find the customer who spent the most on orders 
select C.Customer_ID, C.Name,sum(O.total_amount)as Total_spent from Customer C    join  Orders O on  C.Customer_ID= O.Customer_ID
 group by C.Customer_ID , C.name order by  Total_spent desc ;
 
 
 
 -- 9 calculate the stock renaming after fulfill all orders     # it is more complex query for me   & new 
 select  B.book_id,B.title,B.stock,COALESCE(sum(O.Quantity),0) as Quantity ,B.stock- COALESCE(sum(O.Quantity),0) as remaning from Books B left join Orders O on  B.book_id =O.book_id group by 
 B.book_id