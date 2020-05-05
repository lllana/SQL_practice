###Submission Questions
/*
Where are located the rental stores with the highest total sales?*/

WITH top AS (
    SELECT  s.store_id store_id,
            SUM(p.amount) payment
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

SELECT top.store_id, top.payment, st_add.city, st_add.country
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

  SELECT d1.category category, d1.film_id, d1.new_date d_month,
          SUM(d1.pay_amt) OVER (ORDER BY d1.new_date) AS d_amt
  FROM d1
  ORDER BY 4 desc) sub

GROUP BY 1,2
ORDER BY 3 desc;


/*
Movies of what categories more frequently fall under designated rental score levels?
*/
(SELECT DISTINCT category, rental_level, COUNT (film_id)
FROM (
      SELECT  fc.film_id film_id,
              c.name category,
              CASE WHEN f.rental_rate = '4.99' THEN 'High level'
                  WHEN f.rental_rate = '2.99' THEN 'Medium level'
                  ELSE 'Low level' END AS rental_level
      FROM category c
      JOIN film_category fc
      ON c.category_id = fc.category_id
      JOIN film f
      ON f.film_id = fc.film_id) SUB
WHERE rental_level = 'High level'
GROUP BY 1,2
ORDER BY 3 desc
LIMIT 5)

UNION ALL

(SELECT DISTINCT category, rental_level, COUNT (film_id)
FROM (
      SELECT  fc.film_id film_id,
              c.name category,
              CASE WHEN f.rental_rate = '4.99' THEN 'High level'
                  WHEN f.rental_rate = '2.99' THEN 'Medium level'
                  ELSE 'Low level' END AS rental_level
      FROM category c
      JOIN film_category fc
      ON c.category_id = fc.category_id
      JOIN film f
      ON f.film_id = fc.film_id) SUB
WHERE rental_level = 'Medium level'
GROUP BY 1,2
ORDER BY 3 desc
LIMIT 5)

UNION ALL

(SELECT DISTINCT category, rental_level, COUNT (film_id)
FROM (
      SELECT  fc.film_id film_id,
              c.name category,
              CASE WHEN f.rental_rate = '4.99' THEN 'High level'
                  WHEN f.rental_rate = '2.99' THEN 'Medium level'
                  ELSE 'Low level' END AS rental_level
      FROM category c
      JOIN film_category fc
      ON c.category_id = fc.category_id
      JOIN film f
      ON f.film_id = fc.film_id) SUB
WHERE rental_level = 'Low level'
GROUP BY 1,2
ORDER BY 3 desc
LIMIT 5)

/*
What are full names of the best sellers among staff members in May 2007?
*/

SELECT
      (s.first_name)||' '||(s.last_name) AS full_name,
      DATE_TRUNC('month', p.payment_date) month_date,
      SUM(p.amount)
FROM staff s
JOIN payment p
ON p.staff_id = s.staff_id
WHERE  DATE_TRUNC('month', p.payment_date) = '2007-05-01'
GROUP BY 1,2
ORDER BY 3 desc
