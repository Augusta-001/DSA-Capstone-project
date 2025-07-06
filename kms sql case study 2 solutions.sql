CREATE TABLE kms_data (
    row_id INT,
    order_id INT,
    order_date DATE,
    order_priority VARCHAR(50),
    order_quantity INT,
    sales DECIMAL(10, 2),
    discount DECIMAL(5, 2),
    ship_mode VARCHAR(50),
    profit DECIMAL(10, 2),
    unit_price DECIMAL(10, 2),
    shipping_cost DECIMAL(10, 2),
    customer_name VARCHAR(255),
    province VARCHAR(100),
    region VARCHAR(100),
    customer_segment VARCHAR(100),
    product_category VARCHAR(100),
    product_subcategory VARCHAR(100),
    product_name TEXT,
    product_container VARCHAR(100),
    product_base_margin DECIMAL(5, 2),
    ship_date DATE
);

-----Select *
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]


-------------1
  SELECT 
    product_category,
    SUM(TRY_CAST(sales AS FLOAT)) AS total_sales
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
GROUP BY product_category
ORDER BY total_sales DESC;

--------------2
SELECT TOP 3 
    region,
    SUM(TRY_CAST(sales AS FLOAT)) AS total_sales
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
GROUP BY region
ORDER BY total_sales DESC;

  Bottom 3
SELECT TOP 3 
    region,
    SUM(TRY_CAST(sales AS FLOAT)) AS total_sales
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
GROUP BY region
ORDER BY total_sales ASC;


---------------3
SELECT 
    SUM(TRY_CAST(sales AS FLOAT)) AS total_appliances_sales
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
WHERE product_subcategory = 'Appliances'
  AND province = 'Ontario';


----------------4
SELECT TOP 10 
    customer_name,
    SUM(TRY_CAST(sales AS FLOAT)) AS total_sales
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
GROUP BY customer_name
ORDER BY total_sales ASC;


----------------5
SELECT 
    ship_mode,
    SUM(TRY_CAST(shipping_cost AS FLOAT)) AS total_shipping_cost
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
GROUP BY ship_mode
ORDER BY total_shipping_cost DESC;

---------------6
SELECT 
    customer_name,
    SUM(TRY_CAST(sales AS FLOAT)) AS total_sales,
    STUFF((
        SELECT DISTINCT ', ' + product_subcategory
        FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study] AS inner_tbl
        WHERE inner_tbl.customer_name = outer_tbl.customer_name
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS products_purchased
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study] AS outer_tbl
GROUP BY customer_name
ORDER BY total_sales DESC;


---------------7
SELECT TOP 1 
    customer_name,
    SUM(TRY_CAST(sales AS FLOAT)) AS total_sales
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
WHERE customer_segment = 'Small Business'
GROUP BY customer_name
ORDER BY total_sales DESC;

--------------8
SELECT TOP 1 
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
WHERE customer_segment = 'Corporate'
  AND YEAR(order_date) BETWEEN 2009 AND 2012
GROUP BY customer_name
ORDER BY total_orders DESC;


---------------9
SELECT TOP 1 
    customer_name,
    SUM(TRY_CAST(profit AS FLOAT)) AS total_profit
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
WHERE customer_segment = 'Consumer'
GROUP BY customer_name
ORDER BY total_profit DESC;

----------------10
SELECT DISTINCT 
    customer_name,
    customer_segment
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
WHERE return_status = 'Returned';


----------------11
SELECT 
    order_priority,
    ship_mode,
    COUNT(*) AS total_orders,
    SUM(TRY_CAST(shipping_cost AS FLOAT)) AS total_shipping_cost,
    AVG(TRY_CAST(shipping_cost AS FLOAT)) AS avg_shipping_cost
FROM [DSA].[dbo].[cleaned KMS_SQL_Case_Study]
GROUP BY order_priority, ship_mode
ORDER BY order_priority, total_shipping_cost DESC;

