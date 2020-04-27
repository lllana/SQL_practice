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

/*
Provide the name of the sales_rep in each region with the largest amount of
total_amt_usd sales.
*/
SELECT t3.sales_rep_name, t3.region_name, t2.total_sales
FROM
  (SELECT region_name, MAX(total_sales)total_sales
  FROM
    (SELECT s.name sales_rep_name, r.name region_name, SUM(o.total_amt_usd) total_sales
    FROM sales_reps s
    JOIN region r
    ON r.id=s.region_id
    JOIN accounts a
    ON s.id=a.sales_rep_id
    JOIN orders o
    ON a.id=o.account_id
    GROUP BY 1,2
    ORDER BY 3 desc)t1
  GROUP BY 1)t2
JOIN
  (SELECT s.name sales_rep_name, r.name region_name, SUM(o.total_amt_usd) total_sales
  FROM sales_reps s
  JOIN region r
  ON r.id=s.region_id
  JOIN accounts a
  ON s.id=a.sales_rep_id
  JOIN orders o
  ON a.id=o.account_id
  GROUP BY 1,2
  ORDER BY 3 desc)t3
ON t3.region_name=t2.region_name AND t3.total_sales=t2.total_sales

/*
For the region with the largest (sum) of sales total_amt_usd, how many total
(count) orders were placed?
*/
SELECT r.name region_name, COUNT(o.total) order_count
FROM region r
JOIN sales_reps s
ON r.id=s.region_id
JOIN accounts a
ON s.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (
  SELECT MAX(total_amt)
  FROM
    (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
    FROM region r
    JOIN sales_reps s
    ON r.id=s.region_id
    JOIN accounts a
    ON s.id=a.sales_rep_id
    JOIN orders o
    ON a.id=o.account_id
    GROUP BY 1
    ORDER BY 2 desc)sub
                            )

/*
How many accounts had more total purchases than the account name which has bought
the most standard_qty paper throughout their lifetime as a customer?
*/

/*
For the customer that spent the most (in total over their lifetime as a customer)
 total_amt_usd, how many web_events did they have for each channel?
*/

/*
What is the lifetime average amount spent in terms of total_amt_usd for the top
10 total spending accounts?
*/

/*
What is the lifetime average amount spent in terms of total_amt_usd, including
only the companies that spent more per order, on average, than the average of
all orders.
*/
