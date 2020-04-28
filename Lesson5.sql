###Data Cleaning
/*
In the accounts table, there is a column holding the website for each company.
The last three digits specify what type of web address they are using. A list of
extensions (and pricing) is provided here. Pull these extensions and provide how
many of each website type exist in the accounts table.
*/
SELECT
	 RIGHT(website, 3) web_extension,
    COUNT(RIGHT (website,3)) count_web_ext
FROM accounts
GROUP BY 1
ORDER BY 2 desc;

/*
There is much debate about how much the name (or even the first letter of a
company name) matters. Use the accounts table to pull the first letter of each
company name to see the distribution of company names that begin with each letter
 (or number).
*/

SELECT
	   LEFT(UPPER(name),1) first_letter,
     COUNT(LEFT(UPPER(name),1)) count_letter
FROM accounts
GROUP BY 1
ORDER BY 2 desc;

/*
Use the accounts table and a CASE statement to create two groups: one group of
company names that start with a number and a second group of those company names
that start with a letter. What proportion of company names start with a letter?
*/
SELECT SUM (t1.numbers) Count_numbers_name,
        SUM (t1.letters) Count_lettrs_name
FROM (
    SELECT name,
          CASE WHEN LEFT(UPPER(name),1) IN ('0','1','2','3','4','5','6','7','8','9')
              THEN 1 ELSE 0 END AS numbers,
          CASE WHEN LEFT(UPPER(name),1) IN ('0','1','2','3','4','5','6','7','8','9')
              THEN 0 ELSE 1 END AS letters
    FROM accounts)t1

/*
Consider vowels as a, e, i, o, and u. What proportion of company names start
with a vowel, and what percent start with anything else?
*/
SELECT SUM (t1.vowels) Count_vowel_name,
        SUM (t1.consonants) Count_cons_name
FROM (
  SELECT name,
        CASE WHEN LEFT(UPPER(name),1) IN ('A', 'E', 'I', 'O', 'U')
            THEN 1 ELSE 0 END AS consonants,
        CASE WHEN LEFT(UPPER(name),1) IN ('A', 'E', 'I', 'O', 'U')
            THEN 0 ELSE 1 END AS vowels
  FROM accounts)t1

###POSITION, STRPOS, & SUBSTR
/*
Use the accounts table to create first and last name columns that hold the first
and last names for the primary_poc.
*/
SELECT
    LEFT(primary_poc,STRPOS(primary_poc,' ')) AS name_pr_poc,
    RIGHT(primary_poc, LENGTH(primary_poc)- STRPOS(primary_poc,' ')) AS surname_pr_poc
FROM accounts;

/*
Now see if you can do the same thing for every rep name in the sales_reps table.
Again provide first and last name columns.
*/
SELECT
    LEFT(name, STRPOS(name,' ')) AS name,
    RIGHT (name, LENGTH(name)-STRPOS(name,' ')) AS surname
FROM sales_reps;

###CONCAT
/*
ach company in the accounts table wants to create an email address for each
primary_poc. The email address should be
the first name of the primary_poc . last name primary_poc @ company name .com.
*/
SELECT
CONCAT (LEFT(primary_poc, STRPOS(primary_poc, ' ')-1),'.',
RIGHT(primary_poc, LENGTH(primary_poc)-STRPOS(primary_poc,' ' )), '@',name,'.com')
FROM accounts;

WITH t1 AS (
   SELECT LEFT(primary_poc,STRPOS(primary_poc, ' ') -1 ) first_name,
          RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name,
          name
   FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;

/*
You may have noticed that in the previous solution some of the company names
include spaces, which will certainly not work in an email address. See if you
can create an email address that will work by removing all of the spaces in the
account name, but otherwise your solution should be just as in question 1. Some
helpful documentation is here.
*/
SELECT
CONCAT (LEFT(primary_poc, STRPOS(primary_poc, ' ')-1),'.',
RIGHT(primary_poc, LENGTH(primary_poc)-STRPOS(primary_poc,' ' )), '@',REPLACE(name, ' ', ''),'.com')
FROM accounts;


WITH t1 AS (
   SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,
          RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
   FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;

/*
We would also like to create an initial password, which they will change after
their first log in. The first password will be the first letter of
the primary_poc's first name (lowercase), then the last letter of their first
name (lowercase), the first letter of their last name (lowercase), the last
letter of their last name (lowercase), the number of letters in their first name,
the number of letters in their last name, and then the name of the company they
are working with, all capitalized with no spaces.
*/

WITH t1 AS (
    SELECT name,
    LEFT(lower(primary_poc),STRPOS(primary_poc,' ')-1) AS pr_poc_name,
    RIGHT(lower(primary_poc), LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS surname
    FROM accounts)
SELECT
CONCAT(LEFT(t1.pr_poc_name,1),
      RIGHT(t1.surname,1),
      LEFT(t1.surname,1),
      RIGHT(t1.pr_poc_name,1),
      LENGTH(t1.pr_poc_name),
      LENGTH(t1.surname),
      REPLACE(UPPER(name),' ',''))
FROM t1;

###CAST

SELECT
  DATE as origine_date,
  (SUBSTR(date,7,4)||'-'||LEFT(date,2)||'-'||SUBSTR(date,4,2))::DATE new_date
FROM sf_crime_data

/*
*/

/*
*/

/*
*/
