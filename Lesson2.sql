###Inner_JOIN
/*
Try pulling all the data from the accounts table, and all the data from the
orders table.
*/
SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

/*
ry pulling standard_qty, gloss_qty, and poster_qty from the orders table, and
the website and the primary_poc from the accounts table
*/
SELECT 	orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website,
        accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;


###Alias
/*
Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc, time of the
event, and the channel for each event. Additionally, you might choose to add a
fourth column to assure only Walmart events were chosen.
*/
SELECT 	A.primary_poc, A.name, W.occurred_at, W.channel
FROM web_events W
JOIN accounts A
ON W.account_id = A.id
WHERE A.name = 'Walmart';

/*
Provide a table that provides the region for each sales_rep along with their
associated accounts. Your final table should include three columns: the region
name, the sales rep name, and the account name. Sort the accounts alphabetically
(A-Z) according to account name.
*/
SELECT R.name Region, S.name Rep, A.name Account
FROM region R
JOIN sales_reps S
ON R.id = S.region_id
JOIN accounts A
ON S.id = A.sales_rep_id
ORDER BY A.name

###LEFT_RIGHT_JOINs
/*
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. Your final
table should have 3 columns: region name, account name, and unit price. A few
accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing
by zero.
*/
SELECT 	R.name Region, A.name Account, O.total_amt_usd/(O.total + 0.01) Unit_price
FROM region R
JOIN sales_reps S
ON R.id = S.region_id
JOIN accounts A
ON S.id = A.sales_rep_id
JOIN orders O
ON A.id = O.account_id

/*
Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for the Midwest region. Your final table
should include three columns: the region name, the sales rep name, and the
account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT 	R.name AS region, S.name AS rep , A.name AS account
FROM sales_reps S
JOIN region R
ON R.id = S.region_id
JOIN accounts A
ON A.sales_rep_id = S.id
WHERE R.name = 'Midwest'
ORDER BY A.name

/*
Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for accounts where the sales rep has a first
name starting with S and in the Midwest region. Your final table should include
three columns: the region name, the sales rep name, and the account name. Sort
the accounts alphabetically (A-Z) according to account name.
*/
SELECT R.name region, S.name rep, A.name account
FROM sales_reps S
JOIN region R
ON S.region_id = R.id
JOIN accounts A
ON A.sales_rep_id = S.id
WHERE S.name LIKE 'S%'
AND R.name = 'Midwest'
ORDER BY A.name;

/*
Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for accounts where the sales rep has a
last name starting with K and in the Midwest region. Your final table should
include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT R.name region, S.name rep, A.name account
FROM sales_reps S
JOIN region R
ON S.region_id = R.id
JOIN accounts A
ON A.sales_rep_id = S.id
WHERE S.name LIKE '% K%'
AND R.name = 'Midwest'
ORDER BY A.name;

/*
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. However, you
should only provide the results if the standard order quantity exceeds 100. Your
final table should have 3 columns: region name, account name, and unit price. In
order to avoid a division by zero error, adding .01 to the denominator here is
helpful total_amt_usd/(total+0.01).
*/
SELECT 	R.name region, A.name account, O.total_amt_usd/(total + 0.01) unit_price
FROM sales_reps S
JOIN region R
ON S.region_id = R.id
JOIN accounts A
ON A.sales_rep_id = S.id
JOIN orders O
ON O.account_id = A.id
WHERE O.standard_qty > 100


/*
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. However, you
should only provide the results if the standard order quantity exceeds 100 and
the poster order quantity exceeds 50. Your final table should have 3 columns:
region name, account name, and unit price. Sort for the smallest unit price first.
In order to avoid a division by zero error, adding .01 to the denominator here
is helpful (total_amt_usd/(total+0.01).
*/
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;

/*
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. However, you
should only provide the results if the standard order quantity exceeds 100 and
the poster order quantity exceeds 50. Your final table should have 3 columns:
region name, account name, and unit price. Sort for the largest unit price first.
In order to avoid a division by zero error, adding .01 to the denominator here
is helpful (total_amt_usd/(total+0.01).
*/
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

/*
What are the different channels used by account id 1001? Your final table should
have only 2 columns: account name and the different channels. You can try
SELECT DISTINCT to narrow down the results to only the unique values.
*/
SELECT A.name account, W.channel
FROM accounts A
JOIN web_events W
ON W.account_id = A.id
Where A.id = '1001'

/*
Find all the orders that occurred in 2015. Your final table should have
4 columns: occurred_at, account name, order total, and order total_amt_usd.
*/
SELECT 	O.occurred_at, A.name, O.total, O.total_amt_usd
FROM orders O
JOIN accounts A
ON A.id = o.account_id
WHERE O.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY O.occurred_at DESC;
