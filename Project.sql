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

SELECT DISTINCT(filmlen_groups),
      COUNT(title) OVER (PARTITION BY filmlen_groups) AS filmcount_bylencat
FROM
    (SELECT title, length,
    CASE WHEN f.length > 180 THEN 'More than 3 hours'
        WHEN f.length > 120 THEN 'Between 2-3 hours'
        WHEN f.length > 60 THEN 'Between 1-2 hours'
        ELSE '1 hour or less' END AS filmlen_groups
FROM film f) t1
ORDER BY 1

/*
*/

/*
*/

/*
*/

/*
*/

/*
*/
