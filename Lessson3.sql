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
*/
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
