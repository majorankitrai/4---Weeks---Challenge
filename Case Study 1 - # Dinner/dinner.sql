-- Created Data base ankit
use ankit;

-- Created Table goldusers_signup
create table goldusers_signup (
id int,
gold_signup_date date)

-- create table product
create table product(
product_id int,
product_name varchar(30),
price int)

-- create table sales
create table sales (
id int,
created_at date,
product_id int)

-- create table users
create table users (
user_id int,
signup_date date)
show tables ;

-- Inserting Value onr by one to each Tables:

insert into  goldusers_signup values (1,'2017-09-22');
insert into goldusers_signup  values (3,'2017-04-21');

insert into product values (1,'p1',1200);
insert into product values (2,'p2',1400);
insert into product values (3,'p3',600);

insert into sales values (1,'2017-04-25',2);
insert into sales values (2,'2017-08-25',1);
insert into sales values (3,'2017-06-19',3);
insert into sales values (1,'2017-08-25',2);
insert into sales values (1,'2017-04-27',1);
insert into sales values (2,'2017-04-13',3);
insert into sales values (3,'2017-09-02',2);
insert into sales values (1,'2017-03-25',2);
insert into sales values (3,'2017-01-25',1);
insert into sales values (2,'2017-03-24',1);
insert into sales values (1,'2017-02-25',3);
insert into sales values (1,'2017-05-13',3);
insert into sales values (2,'2017-07-24',1);
insert into sales values (2,'2017-07-25',1);
insert into sales values (3,'2017-06-25',2);
insert into sales values (3,'2017-04-25',2);
insert into sales values (2,'2017-01-11',3);
insert into sales values (1,'2017-06-15',1);
insert into sales values (3,'2017-04-29',1);

insert into users values (1,'2014-03-01');
insert into users values (2,'2015-01-15');
insert into users values (3,'2011-04-11');

-- Question or Metrics of SQL


Q1.What is total amount each customer spent on zomato?

select s.id,sum(p.price) as total_amount from sales s inner join product p on s.product_id = p.product_id 
group by s.id;


Q2.How many days each customer visited zomato?

select id , count(distinct created_at) as visited from sales group by id;


Q3.What was the first product purchased by each customer?

with cte as(
select *,rank() over(partition by id order by created_at asc) rnk from sales )
select * from cte where rnk=1;


Q4.What is the most purchased item on the menu and how many times was it purchased by all customers

select id,count(product_id) as cnt from sales where product_id = 
(select product_id from sales group by product_id order by count(product_id) desc limit 1)
group by id;


Q5.Which item is most popular for each customer?

select * from 
(select *,rank() over(partition by id order by cnt desc) as rnk from
(select id,product_id,count(product_id) cnt from sales group by id,product_id)a)b
where rnk =1;


Q6.Which item was first prchased by customer after they become member?

select * from 
(select c.* ,rank() over(partition by id order by created_at) rnk from
(select a.id,a.product_id,a.created_at,b.gold_signup_date from sales a inner join goldusers_signup b on a.id=b.id and created_at >= gold_signup_date)c)d
where rnk =1;

Q7.Which item was purcased just before the customer become member?

select * from 
(select *, rank() over(partition by id order by created_at desc) rnk from 
(select a.id,a.created_at,a.product_id,b.gold_signup_date from sales a 
inner join goldusers_signup b on a.id =b.id and a.created_at <= b.gold_signup_date)a)b where rnk =1;


Q8.What is the total orders and amount spent for each member before they become member?

select id,count(created_at) as orders,sum(price) as amount from 
(select c.*,d.price from 
(select a.id,a.created_at,a.product_id,b.gold_signup_date from sales a 
inner join goldusers_signup b on a.id = b.id and a.created_at <= b.gold_signup_date)c inner join product d on  
c.product_id = d.product_id)e
group by id; 


Q9.If buying each product generetes points for eg 5rs=2 zomato point and each product has different purchasing points for eg 
for p1 5rs=1 zomato point , for p2 10rs=5 zomato point and p3 5rs=1 zomato point.
Calculate point collected by each customers and for which product most points have been given till mow.?

select *,rank() over(order by total_points desc) rnk from 
(select f.id,sum(total_points) as total_points from
(select e.*,round(amount/points,0) as total_points from
(select d.*,case when
product_id = 1 then 5 when product_id = 2 then 2 when product_id = 3 then 5 else 0 end as points from 
(select c.id,c.product_id,sum(c.price) as amount from 
(select a.*,b.price from sales a inner join product b on a.product_id = b.product_id)c
group by id,product_id)d)e) f 
group by id)f;


Q10.In the first one year after a customer joins the gold program (including their join date) irrespective of what 
the customer has purchased they earn 5 zomato points for every 10 rs spent who earned more 1 or 3 and what was thier points earning in thier first year?

select c.*,d.price*0.5 as total_points from
(select a.id,a.created_at,a.product_id,b.gold_signup_date from sales a 
inner join goldusers_signup b on a.id = b.id and created_at >=gold_signup_date and created_at <= gold_signup_date+365)c
inner join product d on c.product_id = d.product_id;


Q11. Rank all the transaction of the customer?

Select *,rank() over(partition by id order by created_at asc) rnk from sales ;


Q12.rank all the transaction for each member whenever they are a zomato gold member for every non gold member transaction mark as na

select e.*,case when rnk = 0 then 'na' else rnk end as rnkk from
(select c.*, cast((case when gold_signup_date is null then 0 else rank() over(partition by id order by created_at desc) end) as varchar) as rnk from 
(select a.id,a.created_at,a.product_id,b.gold_signup_date from sales a left join
goldusers_signup b on a.id = b.id and created_at >= gold_signup_date)c)e;