-- This is a query analyzing store sales and how well the stoes performed using WITH/CTEs 

CREATE DATABASE Employee_salary;
-- QUERY 1 :
drop table emp;
create table employee
( employee_ID int
, employee_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 40000);
insert into employee values(102, 'James', 50000);
insert into employee values(103, 'Robin', 60000);
insert into employee values(104, 'Carol', 70000);
insert into employee values(105, 'Alice', 80000);
insert into employee  values(106, 'Jimmy', 90000);

-- WITH clauses can also be referred to as CTEs = Common Table Expression also sub query factoring 

-- fetch employees who earn more than average salary of all employees
with average_salary(avg_sal) as
           (select cast(avg(salary) as integer) from employee)
select*
from employee e, average_salary av
where e.salary > av.avg_sal


-- find stores whose sales were better than the average sales across all stores
-- find total sales per every store
select s.store_id, sum(cost) as total_sales_per_store
from sales s
group by s.store_id
-- find the average sales with respect to all stores -- Avg _sales
select cast(avg(total_sales_per_store)as int) as avg_sales_for_all_stores
from(select s.store_id, sum(cost) as total_sales_per_store
from sales s
group by s.store_id)x
-- find the stores where total_sales > Avg_sales of all stores

select*
from(select s.store_id, sum(cost) as total_sales_per_store
    from sales s
    group by s.store_id) total_sales
Join(select cast(avg(total_sales_per_store)as int) as avg_sales_for_all_stores
     from(select s.store_id, sum(cost) as total_sales_per_store
             from sales s
             group by s.store_id)x) avg_sales
on total_sales.total_sales_per_store > avg_sales.avg_sales_for_all_stores

-- OR

with total_sales(store_id, total_sales_per_store) as
      (select s.store_id, sum(cost) as total_sales_per_store
      from sales s
      group by s.store_id),
avg_sales(avg_sales_for_all_stores) as
          (select cast(avg(total_sales_per_store)as int) as avg_sales_for_all_stores
          from total_sales)
select*
from total_sales ts
join avg_sales av
on ts.total_sales_per_store > avg_sales_for_all_stores





























select * from emp;

with avg_sal(avg_salary) as
		(select cast(avg(salary) as int) from emp)
select *
from emp e
join avg_sal av on e.salary > av.avg_salary





-- QUERY 2 :
DrOP table sales ;
create table sales
(
	store_id  		int,
	store_name  	varchar(50),
	product			varchar(50),
	quantity		int,
	cost			int
);
insert into sales values
(1, 'Apple Originals 1','iPhone 12 Pro', 1, 1000),
(1, 'Apple Originals 1','MacBook pro 13', 3, 2000),
(1, 'Apple Originals 1','AirPods Pro', 2, 280),
(2, 'Apple Originals 2','iPhone 12 Pro', 2, 1000),
(3, 'Apple Originals 3','iPhone 12 Pro', 1, 1000),
(3, 'Apple Originals 3','MacBook pro 13', 1, 2000),
(3, 'Apple Originals 3','MacBook Air', 4, 1100),
(3, 'Apple Originals 3','iPhone 12', 2, 1000),
(3, 'Apple Originals 3','AirPods Pro', 3, 280),
(4, 'Apple Originals 4','iPhone 12 Pro', 2, 1000),
(4, 'Apple Originals 4','MacBook pro 13', 1, 2500);

select * from sales;


-- Find total sales per each store
select s.store_id, sum(s.cost) as total_sales_per_store
from sales s
group by s.store_id;


-- Find average sales with respect to all stores
select cast(avg(total_sales_per_store) as int) avg_sale_for_all_store
from (select s.store_id, sum(s.cost) as total_sales_per_store
	from sales s
	group by s.store_id) x;



-- Find stores who's sales where better than the average sales accross all stores
select *
from   (select s.store_id, sum(s.cost) as total_sales_per_store
				from sales s
				group by s.store_id
	   ) total_sales
join   (select cast(avg(total_sales_per_store) as int) avg_sale_for_all_store
				from (select s.store_id, sum(s.cost) as total_sales_per_store
		  	  		from sales s
			  			group by s.store_id) x
	   ) avg_sales
on total_sales.total_sales_per_store > avg_sales.avg_sale_for_all_store;



-- Using WITH clause
WITH total_sales as
		(select s.store_id, sum(s.cost) as total_sales_per_store
		from sales s
		group by s.store_id),
	avg_sales as
		(select cast(avg(total_sales_per_store) as int) avg_sale_for_all_store
		from total_sales)
select *
from   total_sales
join   avg_sales
on total_sales.total_sales_per_store > avg_sales.avg_sale_for_all_store;
