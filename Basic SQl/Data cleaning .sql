"Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
"
'Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.'

WITH T1 as 
(

SELECT 
   LEFT(primary_poc, POSITION(' ' in primary_poc) - 1 ) as first_name,
   primary_poc as primary_poc 

FROM accounts 
)

SELECT T1.first_name,
       RIGHT(primary_poc,LENGTH(PRIMARY_POC) -LENGTH(T1.first_name)-1  ) as last_name
      
FROM T1


WITH T1 as 
(

SELECT 
   LEFT(name , POSITION(' ' in name ) - 1 ) as first_name,
   name  as primary_poc 

FROM sales_reps
)

SELECT T1.first_name,
       RIGHT(primary_poc,LENGTH(PRIMARY_POC) -LENGTH(T1.first_name)-1  ) as last_name
      
FROM T1

'POSITION, STRPOS, & SUBSTR Solutions'
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name, 
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;

'Each company in the accounts table wants to create an email address for each primary_poc. 
The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.'

WITH T1 AS
    (SELECT 
        LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) AS  first_name, 
        RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS last_name,
        name as company_name
    FROM accounts
    )


 SELECT CONCAT(first_name,'.',last_name,'@',REPLACE(company_name,' ',''),'.com') as email_address
 FROM T1   

'We would also like to create an initial password, which they will change after their first log in. 
The first password will be the first letter of the primary_poc's 
'first name (lowercase), then the last letter of their first name (lowercase), 
the first letter of their last name (lowercase), the last letter of their last name (lowercase), 
the number of letters in their first name, the number of letters in their last name, 
and then the name of the company they are working with, all capitalized with no spaces.'

WITH T1 AS 
    (
        SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
        RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name,
        NAME as company_name 
        FROM accounts
    ),

    T2 AS 
    (
        SELECT LOWER(LEFT(first_name,1)) as FLFN,
        LOWER(RIGHT(first_name,1)) as LLFN,
        LOWER(LEFT(last_name,1)) as FLLN,
        LOWER(RIGHT(last_name,1)) as LLLN,
        LENGTH(first_Name) AS NLFN,
        LENGTH(last_name) AS NLLN,
        UPPER(REPLACE(company_name,' ','')) AS CN 
        FROM T1
    )



SELECT CONCAT(FLFN,LLFN,FLLN,LLLN,NLFN,NLLN,CN ) AS password
FROM T2


'SOLUTION'
WITH t1 AS 
    (
        SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  
        RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, 
        name
        FROM accounts
    )

SELECT first_name, last_name, 
CONCAT(first_name, '.', last_name, '@', name, '.com'), 
LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;
'Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. 
Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased, 
and one of four levels in a standard_quartile column.

'

SELECT account_id,occurred_at, standard_qty, 
       SUM(standard_qty) OVER(PARTITION BY account_id) as total,
        NTILE(4) OVER (PARTITION BY standard_qty) as standard_quartile

FROM orders
ORDER BY 1
      
'Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. 
Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased, 
and one of two levels in a gloss_half column.'

SELECT account_id, occurred_at, gloss_qty,
      NTILE(2) OVER (PARTITION BY gloss_qty) as gloss_quartile

FROM orders