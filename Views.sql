-- 1. avg_spend_per_user: Average total amount spent by each user

CREATE VIEW avg_spend_per_user AS
SELECT User_id, AVG(Total_amt) AS avg_spend
FROM ORDERS
GROUP BY User_id;

-- 2. active_multiple_orders_users: Users with more than 1 active order (status not Delivered)

CREATE VIEW active_multiple_orders_users AS
SELECT User_id, COUNT(Order_id) AS active_orders_count
FROM ORDERS
WHERE Status NOT IN ('Delivered')
GROUP BY User_id
HAVING COUNT(Order_id) > 1;

-- 3. category_revenue_report: Revenue grouped by product category

CREATE  VIEW category_revenue_report AS
SELECT p.Category, SUM(oi.Quantity * oi.Price) AS total_revenue
FROM ORDER_ITEMS oi
JOIN PRODUCTS p ON oi.Prod_id = p.Prod_id
GROUP BY p.Category;

-- 4. customer_favourite_product: Most ordered product per user without subquery

CREATE VIEW customer_favourite_product AS
SELECT o.User_id, oi.Prod_id, COUNT(*) AS order_count
FROM ORDERS o
JOIN ORDER_ITEMS oi ON o.Order_id = oi.Order_id
GROUP BY o.User_id, oi.Prod_id;

-- 5. daily_sales_rpt: Daily total sales amount

CREATE VIEW daily_sales_rpt AS
SELECT DATE(Order_date) AS order_day, SUM(Total_amt) AS daily_sales
FROM ORDERS
GROUP BY order_day;

-- 6. delay_pay: Payments delayed beyond 2 days after order

CREATE VIEW delay_pay AS
SELECT p.Payment_id, p.Order_id, DATEDIFF(p.Date, o.Order_date) AS days_delay
FROM PAYMENTS p
JOIN ORDERS o ON p.Order_id = o.Order_id
WHERE DATEDIFF(p.Date, o.Order_date) > 2;

-- 7. failed_payments: Payments with status not Delivered or Completed

CREATE VIEW failed_payments AS
SELECT *
FROM PAYMENTS
WHERE Status NOT IN ('Delivered', 'Completed');

-- 8. food_orders_view: Orders containing products in 'Food' category

CREATE VIEW food_orders_view AS
SELECT DISTINCT o.Order_id, o.User_id, o.Order_date, o.Total_amt, o.Status
FROM ORDERS o
JOIN ORDER_ITEMS oi ON o.Order_id = oi.Order_id
JOIN PRODUCTS p ON oi.Prod_id = p.Prod_id
WHERE p.Category = 'Food';

-- 9. freq_order_prod: Products ordered more than 5 times

CREATE VIEW freq_order_prod AS
SELECT Prod_id, COUNT(DISTINCT Order_id) AS order_count
FROM ORDER_ITEMS
GROUP BY Prod_id
HAVING order_count > 5;

-- 10. frequent_buyers_view: Users with more than 3 orders

CREATE VIEW frequent_buyers_view AS
SELECT User_id, COUNT(Order_id) AS orders_count
FROM ORDERS
GROUP BY User_id
HAVING orders_count > 3;

-- 11. high_val_order: Orders with total amount above 50,000

CREATE VIEW high_val_order AS
SELECT *
FROM ORDERS
WHERE Total_amt > 50000;

-- 12. latest_product_sales: Latest sales per product (last order date)

CREATE VIEW latest_product_sales AS
SELECT p.Prod_id, p.Prod_name, MAX(o.Order_date) AS last_sold_date
FROM PRODUCTS p
LEFT JOIN ORDER_ITEMS oi ON p.Prod_id = oi.Prod_id
LEFT JOIN ORDERS o ON oi.Order_id = o.Order_id
GROUP BY p.Prod_id, p.Prod_name;

-- 13. low_stock_products_view: Products with quantity less than 3

CREATE VIEW low_stock_products_view AS
SELECT Prod_id, Prod_name, Quantity
FROM PRODUCTS
WHERE Quantity < 3;

-- 14. order_summary_per_user: Total orders and total amount per user

CREATE VIEW order_summary_per_user AS
SELECT User_id, COUNT(Order_id) AS total_orders, SUM(Total_amt) AS total_spent
FROM ORDERS
GROUP BY User_id;

-- 15. orders_without_payment: 
-- This requires LEFT JOIN and WHERE IS NULL:

CREATE VIEW orders_without_payment AS
SELECT o.Order_id, o.User_id, o.Total_amt, o.Order_date
FROM ORDERS o
LEFT JOIN PAYMENTS p ON o.Order_id = p.Order_id
WHERE p.Order_id IS NULL;

-- 16. out_of_stock_stimulation_view: Products with zero quantity

CREATE VIEW out_of_stock_stimulation_view AS
SELECT Prod_id, Prod_name
FROM PRODUCTS
WHERE Quantity = 0;

-- 17. pending_orders_view: All pending orders

CREATE VIEW pending_orders_view AS
SELECT *
FROM ORDERS
WHERE Status = 'Pending';

-- 18. pending_orders_view1: Duplicate view same as above

CREATE VIEW pending_orders_view1 AS
SELECT *
FROM ORDERS
WHERE Status = 'Pending';

-- 19. popular_products_view: Products ordered more than average number of orders — 

CREATE VIEW popular_products_view AS
SELECT p.Prod_id, p.Prod_name, COUNT(DISTINCT oi.Order_id) AS order_count
FROM ORDER_ITEMS oi
JOIN PRODUCTS p ON oi.Prod_id = p.Prod_id
GROUP BY p.Prod_id, p.Prod_name;

-- 20. prod_multiple: Products appearing in multiple orders

CREATE VIEW prod_multiple AS
SELECT Prod_id, COUNT(DISTINCT Order_id) AS order_count
FROM ORDER_ITEMS
GROUP BY Prod_id
HAVING order_count > 1;

-- 21. product_never_ordered: 
-- We can do LEFT JOIN with NULL check instead:

CREATE VIEW product_never_ordered AS
SELECT p.Prod_id, p.Prod_name
FROM PRODUCTS p
LEFT JOIN ORDER_ITEMS oi ON p.Prod_id = oi.Prod_id
WHERE oi.Prod_id IS NULL;

-- 22. prod_rev_report: Product revenue report (sum price*quantity)

CREATE VIEW prod_rev_report AS
SELECT p.Prod_id, p.Prod_name, SUM(oi.Price * oi.Quantity) AS revenue
FROM ORDER_ITEMS oi
JOIN PRODUCTS p ON oi.Prod_id = p.Prod_id
GROUP BY p.Prod_id, p.Prod_name;

-- 23. product_sales_report: Sales quantity per product

CREATE VIEW product_sales_report AS
SELECT p.Prod_id, p.Prod_name, SUM(oi.Quantity) AS total_quantity_sold
FROM ORDER_ITEMS oi
JOIN PRODUCTS p ON oi.Prod_id = p.Prod_id
GROUP BY p.Prod_id, p.Prod_name;

-- 24. top_by_sale: Top products by total sales amount

CREATE VIEW top_by_sale AS
SELECT p.Prod_id, p.Prod_name, SUM(oi.Price * oi.Quantity) AS total_sales
FROM ORDER_ITEMS oi
JOIN PRODUCTS p ON oi.Prod_id = p.Prod_id
GROUP BY p.Prod_id, p.Prod_name
ORDER BY total_sales DESC
LIMIT 10;

-- 25. top_customers: Users who spent the most
CREATE VIEW top_customers AS
SELECT User_id, SUM(Total_amt) AS total_spent
FROM ORDERS
GROUP BY User_id
ORDER BY total_spent DESC
LIMIT 10;

-- 26. user_last_ordered: Last order date per user

CREATE VIEW user_last_ordered AS
SELECT User_id, MAX(Order_date) AS last_order_date
FROM ORDERS
GROUP BY User_id;

-- 27. user_order_details_view: Detailed orders per user with product info

CREATE VIEW user_order_details_view AS
SELECT o.User_id, o.Order_id, o.Order_date, p.Prod_id, p.Prod_name, oi.Quantity, oi.Price
FROM ORDERS o
JOIN ORDER_ITEMS oi ON o.Order_id = oi.Order_id
JOIN PRODUCTS p ON oi.Prod_id = p.Prod_id;

-- 28. user_order_status_summary: Count of orders by status per user

CREATE VIEW user_order_status_summary AS
SELECT User_id, Status, COUNT(Order_id) AS count_orders
FROM ORDERS
GROUP BY User_id, Status;

-- 29. user_product_summary: Total quantity ordered per product per user

CREATE VIEW user_product_summary AS
SELECT o.User_id, oi.Prod_id, SUM(oi.Quantity) AS total_quantity
FROM ORDERS o
JOIN ORDER_ITEMS oi ON o.Order_id = oi.Order_id
GROUP BY o.User_id, oi.Prod_id;

-- 30. users_with_multiple_payment_methods: Users who used multiple payment methods

CREATE VIEW users_with_multiple_payment_methods AS
SELECT o.User_id, COUNT(DISTINCT p.Payment_mode) AS payment_methods_count
FROM ORDERS o
JOIN PAYMENTS p ON o.Order_id = p.Order_id
GROUP BY o.User_id
HAVING payment_methods_count > 1;


