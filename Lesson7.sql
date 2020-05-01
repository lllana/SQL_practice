###FULL_OUTER_JOIN


SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;

/*
If you wanted to return unmatched rows only, which is useful for some cases of
data assessment, you can isolate them by adding the following line to the end of
the query:
*/
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL

/*
Say you're an analyst at Parch & Posey and you want to see:
- each account who has a sales rep and each sales rep that has an account
(all of the columns in these returned rows will be full)
*/
SELECT a.id, s.name
FROM accounts a
FULL OUTER JOIN sales_reps s
            ON s.id=a.sales_rep_id
WHERE s.name IS NOT NULL OR a.id IS NOT NULL;

/*
- but also each account that does not have a sales rep and each sales rep that
does not have an account (some of the columns in these returned rows will be empty)
*/
SELECT a.id, s.name
FROM accounts a
FULL OUTER JOIN sales_reps s
            ON s.id=a.sales_rep_id
WHERE s.name IS NULL OR a.id IS NULL;

SELECT *
  FROM accounts
 FULL JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
 WHERE accounts.sales_rep_id IS NULL OR sales_reps.id IS NULL


 ###Inequality JOINs (a.k.a. comparison operators)

/*
write a query that left joins the accounts table and the sales_reps tables on
each sale rep's ID number and joins it using the < comparison operator
on accounts.primary_poc and sales_reps.name, like so:
accounts.primary_poc < sales_reps.name
The query results should be a table with three columns: the account name
(e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski),
and the sales representative's name (e.g. Samuel Racine). Then answer the s
ubsequent multiple choice question.
*/
SELECT a.name account_name, a.primary_poc, s.name sales_name
FROM accounts a
LEFT JOIN sales_reps s
  ON s.id = a.sales_rep_id
  AND a.primary_poc < s.name;


###SELF_JOINTs


SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
  FROM orders o1
 LEFT JOIN orders o2
   ON o1.account_id = o2.account_id
  AND o2.occurred_at > o1.occurred_at
  AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at

/*
Modify the query from the previous video, which is pre-populated in
the SQL Explorer below, to perform the same interval analysis except for
the web_events table. Also:
- change the interval to 1 day to find those web events that occurred after,
but not more than 1 day after, another web event
- add a column for the channel variable in both instances of the table in your query
You can find more on the types of INTERVALS (and other date related functionality)
 in the Postgres documentation here.
*/
SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2.channel
  FROM web_events w1
 LEFT JOIN web_events w2
   ON w1.account_id = w2.account_id
  AND w2.occurred_at > w1.occurred_at
  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id,  w1.occurred_at

###UNIONs
/*
Write a query that uses UNION ALL on two instances (and selecting all columns)
of the accounts table. Then inspect the results and answer the subsequent quiz.
*/

SELECT *
    FROM accounts

UNION ALL

SELECT *
  FROM accounts

/*
Add a WHERE clause to each of the tables that you unioned in the query above,
filtering the first table where name equals Walmart and filtering the second
table where name equals Disney. Inspect the results then answer the subsequent
quiz.
*/

SELECT *
FROM accounts
WHERE name = 'Walmart'

UNION

SELECT *
FROM accounts
WHERE name = 'Disney'

/*
OR
*/

SELECT *
FROM accounts
WHERE name = 'Walmart' OR name = 'Disney'

UNION

SELECT *
FROM accounts
WHERE name = 'Walmart' OR name = 'Disney'

/*
Perform the union in your first query (under the Appending Data via UNION header)
in a common table expression and name it double_accounts. Then do a COUNT the
number of times a name appears in the double_accounts table. If you do this
correctly, your query results should have a count of 2 for each name.
*/
WITH double_accounts AS (
SELECT *
    FROM accounts
UNION ALL
SELECT *
  FROM accounts)

SELECT Name,
        COUNT(name) AS count_names
FROM double_accounts
GROUP BY 1

/*
More practice
https://www.hackerrank.com/domains/sql
https://mode.com/sql-tutorial/sql-business-analytics-training/
https://www.analyticsvidhya.com/blog/2017/01/46-questions-on-sql-to-test-a-data-science-professional-skilltest-solution/
*/
