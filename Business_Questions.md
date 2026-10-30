# SQL Business Questions 

## Part A — Core business analysis (1–10)
1. What are the total revenue, total units sold, and number of distinct orders?
2. What is the monthly revenue trend from January through April 2026?
3. Which 5 products generated the most revenue?
4. Which 5 products generated the most estimated gross profit?
5. What are revenue, distinct order count, and average order value by sales channel?
6. Which product categories generated the most revenue and gross profit?
7. What are the top 5 customers by lifetime revenue?
8. Which regions generated the most revenue? Include regions with customers who placed no orders.
9. What percentage of total revenue came from each channel?
10. What is the overall estimated gross margin percentage? Define your denominator clearly.

## Part B — Intermediate SQL (11–20)
11. Find products that have never been ordered. Keep them in the result.
12. Find customers who placed at least 5 distinct orders, with order count and revenue.
13. For each month, return revenue, order count, and average order value.
14. Show each category's share of total revenue as a percentage.
15. Compare Online, Store, and Marketplace performance by revenue and estimated gross profit.
16. Find the average discount rate by channel. Explain whether averaging order-level discounts or item-level discounts answers your intended question.
17. Find customers whose revenue is above the average customer revenue. Include customers with zero orders in the average.
18. Identify products whose total revenue is above the average product-level revenue.
19. Return the first order date and most recent order date for every customer, including customers with no orders.
20. Use a CASE expression to segment customers into High Value (revenue >= 500), Medium Value (>= 200 and < 500), and Low Value (< 200). Treat no-order customers as zero revenue.

## Part C — Advanced / interview-style (21–30)
21. Rank products by revenue within each category using `RANK()` or `DENSE_RANK()`.
22. Calculate a running revenue total by order date. If multiple orders occur on one date, decide whether you want a row-by-row or date-level running total.
23. Calculate month-over-month revenue change and percentage change. Make sure months are sorted by year-month, not month name.
24. Find each customer's first order and the revenue from that first order.
25. Find each customer's share of total revenue and rank customers by that share.
26. Use a CTE to calculate product revenue first, then return products above the average product revenue.
27. Compare revenue from discounted line items with revenue from non-discounted line items.
28. Find the best-selling product by quantity in each category. Explain how you handle ties.
29. Identify the top sales channel by estimated gross profit and quantify the gap between first and second place.
30. Create a one-row executive summary containing total revenue, gross profit, gross margin %, distinct orders, units sold, and average order value.

## SQL Skills Demonstrated

- SELECT, WHERE and ORDER BY
- INNER JOIN and LEFT JOIN
- GROUP BY and HAVING
- Aggregate functions
- Common Table Expressions (CTEs)
- Subqueries
- CASE statements
- Window functions
- RANK and DENSE_RANK
- Revenue and gross profit analysis
- Customer segmentation
