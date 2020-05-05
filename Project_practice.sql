/*
Let's start with creating a table that provides the following details: actor's
first and last name combined as full_name, film title, film description and
length of the movie.
*/
SELECT 	(a.first_name)||' '||(a.last_name) AS full_name,
		    f.title,
        f.description,
        f.length
FROM film f
JOIN film_actor fa
ON fa.film_id = f.film_id
JOIN actor a
ON fa.actor_id = a.actor_id

/*
Write a query that creates a list of actors and movies where the movie length
was more than 60 minutes. How many rows are there in this query result?
*/
SELECT (a.first_name)||' '||(a.last_name) AS full_name,
        f.title,
        f.length
FROM film f
JOIN film_actor fa
ON fa.film_id = f.film_id
JOIN actor a
ON fa.actor_id = a.actor_id
WHERE f.length > 60
ORDER BY 3;

/*
Write a query that captures the actor id, full name of the actor, and counts the
number of movies each actor has made. (HINT: Think about whether you should
group by actor id or the full name of the actor.) Identify the actor who has
made the maximum number movies.
*/
SELECT  a.actor_id,
        (a.first_name)||' '||(a.last_name) AS full_name,
        COUNT(f.*) AS film_count
FROM film f
JOIN film_actor fa
ON fa.film_id = f.film_id
JOIN actor a
ON fa.actor_id = a.actor_id
GROUP BY 1
ORDER BY 3 desc;

/*
Write a query that displays a table with 4 columns:
actor's full name,
film title,
length of movie,
and a column name "filmlen_groups" that classifies movies based on their length.
Filmlen_groups should include 4 categories:
1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.

Match the filmlen_groups with the movie titles in your result dataset.
*/

SELECT
    (a.first_name)||' '||(a.last_name) AS full_name,
    f.title,
    f.length,
    CASE WHEN f.length > 180 THEN 'More than 3 hours'
        WHEN f.length > 120 THEN 'Between 2-3 hours'
        WHEN f.length > 60 THEN 'Between 1-2 hours'
        ELSE '1 hour or less' END AS filmlen_groups
FROM film f
JOIN film_actor fa
ON fa.film_id = f.film_id
JOIN actor a
ON fa.actor_id = a.actor_id
ORDER BY 3;

/*
OR
*/

SELECT full_name,
       filmtitle,
       filmlen,
       CASE WHEN filmlen <= 60 THEN '1 hour or less'
       WHEN filmlen > 60 AND filmlen <= 120 THEN 'Between 1-2 hours'
       WHEN filmlen > 120 AND filmlen <= 180 THEN 'Between 2-3 hours'
       ELSE 'More than 3 hours' END AS filmlen_groups
FROM
    (SELECT a.first_name,
               a.last_name,
               a.first_name || ' ' || a.last_name AS full_name,
               f.title filmtitle,
               f.length filmlen
        FROM film_actor fa
        JOIN actor a
        ON fa.actor_id = a.actor_id
        JOIN film f
        ON f.film_id = fa.film_id) t1

/*
Now, we bring in the advanced SQL query concepts!
Revise the query you wrote above to create a count of movies in each of
the 4 filmlen_groups:
1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.

Match the count of movies in each filmlen_group.
*/
SELECT DISTINCT(filmlen_group),
      COUNT(title) OVER (PARTITION BY filmlen_group) AS film_counts
FROM (
  SELECT title, length,
        CASE WHEN length <= 60  then '1 hour or less'
            WHEN length >60 AND length <=120 then 'Between 1-2 hours'
            WHEN length >120 AND length <=180 then 'Between 2-3 hours'
            ELSE 'more than 3 hours' END AS filmlen_group
  FROM film) f1
  ORDER BY 2 desc;


###Questions_set1
/*
Create a query that lists each movie,
the film category it is classified in,
and the number of times it has been rented out.
For this query, you will need 5 tables:
Category,
Film_Category,
Inventory,
Rental and Film.

Your solution should have three columns:
Film title,
Category name
Count of Rentals.

The following table header provides a preview of what the resulting table should
 look like if you order by category name followed by the film title.
*/

WITH f1 AS (
  SELECT f.title film_title, c.name category_name
  FROM film f
    JOIN film_category fc
    ON fc.film_id = f.film_id
    JOIN category c
    ON fc.category_id = c.category_id
    WHERE c.name IN ('Animation','Children','Classics','Comedy','Family','Music'),

    f2 AS (SELECT f.title film_title,
          COUNT(r.*) AS rental_count
    FROM rental r
    JOIN Inventory i
    ON i.inventory_id = r.inventory_id
    JOIN film f
    ON i.film_id = f.film_id
    GROUP BY 1
    ORDER BY 2 desc)

SELECT f1.film_title, f1.category_name,
      f2.rental_count
FROM f1
JOIN f2
ON f1.film_title = f2.film_title
ORDER BY 2,1;

/*
 Can you provide a table with
 - the movie titles and divide them into 4 levels
 (first_quarter, second_quarter, third_quarter, and final_quarter)
 based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories?
 Make sure to also indicate the category that these family-friendly movies fall into.
*/

SELECT  film_title,
        category_name,
        rental_duration,
        CASE WHEN standard_quartile = 1 THEN 'first_quarter_25%'
              WHEN standard_quartile = 2 THEN 'second_quarter_50%'
              WHEN standard_quartile = 3 THEN 'third_quarter_75%'
              ELSE 'final_quarter' END AS quartile_level
FROM(
  SELECT f.title film_title,
        c.name category_name,
        f.rental_duration rental_duration,
        NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
  FROM film f
    JOIN film_category fc
    ON fc.film_id = f.film_id
    JOIN category c
    ON fc.category_id = c.category_id
    WHERE c.name IN ('Animation','Children','Classics','Comedy','Family','Music'))t1

/*
Finally, provide a table with the family-friendly film category,
each of the quartiles, and the corresponding count of movies within each
combination of film category for each corresponding rental duration category.
 The resulting table should have three columns:
- Category,
- Rental length category
- Count
*/
WITH t1 AS (
  SELECT c.name category_name,
        NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
  FROM film f
    JOIN film_category fc
    ON fc.film_id = f.film_id
    JOIN category c
    ON fc.category_id = c.category_id
    WHERE c.name IN ('Animation','Children','Classics','Comedy','Family','Music')) t1

  SELECT category_name, standard_quartile, Count(category_name) AS count
  FROM t1
  GROUP BY 1,2
  ORDER BY 1,2;



    ###Questions_set2
/*
We want to find out how the two stores compare in their count of rental orders
during every month for all the years we have data for. Write a query that returns
the store ID for the store, the year and month and the number of rental orders
each store has fulfilled for that month. Your table should include a column for
each of the following: year, month, store ID and count of rental orders fulfilled
during that month.
*/

SELECT DATE_PART('Month',r.rental_date) rental_month,
      DATE_PART('Year',r.rental_date) rental_year,
      i.store_id,
      COUNT (r.*)
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
GROUP BY 1,2,3
ORDER BY 4 desc;

/*
We would like to know who were our top 10 paying customers, how many payments
they made on a monthly basis during 2007, and what was the amount of the monthly
payments. Can you write a query to capture the customer name, month and year of
payment, and total payment amount for each month by these top 10 paying customers?
*/
WITH top_10 AS
    (SELECT (c.first_name)||' '||(c.last_name) full_name,
            c.customer_id,
            SUM(p.amount)
    FROM customer c
    JOIN payment p
    ON p.customer_id = c.customer_id
    GROUP BY 1,2
    ORDER BY 3 desc
    LIMIT 10)

SELECT DATE_TRUNC('month', p.payment_date) pay_month,
      top_10.full_name,
      COUNT(p.*),
      SUM(p.amount) pay_amt
FROM payment p
JOIN top_10
ON p.customer_id = top_10.customer_id
GROUP BY 1,2
ORDER BY 2,1;

/*
Finally, for each of these top 10 paying customers, I would like to find out
the difference across their monthly payments during 2007. Please go ahead and
write a query to compare the payment amounts in each successive month. Repeat
this for each of these 10 paying customers. Also, it will be tremendously
helpful if you can identify the customer name who paid the most difference in
terms of payments.
*/
WITH top_10 AS
    (SELECT (c.first_name)||' '||(c.last_name) full_name,
            c.customer_id,
            SUM(p.amount)
    FROM customer c
    JOIN payment p
    ON p.customer_id = c.customer_id
    GROUP BY 1,2
    ORDER BY 3 desc
    LIMIT 10),

    p1 AS
    (SELECT DATE_TRUNC('month', payment_date) AS pay_month,
    customer_id,
    COUNT(*) AS pay_count,
    SUM(amount) AS pay_amount
    FROM payment
    GROUP BY 1,2)

SELECT top_10.full_name, p1.pay_month,
        p1.pay_amount,
        LAG(p1.pay_amount) OVER (PARTITION BY top_10.full_name ORDER BY p1.pay_month) lag,
        p1.pay_amount - LAG(p1.pay_amount,1) OVER (PARTITION BY top_10.full_name ORDER BY p1.pay_month) AS lag_difference
FROM top_10
JOIN p1
ON p1.customer_id = top_10.customer_id
ORDER BY 5 desc;

###Submission Questions
/*
Where is located the rental store with the highest average payment?
*/

WITH top AS (
    SELECT  s.store_id store_id,
            AVG(p.amount) average_payment
    FROM staff s
    JOIN payment p
    ON s.staff_id = p.staff_id
    GROUP BY 1
    ORDER BY 2 desc),

st_add AS (
    SELECT  s.store_id,
            ci.city city,
            co.country country
        FROM store s
        JOIN address a
        ON s.address_id = a.address_id
        JOIN city ci
        ON a.city_id = ci.city_id
        JOIN country co
        ON ci.country_id = co.country_id)

SELECT top.store_id, top.average_payment, st_add.city, st_add.country
FROM top
JOIN st_add
ON top.store_id = st_add.store_id;

/*
What month drama movies had the biggest sales?
*/
SELECT category, d_month, AVG(d_amt) payment_amt
FROM (
      WITH d AS (
            SELECT  fc.film_id film_id,
                    c.name category
            FROM category c
            JOIN film_category fc
            ON c.category_id = fc.category_id
            WHERE c.name = 'Drama'),

        p AS (
            SELECT i.film_id film_id,
                  DATE_TRUNC('month', p.payment_date) new_date,
                  SUM (p.amount) payment_amt
            FROM inventory i
            JOIN rental r
            ON i.inventory_id = r.inventory_id
            JOIN payment p
            ON r.customer_id = p.customer_id
            GROUP BY 1,2),

        d1 AS (
          SELECT d.category category,
                  d.film_id film_id,
                  p.new_date new_date,
                  p.payment_amt pay_amt
          FROM d
          JOIN p
          ON d.film_id = p.film_id)

  SELECT d1.category category, d1.film_id, d1.new_date, DATE_PART('month', d1.new_date) d_month,
          SUM(d1.pay_amt) OVER (ORDER BY d1.new_date) AS d_amt
  FROM d1
  ORDER BY 5 desc) sub

GROUP BY 1,2
ORDER BY 3 desc;

/*
What store made the biggest difference in monthly sales in period from February to May 2007?
*/


/*
What the top 5 actors played just in movies with a 'high' level of rental score?
*/
