-- Created database Pizza
create database Pizza ;
use Pizza;

drop table runners_orders ;

-- Created table runners_orders
create table runners_orders (
order_id int,
runner_id int,
pickup_time varchar(20),
distance varchar(20),
duration varchar(20),
cancellation varchar(100) )

-- Created table runners
create table runners (
runner_id int,
registration_date date)

-- Created table Customer_orders
create table customer_orders (
order_id int,
customer_id int,
pizza_id int,
exclusion varchar(10),
extras varchar(10),
order_date timestamp )

-- Created table pizza_mames
create table pizza_names (
pizza_id int,
pizza_name varchar(20) )

-- Created table Pizza_receipe
create table pizza_receipe (
pizza_id int,
topping text )

-- created table pizza_toping
create table pizza_toping (
topping_id int,
topping_name text)

-- Created values in each tables

insert into runners_orders values ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', '');
insert into runners_orders values ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', '') ;
insert into runners_orders values  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL);
insert into runners_orders values  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL) ;
insert into runners_orders values  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL);
insert into runners_orders values  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation');
insert into runners_orders values   ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null');
insert into runners_orders values     ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null');
insert into runners_orders values  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation');
insert into runners_orders values ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

insert into runners values (1, '2021-01-01');
insert into runners values (2, '2021-01-03');
insert into runners values  (3, '2021-01-08');
insert into runners values   (4, '2021-01-15');

insert into customer_orders values ('1', '101', '1', '', '', '2020-01-01 18:05:02');
insert into customer_orders values ('2', '101', '1', '', '', '2020-01-01 19:00:52');
insert into customer_orders values ('3', '102', '1', '', '', '2020-01-02 23:51:23') ;
insert into customer_orders values  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23') ;
insert into customer_orders values ('4', '103', '1', '4', '', '2020-01-04 13:23:46') ;
insert into customer_orders values   ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29');
insert into customer_orders values ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13');
insert into customer_orders values  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29');
insert into customer_orders values ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33');
insert into customer_orders values ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59');
insert into customer_orders values ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49');
insert into customer_orders values ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

insert into pizza_names values (1, 'Meatlovers');
insert into pizza_names values   (2, 'Vegetarian');

insert into pizza_receipe values (1, '1, 2, 3, 4, 5, 6, 8, 10');
insert into pizza_receipe values   (2, '4, 6, 7, 9, 11, 12');

insert into pizza_toping values (1, 'Bacon');
insert into pizza_toping values (2, 'BBQ Sauce');
insert into pizza_toping values (3, 'Beef');
insert into pizza_toping values (4, 'Cheese');
insert into pizza_toping values (5, 'Chicken');
insert into pizza_toping values (6, 'Mushrooms');
insert into pizza_toping values (7, 'Onions');
insert into pizza_toping values   (8, 'Pepperoni');
insert into pizza_toping values (9, 'Peppers');
insert into pizza_toping values (10, 'Salami');
insert into pizza_toping values (11, 'Tomatoes');
insert into pizza_toping values (12, 'Tomato Sauce');


-- Questions and Metrics on SQL Query

-- Q1. How many Pizza were ordered?

select count(*) as pizzas_ordered from customer_orders;

-- Q2.How many unique customer order were made?

select count(distinct(order_id)) as unique_orders from customer_orders;

-- Q3. How many successful orders were delievered by each runner?

select r.runner_id,count(distinct c.order_id) from customer_orders c inner join runners_orders r on c.order_id = r.order_id where pickup_time <> 'null'
group by r.runner_id;

-- Q4. How many each  type of pizza was delievered?

select p.pizza_name,count(c.pizza_id) from customer_orders c inner join runners_orders r on c.order_id = r.order_id
inner join pizza_names p on c.pizza_id = p.pizza_id
where pickup_time <> 'null'
group  by p.pizza_name;

-- Q5. How many vegeterian and meatlovers were ordered by each customer?

select c.customer_id,p.pizza_name,count(p.pizza_name) from customer_orders c inner join pizza_names p on c.pizza_id = p.pizza_id
group by c.customer_id ,p.pizza_name;

-- Q6. What was the maximum number of pizzas delivered in a single order?

select c.order_id,count(c.pizza_id) as pizza_orders from customer_orders c inner join runners_orders r on c.order_id = r.order_id
where r.pickup_time <> 'null'
group by c.order_id
order by count(c.pizza_id) desc
limit 1;

-- Q7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select c.order_id,
c.customer_id,
(c.exclusion is not null and c.exclusion <> 'null' and length(c.exclusion) >0) or (c.extras is not null and c.extras <> 'null' and length(c.extras) >0) as changes,
count(c.pizza_id)
from customer_orders c inner join
runners_orders r on c.order_id = r.order_id where pickup_time <> 'null'
group by 1,2;

-- Q8. How many pizza have delieverd that has both extras and exclusive?

select
c.order_id,
extras,
exclusion,
(exclusion is not null and exclusion <> 'null' and length(exclusion) >0) and
(extras is not null and extras <> 'null' and length(extras) >0) as any_changes
from customer_orders c inner join runners_orders r on c.order_id = r.orders_id
where pickup_time <> 'null';

-- Q9. How many total volume of pizza orders for each hour of day?

select
hour(order_date) as hour,
count(pizza_id) as pizza_ordered
from customer_orders
group by hour(order_date);

-- Q10. What was the volume of orders for each day of week?

select
day(order_date) as hour,
count(pizza_id) as pizza_ordered
from customer_orders
group by day(order_date);


-- Section - B ( Runners and Customer Experience)

Q1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)?

select case
when registration_date between '2021-01-07' and '2021-01-07' then 1 
when registration_date between '2021-01-08' and '2021-01-14' then 2
else 3 end as registraion_week,
count(runner_id) from runners
group by 
case
when registration_date between '2021-01-07' and '2021-01-07' then 1 
when registration_date between '2021-01-08' and '2021-01-14' then 2
else 3 end ;

-- Q2. What was the average time in minutes it took for each runner 
 --    to arrive at the Pizza Runner HQ to pickup the order?
 
with time_taken_cte as
(
	select r.runner_id,c.order_id,c.order_time,r.pickup_time, 
		DATEDIFF(MINUTE,c.order_time,r.pickup_time) as arrival_time_in_mins
	from #customer_orders as c
	join #runner_orders as r on
		c.order_id=r.order_id
	where r.cancellation=''
	group by r.runner_id,c.order_id,c.order_time,r.pickup_time
)

select runner_id,avg(arrival_time_in_mins) as avg_arrival_time_in_mins
from time_taken_cte
where arrival_time_in_mins>1
group by runner_id
    
-- Q3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
select * from customer_orders;
select * from runners_orders;
select c.order_id,
-- count(c.order_id) as pizza_ordered,
c.order_date,r.pickup_time
-- DATEDIFF(MINUTE,c.order_date,r.pickup_time) as prep_time_in_mins
from customer_orders c join runners_orders r on c.order_id = r.order_id 
group by c.order_id;

Q4. What was the average distance travelled for each customer?

select c.order_id,avg(r.distance) as average_distance from customer_orders c inner join runners_orders r on 
c.order_id = r.order_id
where cancellation =''
group by c.order_id;

Q.5 What was the difference between the longest and shortest delivery times for all orders?

select max(duration) - min(duration) as differnce_time from runners_orders
where duration != 0;

Q6.What was the average speed for each runner for each delivery and do you notice any trend for these values?

select runner_id,round(avg(distance/duration),2) as speed from runners_orders 
where cancellation = ''
group by runner_id,duration;

Q7. What is the successful delivery percentage for each runner?

select runner_id,count(order_id) as successful_deleivery from runners_orders where 
cancellation = ''
group by runner_id;


Section - C (Ingredient Optimisation)

Q1.What are the standard ingredients for each pizza?
select * from pizza_names;
select * from pizza_receipe;
select * from pizza_toping;