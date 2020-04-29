###WINDOW Functions
/*
create a running total of standard_amt_usd (in the orders table) over order time
with no date truncation. Your final table should have two columns: one with the
amount being added for each new row, and a second with the running total.
*/
SELECT standard_amt_usd,
      SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders;


/*
Now, modify your query from the previous quiz to include partitions. Still create
a running total of standard_amt_usd (in the orders table) over order time, but
this time, date truncate occurred_at by year and partition by that same
year-truncated occurred_at variable. Your final table should have three columns:
One with the amount being added for each row, one for the truncated date, and a
final column with the running total within each year.
*/
SELECT standard_amt_usd,
		DATE_TRUNC('year',occurred_at) as year,
    SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year',occurred_at)
                                ORDER BY occurred_at) AS running_total
FROM orders;

###ROW_NUMBER_&_RANK

/*
Select the id, account_id, and total variable from the orders table, then create
a column called total_rank that ranks this total amount of paper ordered
(from highest to lowest) for each account using a partition. Your final table
should have these four columns.
*/
SELECT id, account_id, total,
        RANK() OVER (PARTITION BY account_id ORDER BY total desc) AS total_rank
FROM orders;

###Aggregates_in_Window Functions
/* Comparison
*/
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders;

/*
Now remove ORDER BY DATE_TRUNC('month',occurred_at) in each line of the query
that contains it in the SQL Explorer below. Evaluate your new query, compare it
to the results in the SQL Explorer above, and answer the subsequent quiz questions.
*/
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders

/*
The ORDER BY clause is one of two clauses integral to window functions. The ORDER
and PARTITION define what is referred to as the “window”—the ordered subset of
data over which calculations are made. Removing ORDER BY just leaves an unordered
partition; in our query's case, each column's value is simply an aggregation
(e.g., sum, count, average, minimum, or maximum) of all the standard_qty values
in its respective account_id.

As Stack Overflow user mathguy explains:

The easiest way to think about this - leaving the ORDER BY out is equivalent to
"ordering" in a way that all rows in the partition are "equal" to each other.
Indeed, you can get the same effect by explicitly adding the ORDER BY clause
like this: ORDER BY 0 (or "order by" any constant expression), or even, more
emphatically, ORDER BY NULL.
*/

###Aliases for Multiple Window Functions
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders


SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

###Comparing a Row to Previous Row

/*
*/

/*
*/

/*
*/
