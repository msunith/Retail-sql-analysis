# SQL Portfolio Project: Retail Sales Performance

## Business scenario
The commercial team wants to understand sales, profitability, customer behaviour, product performance, and sales-channel performance for January–April 2026.

## Files and tables
- `customers.csv` / `customers`: customer location and region
- `products.csv` / `products`: product category, list price, and unit cost
- `orders.csv` / `orders`: one row per order, date, customer, channel, order-level discount
- `order_items.csv` / `order_items`: one row per product in an order, quantity, unit price, discount, and line sales

The setup script creates all four tables and inserts the data. It is written for SQLite.

## Important definitions
- **Revenue / sales:** `SUM(order_items.line_sales)`. This field already includes the discount.
- **Units sold:** `SUM(order_items.quantity)`.
- **Estimated gross profit:** `SUM(quantity * (unit_price - unit_cost) * (1 - discount_rate))`.
- **Order count:** `COUNT(DISTINCT orders.order_id)` when joining to order items, to avoid counting an order once per item.
- **Average order value (AOV):** total revenue divided by distinct orders.
- **Discount rate:** stored as a decimal: 0.10 means 10%.

## Your deliverables
1. Create the tables and verify row counts.
2. Write and save SQL queries answering the business questions.
3. Summarise 5–8 findings in plain English, with numbers supporting each claim.
4. Recommend 3 practical actions to the commercial team.
5. Add the SQL and a short README to your GitHub portfolio. Do not upload personal information.

## Suggested workflow
1. Start with simple SELECTs and check the data.
2. Aggregate at the correct level before joining tables.
3. Validate joins and avoid double-counting orders.
4. Use CTEs for multi-step analysis.
5. Use window functions for rankings and month-over-month comparisons.
6. Write business recommendations only after checking the numbers.

## Starter query
```sql
SELECT
    strftime('%Y-%m', o.order_date) AS sales_month,
    ROUND(SUM(oi.line_sales), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY sales_month;
```
