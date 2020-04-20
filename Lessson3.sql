###COUNT_the_№_of_rows
SELECT COUNT(*)
FROM accounts;

SELECT COUNT(accounts.id)
FROM accounts;

###SUMs
/*
Find the total amount of poster_qty paper ordered in the orders table.
*/
SELECT SUM(poster_qty)
FROM orders;

/*
Find the total amount of standard_qty paper ordered in the orders table
*/
SELECT SUM(standard_qty)
FROM orders;

/*
Find the total dollar amount of sales using the total_amt_usd in the orders
table.
*/

SELECT SUM(total_amt_usd)
FROM orders;

/*
Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for
each order in the orders table. This should give a dollar amount for each order
in the table.
*/
SELECT 	standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

/*
Find the standard_amt_usd per unit of standard_qty paper. Your solution should
use both an aggregation and a mathematical operator.
*/
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS total_standard_per_unit
FROM orders;


###MIN_MAX
SELECT  MIN(standard_qty) AS standart_min
        MAX(standard_qty) AS standart_max
FROM orders

/*
When was the earliest order ever placed? You only need to return the date.
*/
SELECT MIN(occurred_at) AS earliest_order
FROM orders

/*
Try performing the same query as in question 1 without using an aggregation
function
*/
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

/*
When did the most recent (latest) web_event occur?
*/
SELECT occurred_at
FROM web_events
ORDER BY occurred_at
LIMIT 1

/*
Try to perform the result of the previous query without using an aggregation
function.
*/

SELECT MIN(occurred_at)
FROM web_events

/*Find the mean (AVERAGE) amount spent per order on each paper type, as well as
the mean amount of each paper type purchased per order. Your final answer should
have 6 values - one for each paper type for the average number of sales, as well
as the average amount.
*/
SELECT 	AVG(standard_qty) mean_standard,
        AVG(gloss_qty) mean_gloss,
        AVG(poster_qty)mean_poster,
        AVG(standard_amt_usd) mean_standard_usd,
		    AVG(gloss_amt_usd) mean_gloss_usd,
        AVG(poster_amt_usd) mean_poster_usd
 FROM orders;
/*
Though this is more advanced than what we have covered so far try finding - what
is the MEDIAN total_usd spent on all orders? Note, this is more advanced than
the topics we have covered thus far to build a general solution, but we can hard
code a solution in the following way.
*/
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

###GroupBy

/*
Which account (by name) placed the earliest order? Your solution should have the
account name and the date of the order.
*/
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

/*
Find the total sales in usd for each account. You should include two columns -
the total sales for each company's orders in usd and the company name.
*/

/*
Via what channel did the most recent (latest) web_event occur, which account was
associated with this web_event? Your query should return only three values - the
date, channel, and account name.
*/

/*
Find the total number of times each type of channel from the web_events was used.
Your final table should have two columns - the channel and the number of times
the channel was used.
*/

/*
Who was the primary contact associated with the earliest web_event?
*/

/*
What was the smallest order placed by each account in terms of total usd. Provide
only two columns - the account name and the total usd. Order from smallest dollar
amounts to largest.
*/

/*
Find the number of sales reps in each region. Your final table should have two
columns - the region and the number of sales_reps. Order from fewest reps to
most reps.
*/

/*
*/

/*
*/

/*
*/
