use sakila;
-- 1a Display the first and last names of all actors 
select first_name, last_name 
from   actor; 
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`
select concat(first_name," ", last_name) as 'Actor Name'
from          actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
select actor_id, first_name, last_name
from   actor
where first_name="Joe";
-- 2b. Find all actors whose last name contain the letters `GEN`:
select actor_id, first_name, last_name
from   actor
where last_name like "%gen%";
-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select actor_id, first_name, last_name
from   actor
where last_name like "%li%"
order by last_name, first_name asc;
-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country in
('Afghanistan', 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor.
-- create a column in the table `actor` named `description`
-- use the data type `BLOB` (Make sure to research the type `BLOB`
----------- type `BLOB`, as the difference between it and `VARCHAR` are significant).
alter table actor
add column description BLOB;
#### COLUMN ALREADY ADDED IF ERROR POPS UP ######

select * from actor;
#### CONFIRMS ADDED ROW RETURNED #####

-- 3b. Delete the `description` column.
alter table actor drop column description

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as 'Number of Actors'
From actor group by last_name;
-- 4b. List last names of actors and the number of actors who have that last name,
-- but only for names that are shared by at least two actors
select last_name, count(*) as 'Number of Actors'
From actor group by last_name having count(*) >=2;
-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor`
-- table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'Williams';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
-- It turns out that `GROUCHO` was the correct name after all! In a single query, 
-- if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor
set first_name = 'GROUCHO'
where actor_id = 172;

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
describe sakila.address;
-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:

select first_name, last_name, address
from staff s
join address a
on s.address_id = a.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
from staff inner join payment on
staff.staff_id = payment.staff_id and payment_date like '2005-08%';

-- 6c. List each film and the number of actors who are listed for that film.
-- Use tables `film_actor` and `film`. Use inner join.
select f.title as 'film title', count(fa.actor_id) as 'Number of Actors'
from film_actor fa
inner join film f
on fa.film_id= f.film_id
group by f.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select title, (
select count(*) from inventory
where film.film_id = inventory.film_id
) as 'Number of Copies'
from film
where title = 'Hunchback Impossible';

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command,
-- list the total paid by each customer. List the customers alphabetically by last name:
----------- ![Total amount paid](Images/total_payment.png)
select	c.first_name, c.last_name, sum(p.amount) as cust_total
from	payment p
		,customer c
where	p.customer_id = c.customer_id
group by c.last_name, c.first_name
order by c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters `K` and `Q` have also
-- soared in popularity. Use subqueries to display the titles of movies starting with the letters
-- `K` and `Q` whose language is English.
select title
from film where title
like 'k%' or title like 'Q%'
and title in
(
select title
from film
where language_id = 1
);

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select first_name, last_name
from actor
where actor_id IN
(
select actor_id
from film_actor
where film_id IN
(
select film_id
from film
where title = 'Alone Trip'
));

-- 7c. You want to run an email marketing campaign in Canada, for which you will
-- need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select cus.first_name, cus.last_name, cus.email
from customer cus
join address a
on (cus.address_id = a.address_id)
join city cty
on (cty.city_id = a.city_id)
join country
on (country.country_id = cty.country_id)
where country.country= 'Canada';

-- 7e. Display the most frequently rented movies in descending order.
select f.title, count(rental_id) as 'Times Rented'
from rental r
join inventory i
on (r.inventory_id = i.inventory_id)
join film f
on (i.film_id = f.film_id)
group by f.title
order by 'Times Rented' DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(amount) as 'Revenue'
from payment p
join rental r
on (p.rental_id = r.rental_id)
join inventory i
on (i.inventory_id = r.inventory_id)
join store s
on (s.store_id = i.store_id)
group by s.store_id;
 
-- 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, cty.city, country.country
from store s
join address a
on (s.address_id = a.address_id)
join city cty
on (cty.city_id = a.city_id)
join country
on (country.country_id = cty.country_id);


-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you 
-- may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS Genre, SUM(p.amount) as Gross_revenue
FROM payment p
		,rental r
        ,inventory i
        ,film_category fc
        ,category c
WHERE	p.rental_id=r.rental_id
and		r.inventory_id=i.inventory_id
and		i.film_id=fc.film_id
and		fc.category_id = c.category_id
group by c.name
order by 2 DESC
limit 5
;
        
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top
-- five genres by gross revenue. Use the solution from the problem above to create a view.
-- If you haven't solved 7h, you can substitute another query to create a
CREATE VIEW genre_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross'
FROM category c
JOIN film_category fc
ON (c.category_id=fc.category_id)
JOIN inventory i
ON (fc.film_id=i.film_id)
JOIN rental r
ON (i.inventory_id=r.inventory_id)
JOIN payment p
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross LIMIT 5;
#### CREATED VIEW ALREADY ADDED IF ERROR POPS UP ######


-- 8b. How would you display the view that you created in 8a?
show create view genre_revenue;
SELECT * FROM genre_revenue;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW genre_revenue;

## Appendix: List of Tables in the Sakila DB

--  A schema is also available as `sakila_schema.svg`. Open it with a browser to view.

-- ```sql



















