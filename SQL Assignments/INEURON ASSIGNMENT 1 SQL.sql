----------------TASK1 SHOPPING_HISTORY----------------------------

create or replace warehouse INEURON_FSDA;
Create or replace database FSDA_SQL;

-- Task 1 shopping histroy
--create shpping history table
create or replace table SHOPPING_HISTORY
(
Product varchar not null,
Quantity integer not null,
Unit_Price integer not null
);
select * from SHOPPING_HISTORY;

--inserting data into table
insert into SHOPPING_HISTORY(Product,Quantity,Unit_Price)
values
('milk',5,20),
('bread',6,30),
('jam',3,40),
('rice',1,1000),
('oli',2,200),
('Lipstick',5,500),
('shampoo',2,450),
('chilli_powder',1,200),
('paneer',1,70),
('egg',5,10);

--For each product totall amount of money spent of it
select distinct PRODUCT,(QUANTITY*UNIT_PRICE) as TOTAL_PRICE from SHOPPING_HISTORY ;

--insert duplicate record 
insert into SHOPPING_HISTORY(Product,Quantity,Unit_Price)
values
('milk',1,10);

--For each product totall amount of money spent of it
with totall_price_cte as 
(
select *,(QUANTITY*UNIT_PRICE) as Total_PRICE from SHOPPING_HISTORY 
)
select PRODUCT,sum(Total_PRICE) from totall_price_cte group by 1;


----------------TASK2 PHONE CALL DURATION ----------------------------

use  warehouse INEURON_FSDA;
use database FSDA_SQL;

show tables;

-- Phone numbers table
create or replace table Phone
(
NAME VARCHAR(20) not null unique,
PHONE_NUMBER integer not null unique 
);

--calls table
create or replace table calls(
ID integer not null,
CALLER integer not null,
CALLEE integer not null,
DURATION integer not null,
UNIQUE(ID)
);

--INSERT INTO PHONE
INSERT INTO Phone(NAME,PHONE_NUMBER)
VALUES('GK',23454),
('KD',34567),
('SUKKU',78938),
('MANI',94413),
('SIVA',95734),
('LALLLI',96765),
('PUPPY',11111);

SELECT * FROM Phone;

--INSERT INTO CALLS
INSERT INTO calls(ID,CALLER,CALLEE,DURATION)
VALUES
(25,23454,96765,8),
(17,96765,78938,9),
(12,96765,94413,4),
(67,95734,12312,3),
(23,34567,95734,9),
(61,11111,94413,1);

SELECT * FROM CALLS;

--PICK THE CLINET WHO TAKING ATLEAST 10 MINS
WITH DURATION_CTE AS 
(
SELECT P.*,C.* FROM PHONE P
JOIN CALLS C
ON P.PHONE_NUMBER=C.CALLER OR P.PHONE_NUMBER=C.CALLEE
),
SUM_DURATION_ALL_CTE AS 
(
SELECT NAME,PHONE_NUMBER,SUM(DURATION) AS TOTAL_DURATION FROM DURATION_CTE GROUP BY 1,2
)
SELECT NAME FROM SUM_DURATION_ALL_CTE WHERE TOTAL_DURATION>=10 ;


-----------------------------TASK 3 BANK BALANCE----------------------------------------------

use  warehouse INEURON_FSDA;
use database FSDA_SQL;

CREATE OR REPLACE TABLE transactions (
AMOUNT INTEGER NOT NULL,
DATE DATE NOT NULL
 );
 
 --INERT INTO
 INSERT INTO transactions (Amount, Date) VALUES 
(1000, '2020-01-06'),
(-10, '2020-01-14'),
(-75, '2020-01-20'),
(-5, '2020-01-25'),
(-4, '2020-01-29'),
(2000, '2020-03-10'),
(-75, '2020-03-12'),
(-20, '2020-03-15'),
(40, '2020-03-15'),
(-50, '2020-03-17'),
(200, '2020-10-10'),
(-200, '2020-10-10');


SELECT * FROM transactions;

--sum of all transactions
select sum(AMOUNT) sum_total from transactions;--2801


-- every month cost of charged is 5, we dont want to charge for particular month if we made
-- at least 3 credit card payments for total cost at least 100 within that month
--In This problem statement we charged for every month except march becoz for total cost transcations in march = 75+20+50==> 145 i.e >100 thus we are not charged for this month
--so 5*11=55 charges we have to pay


---------------------------query-------------------------------------------
WITH A_balance_cte as
(
  SELECT sum(amount) as total , 'BAL' as name FROM  transactions  
),
B_balance_cte AS 
(
  SELECT  count(amount) as cnt  , 'BAL' as name
  From transactions 
  where amount <0 
  group by month(date) 
  having not(count(amount) <3 or  sum(amount) >-100)
),
join_cte as 
(
  select A.*,B.* from A_balance_cte A
  left join
  B_balance_cte B
  On A.name = B.name 
  
)
select (sum(total) - (12- count(cnt))*5 )as BALANCE from join_cte ; 