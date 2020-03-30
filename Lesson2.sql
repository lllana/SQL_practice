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
SELECT 	orders.standard_qty,
		    orders.gloss_qty,
        orders.poster_qty,
        accounts.website,
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
SELECT 	A.primary_poc,
		    A.name,
        W.occurred_at,
        W.channel
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

/*
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. Your final
table should have 3 columns: region name, account name, and unit price. A few
accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing
by zero.
*/
SELECT 	R.name Region,
		    A.name Account,
        O.total_amt_usd/(O.total + 0.01) Unit_price
FROM region R
JOIN sales_reps S
ON R.id = S.region_id
JOIN accounts A
ON S.id = A.sales_rep_id
JOIN orders O
ON A.id = O.account_id
