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

/*
*/

/*
*/
