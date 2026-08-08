select item_purchased ,
ROUND(100 * SUM(CASE WHEN discount_applied ='Yes' THEN 1 ELSE 0 END )/COUNT(*),2) as discount_rate 
from customer 
group by item_purchased
order by discount_rate desc 
limit 5 ;
-- segment customer into new  ,returning and loyal based on their total number of previous purchase and show the count of each segment 
with customer_type  as (
select customer_id ,previous_purchases,
CASE 
    WHEN previous_purchases = 1 Then 'New'
    WHEN previous_purchases  BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END as customer_segment 
from customer
)
select customer_segment ,count(*) as "Number of Customer"
from customer_type 
group by customer_segment ;
-- WHAT ARE THE top three most purchaseed product within each customer 
WITH item_counts AS (
    SELECT
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)

SELECT
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3
ORDER BY category, item_rank;
-- are customer who are repeat buyers (more than 5 previous ) also likly to subscribe ?
select subscription_status,
count(customer_id) as repeat_buyers
from customer 
where previous_purchases > 5
group by subscription_status
--what is the revenue contribution by each age group
select age_group, 
SUM("purchase_amount_(usd)") as total_revenue 
from customer 
group by age_group
order by total_revenue desc ;