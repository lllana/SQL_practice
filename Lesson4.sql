###Subqueries
/*
Part 1. On which day-channel pair did the most events occur.
*/
SELECT
    DATE_TRUNC('day', occurred_at) AS event_date,
		channel,
		COUNT(*) AS count_events
FROM web_events
GROUP BY 1,2
ORDER BY 3 desc;

/*
Part 2. Match each channel to its corresponding average number of events per day.
*/
SELECT 	channel,
		    AVG(count_events) AS Avg_count_events
FROM    (SELECT DATE_TRUNC('day', occurred_at) AS event_date,
		           channel,
		           COUNT(*) AS count_events
        FROM web_events
        GROUP BY 1,2) sub
 GROUP BY 1
 ORDER BY 2 desc;

 /*
 What was the month/year combo for the first order placed?
 */
SELECT DATE_TRUNC('month', occurred_at)
FROM orders
ORDER BY 1
LIMIT 1

 /*
 The average amount of standard paper sold on the first month that any order was
 placed in the orders table (in terms of quantity).
 */
 SELECT 	DATE_TRUNC('month', occurred_at),
          AVG(standard_qty)
 FROM orders
 WHERE DATE_TRUNC('month', occurred_at) =
 	  (SELECT DATE_TRUNC('month', occurred_at)
 	  FROM orders
 	  ORDER BY 1
 	  LIMIT 1)
 GROUP BY 1;

 /*
 The average amount of gloss paper sold on the first month that any order was
 placed in the orders table (in terms of quantity).
 */
 SELECT 	DATE_TRUNC('month', occurred_at),
          AVG(gloss_qty)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
	 (SELECT DATE_TRUNC('month', occurred_at)
	  FROM orders
	   ORDER BY 1
	    LIMIT 1)
GROUP BY 1;

 /*
 The average amount of poster paper sold on the first month that any order was
 placed in the orders table (in terms of quantity).
 */
 SELECT 	DATE_TRUNC('month', occurred_at),
          AVG(poster_qty)
 FROM orders
 WHERE DATE_TRUNC('month', occurred_at) =
 	  (SELECT DATE_TRUNC('month', occurred_at)
 	  FROM orders
 	  ORDER BY 1
 	  LIMIT 1)
 GROUP BY 1;

 /*
 The total amount spent on all orders on the first month that any order was
 placed in the orders table (in terms of usd).
 */
SELECT 	DATE_TRUNC('month', occurred_at),
        SUM(total_amt_usd) AS total_usd
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
	 (SELECT DATE_TRUNC('month', occurred_at)
	  FROM orders
	   ORDER BY 1
	    LIMIT 1)
GROUP BY 1;
