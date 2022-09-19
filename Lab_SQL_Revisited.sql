use sakila;

-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.

select distinct(c.first_name), c.last_name, c.email from customer c
join rental r on c.customer_id = r.customer_id;

-- 2. What is the average payment made by each customer 
## display the customer id, customer name (concatenated), and the average payment made.

select * from payment;

select p.customer_id, concat(c.first_name, " ", c.last_name) customer_name, avg(p.amount) average_payment from payment p
left join customer c on p.customer_id = c.customer_id
group by customer_id;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies.
	
## Write the query using multiple join statements

create or replace view customers_action1 as
select distinct(concat(c.first_name, " ", c.last_name)) customer_name from customer c
join rental r on c.customer_id = r.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film_category fc on i.film_id = fc.film_id
left join category ca on fc.category_id = ca.category_id
where ca.name = "Action";

select * from customers_action1;

## Write the query using sub queries with multiple WHERE clause and IN condition

create or replace view customers_action2 as
select distinct(concat(first_name, " ", last_name)) customer_name from customer
where customer_id in (
	select customer_id
    from rental
    where inventory_id in (
		select inventory_id
        from inventory
        where film_id in (
			select film_id
            from film_category
            where category_id in (
				select category_id
                from category ca
                where name = "Action"
                )
			)
		)
	)
;

select * from customers_action2;

## Verify if the above two queries produce the same results or not

select * from customers_action1 c1
join customers_action2 c2
on c1.customer_name = c2.customer_name;

select count(c1.customer_name) join_count, count(c2.customer_name) wherein_count from customers_action1 c1
join customers_action2 c2
on c1.customer_name = c2.customer_name;
  
-- 4.Use the case statement to create a new column classifying existing columns 
-- as either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, 
-- the label should be medium, and if it is more than 4, then it should be high.

select *,
case
when amount between 0 and 2 then "Low"
when amount between 2 and 4 then "Medium"
when amount > 4 then "High"
else "N/A"
end as "payment_classification"
from payment;