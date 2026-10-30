## Part A — Core business analysis (1–10)
-- 1.What are the total revenue, total units sold, 
-- and number of distinct orders?
select concat('$',round(sum(line_sales),2)) as revenue,
		sum(quantity) as total_units_sold,
        count(distinct order_id) as distinct_orders
from order_items;

-- 2.What is the monthly revenue trend from January through April 2026?
select date_format(order_date,'%Y-%m') order_month,
		monthname(order_date) as month_name,
        round(sum(line_sales),2) as revenue
	from orders o  left join order_items oi using (order_id)
    where o.order_date >=' 2026-01-01' and o.order_date < '2026-05-01'
    group by order_month,month_name
    order by order_month;

-- 3. Which 5 products generated the most revenue?
select product_id, product_name,
		round(coalesce(sum(line_sales),0),2) as revenue
	from products p left join order_items oi using (product_id)
    group by p.product_id, p.product_name
    order by revenue desc
    limit 5;
    
-- 4. Which 5 products generated the most estimated gross profit?
select p.product_id, product_name, 
	round(
		 coalesce(sum(line_sales),0) -coalesce(sum(quantity*unit_cost),0),
         2) as profit
from products p left join order_items oi using (product_id)
group by p.product_id, p.product_name
order by profit desc
limit 5;

-- 5. What are revenue, distinct order count, 
-- and average order value by sales channel?
select channel, 
	count(distinct order_id) as distinct_order_count,
    round(sum(oi.line_sales),2) as revenue,
	round(
		sum(line_sales)/count(distinct order_id)
        ,2) as avg_order_value
	from orders o left join order_items oi using (order_id)
    group by channel;

-- 6. Which product categories generated the most revenue and 
-- gross profit?
select category,
round(sum(line_sales),2) as revenue,
round(sum(line_sales -(quantity*unit_cost)),2) as profit
from products p left join order_items oi using (product_id)
group by category
order by profit desc;

-- 7. What are the top 5 customers by lifetime revenue?
select customer_id,customer_name,city,
	round(sum(line_sales),2) as revenue from customers c left join orders o using (customer_id)
    left join order_items oi using (order_id)
group by customer_id, customer_name, city
order by revenue desc
limit 5;

-- 8. Which regions generated the most revenue? 
-- Include regions with customers who placed no orders.
select region, round(coalesce(sum(line_sales),0),2) as revenue
	from customers c left join orders o using (customer_id)
    left join order_items oi using (order_id) 
    group by region
    order by revenue desc;
    
-- 9. What percentage of total revenue came from each channel?
select channel, 
round(sum(line_sales),2) as total_revenue,
	round(
	(sum(line_sales)/sum(sum(line_sales)) over())* 100,2) as percentage
	from orders o left join order_items oi using (order_id)
    group by channel;
    
-- 10. What is the overall estimated gross margin percentage? 
-- Define your denominator clearly.
select round(
		100*(sum(oi.line_sales)- sum(unit_cost * quantity))/nullif(sum(line_sales),0),2)
	as estimated_gross_margin
    from order_items oi 
    left join products p using (product_id);
    
## Part B — Intermediate SQL (11–20)
-- 11. Find products that have never been ordered. Keep them in the result.
select product_id, product_name, category
	from products 
    where product_id not in (select distinct product_id from order_items);

-- 12. Find customers who placed at least 5 distinct orders, 
-- with order count and revenue.
select customer_id, customer_name, count(distinct order_id) as order_count,
	round(coalesce(sum(line_sales),0),2) as revenue 
    from customers c left join orders o using (customer_id)
    left join order_items oi using (order_id)
    group by customer_id, customer_name
    having order_count >=5
    order by order_count desc;
-- 13. For each month, return revenue, order count, and average order value.
select date_format(order_date,'%Y-%m') as order_month,
		monthname(order_date) as month_name,
		round(coalesce(sum(line_sales),0),2) as revenue,
        count(distinct order_id) as order_count,
        round((sum(line_sales)/count(distinct order_id)),2) as average_order_value
	from orders o left join order_items oi using (order_id)
    group by order_month,month_name;

-- 14. Show each category's share of total revenue as a percentage.
select category, 
round(sum(line_sales),2) as total_revenue,
	round(
	(sum(line_sales)/sum(sum(line_sales)) over())* 100,2) as percentage
	from orders o left join order_items oi using (order_id)
    left join products p using (product_id)
    group by category;

-- 15. Compare Online, Store, and Marketplace performance by revenue 
-- and estimated gross profit.
select channel, 
		round(sum(line_sales),2) as revenue,
        round(sum(quantity*unit_cost),2) as total_cogs,
        round(sum(line_sales)-sum(quantity*unit_cost),2) as estimated_gross_profit
from orders o left join order_items oi using (order_id)
left join products p using (product_id)
group by channel;

-- 16. Find the average discount rate by channel. 
-- Explain whether averaging order-level discounts or 
-- item-level discounts answers your intended question.
select channel, 
		round(avg(o.discount_rate),4) as avg_discount_order_level,
        round(avg(oi.discount_rate),4) as avg_discount_item_level		
from orders o left join order_items oi using (order_id)
left join products p using (product_id)
group by channel;


-- 17. Find customers whose revenue is above the average customer revenue.
-- Include customers with zero orders in the average.
with customer_cte as
(select customer_id,customer_name,
		coalesce(sum(line_sales),0) as revenue 
        from customers c left join orders o using (customer_id)
        left join order_items oi using (order_id)
        group by c.customer_id)
select customer_id,customer_name,round(revenue,2) as revenue
 from customer_cte where revenue >
	( select avg(revenue) from customer_cte); 

-- 18. Identify products whose total revenue is above the average product-level revenue.
with product_cte as
(select product_id, product_name,
	coalesce(sum(line_sales),0) as revenue
    from products p left join order_items oi using (product_id)
    group by product_id)
select product_id, product_name, round(revenue,2) as revenue from product_cte 
where revenue >
(select avg(revenue) from product_cte)
order by revenue desc;

-- 19. Return the first order date and most recent order date 
-- for every customer, including customers with no orders.
select customer_id, customer_name,
	min(order_date) as first_order_date,
    max(order_date) as Recent_order_date
    from customers c left join orders o using (customer_id)
	group by customer_id;
    
-- 20. Use a CASE expression to segment customers into High Value
--  (revenue >= 500), Medium Value (>= 200 and < 500), 
-- and Low Value (< 200). Treat no-order customers as zero revenue.
select customer_id, customer_name,
	round(coalesce(sum(line_sales),0), 2) as revenue,
    case 
    when coalesce(sum(line_sales),0) >= 500 then 'High'
    when coalesce(sum(line_sales),0) >= 200 then 'Medium'
    else 'Low'
    End as customer_segment
	from customers c left join orders o using (customer_id)
    left join order_items oi using (order_id)
	group by customer_id;

## Part C — Advanced / interview-style (21–30)
-- 21. Rank products by revenue within each category 
-- using `RANK()` or `DENSE_RANK()`.
select product_id,product_name,category,
	round(coalesce(sum(line_sales),0),2) as revenue,
    rank() over(partition by category order by sum(line_sales) desc) as product_rank
    from products p left join order_items oi using (product_id)
    group by product_id;

-- 22. Calculate a running revenue total by order date. 
-- If multiple orders occur on one date, decide whether 
-- you want a row-by-row or date-level running total.
select order_date,
	revenue,
    round(sum(revenue) over (order by order_date),2) as running_total
    from 
    (select order_Date,round(coalesce(sum(line_sales),0),2) as revenue    
    from orders o left join order_items oi using (order_id)
    group by order_date
    order by order_date) as order_table;
    
-- 23. Calculate month-over-month revenue change and 
-- percentage change. Make sure months are sorted by year-month,
-- not month name.
with month_sale as 
(select date_format(order_date,'%Y-%m') as order_month,
    round(coalesce(sum(line_sales),0),2) as revenue    
    from orders o left join order_items oi using (order_id)
    group by date_format(order_date,'%Y-%m'))
select order_month, revenue,
	LAG(revenue) over (order by order_month) as prior_month_revenue,
    Round(100.0 * (revenue- LAG(revenue) over (order by order_month))
    / NULLIF(lag(revenue) over (order by order_month), 0), 2
    ) as mom_growth_pct
from month_sale
order by order_month;

-- 24. Find each customer's first order and the revenue from 
-- that first order.
with cte as 
(select customer_id,order_id,order_date
from 
(select customer_id,order_id, order_date,
	row_number() over
    (partition by customer_id order by order_date asc ) as rn
from customers c left join orders using (customer_id)
) as temp
where rn = 1)
select customer_id,order_id,order_date,
	sum(line_sales) as revenue from cte
    inner join order_items using (order_id)
    group by customer_id,order_id,order_date;

-- 25. Find each customer's share of total revenue and 
-- rank customers by that share.
with sale_cte as
(select customer_id, customer_name, 
	sum(line_sales) as revenue from
    customers c left join orders o using (customer_id)
    left join order_items oi using (order_id)
    group by customer_id)
select customer_id, customer_name, round(revenue,2),
	round(revenue/(select sum(line_sales) from order_items) *100,2) as customer_share,
    rank() over(order by revenue desc) as customer_rank
from sale_cte;

-- 26. Use a CTE to calculate product revenue first, 
-- then return products above the average product revenue.
with product_revenue as
(select product_id,product_name,
	sum(line_sales) as revenue
from products p left join order_items oi using (product_id)
group by product_id,product_name)
select product_id, product_name,round(revenue,2) as revenue
from product_revenue
where revenue >
(select avg(revenue) from product_revenue);
	
-- 27. Compare revenue from discounted line items with revenue 
-- from non-discounted line items.
select 
	sum(case when discount_rate != 0 then line_sales else 0 end) as revenue_without_discount,
	sum(case when discount_rate = 0 then line_sales else 0 end) as revenue_with_discount
    from order_items;

-- 28. Find the best-selling product by quantity in each category.
-- Explain how you handle ties.
with product_cte as
(select product_id,product_name,category,
	sum(quantity) as qty,
    rank() over(partition by category order by sum(quantity) desc) as rank_p
    from products p left join order_items oi using (product_id)
    group by product_id,product_name)
select product_id, product_name, category, qty from product_cte 
where rank_p = 1;

-- 29. Identify the top sales channel by estimated gross profit 
-- and quantify the gap between first and second place.
-- Calculate estimated gross profit for each sales channel.
-- Rank the channels by gross profit.
-- Find the difference between first and second place.
with sale_cte as
(select channel ,
	sum(oi.line_sales - (oi.quantity*p.unit_cost)) as gross_profit
    from orders o left join order_items oi using (order_id)
    left join products p using (product_id)
    group by channel),
rank_cte as
(select channel,round(gross_profit,2) as gross_profit,
	rank() over(order by gross_profit desc) as rank_channel
from sale_cte)
select 
	MAX(CASE WHEN rank_channel = 1 THEN channel END) AS top_channel,
	MAX(CASE WHEN rank_channel = 1 THEN gross_profit END) AS top_gross_profit,
    MAX(CASE WHEN rank_channel = 2 THEN gross_profit END) AS second_gross_profit,
	max(case when rank_channel =1 then gross_profit End) -
    max(case when rank_channel =2 then gross_profit End)
    as gross_profit_diff 
    from rank_cte;

-- 30. Create a one-row executive summary containing total revenue, 
-- gross profit, gross margin %, distinct orders, units sold,
--  and average order value.
select sum(line_sales) as total_revenue,
	sum(oi.line_sales-(oi.quantity*p.unit_cost)) as gross_profit,
    ROUND(
        100.0 * SUM(oi.line_sales - (oi.quantity * p.unit_cost))
        / NULLIF(SUM(oi.line_sales), 0),
        2
    ) AS gross_margin_pct,
    count(distinct order_id) as distinct_orders,
    sum(quantity) as units_sold,
    sum(line_sales)/count(distinct order_id) as avg_order_value
	from orders o left join order_items oi using (order_id)
    left join products p using (product_id);
