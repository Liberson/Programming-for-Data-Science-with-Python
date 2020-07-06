#Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

WITH 
   T1 as 
      (  SELECT region_name region_name , MAX(total_sales) total_sales
              FROM
             (
                SELECT sales_reps.name sales_name, region.name region_name, 
                      SUM(orders.total_amt_usd) total_sales
                    FROM sales_reps
               JOIN region
              ON sales_reps.region_id = region.id
             JOIN accounts
            ON accounts.sales_rep_id = sales_reps.id
            JOIN orders
            ON accounts.id = orders.account_id
            GROUP BY 1,2
            ORDER BY 3
                ) T1
                GROUP BY 1


                    ),

        T2 as
        (SELECT sales_reps.name sales_name, region.name region_name, 
       SUM(orders.total_amt_usd) total_sales
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1,2
ORDER BY 3



        )




SELECT T1.region_name, T1.total_sales, T2.sales_name
FROM T1 
JOIN T2
ON T1.region_name = T2.region_name AND T1.total_sales = T2.total_sales 


#For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

SELECT T1.number_orders, T1.region_name

FROM(
SELECT COUNT(*) number_orders, region.name as region_name
FROM orders
JOIN accounts
ON accounts.id = orders.account_id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
JOIN region
ON sales_reps.region_id = region.id
GROUP BY 2
) T1

JOIN 
(
SELECT region_name as region_name, SUM(total_sales) as total_sales
FROM
(
SELECT sales_reps.name sales_name, region.name region_name, 
       SUM(orders.total_amt_usd) total_sales
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1,2
ORDER BY 3
) T1
GROUP By 1
ORDER By 2 DESC 
LIMIT 1
) T2 
on T1.region_name = T2.region_name

#How many accounts had more total purchases than the account name which has bought the most standard_qty paper 
#throughout their lifetime as a customer?

SELECT T1.account_name 
FROM
(
SELECT accounts.name account_name , SUM(orders.total ) total
FROM accounts
JOIN orders
ON accounts.id = orders.account_id 
GROUP BY 1
) T1 

JOIN
(
SELECT  accounts.name account_name , SUM(orders.total ) total
FROM accounts
JOIN orders
ON accounts.id = orders.account_id 
JOIN
(
Select accounts.name account_name , SUM(orders.standard_qty) total_standard
FROM accounts
JOIN orders
ON accounts.id = orders.account_id 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
) T1
ON accounts.name = T1.account_name
GROUP BY 1
) T2

ON T1.total > T2.total

#For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
# how many web_events did they have for each channel?


SELECT COUNT(*) count_event, web_events.channel channel,accounts.id
FROM web_events
JOIN accounts
ON accounts.id = web_events.account_id
GROUP BY 2,3
HAVING accounts.id =
( SELECT account_id
FROM(
SELECT accounts.id account_id, SUM(orders.total_amt_usd) total
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
) sub
)
ORDER BY 1


#What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

SELECT AVG(T1.total ) Average 
FROM 
(
SELECT accounts.id accounts_id, SUM(orders.total_amt_usd) total 
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
) T1

#What is the lifetime average amount spent in terms of total_amt_usd, 
#including only the companies that spent more per order, on average, than the average of all orders.

SELECT AVG(Average)
FROM
(

   SELECT accounts.name, AVG(orders.total_amt_usd) as Average
   FROM accounts
   JOIN orders
    ON accounts.id = orders.account_id
   GROUP BY 1
   HAVING AVG(orders.total_amt_usd)> 
          ( SELECT AVG(total_amt_usd) Average
            FROM orders 
             )
              )T1