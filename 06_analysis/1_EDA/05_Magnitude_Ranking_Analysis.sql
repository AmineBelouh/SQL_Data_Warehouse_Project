/*
===============================================================================
V. MAGNITUDE AND RANKING ANALYSIS
===============================================================================
Purpose:
    Compare business measures across products, categories, subcategories, and
    customer segments. Rank the results from highest to lowest.
===============================================================================
*/


/*-----------------------------------------------------------------------------
V.1 COST ANALYSIS
-----------------------------------------------------------------------------*/


-- 1. Average cost by category
SELECT
    category,
    ROUND(AVG(cost), 2) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;

-- Result:
-- category    | average_cost
-- ------------+-------------
-- Bikes       | 949.44
-- Components  | 252.38
-- Clothing    | 24.80
-- Accessories | 13.17


-- 2. Average cost by subcategory
SELECT
    subcategory,
    ROUND(AVG(cost), 2) AS average_cost
FROM gold.dim_products
GROUP BY subcategory
ORDER BY average_cost DESC;

-- Result:
-- subcategory        | average_cost
-- -------------------+---------------
-- Road Bikes         | 993.70
-- Mountain Bikes     | 933.78
-- Touring Bikes      | 885.73
-- Road Frames        | 416.30
-- Touring Frames     | 378.67
-- Mountain Frames    | 365.00
-- Cranksets          | 124.00
-- Wheels             | 98.14
-- Forks              | 82.00
-- Bike Stands        | 59.00
-- Panniers           | 52.00
-- Derailleurs        | 47.50
-- Brakes             | 47.00
-- Bike Racks         | 45.00
-- Bottom Brackets    | 41.00
-- Jerseys            | 40.00
-- Headsets           | 38.33
-- Bib-Shorts         | 37.00
-- Handlebars         | 32.63
-- Tights             | 31.00
-- Pedals             | 28.57
-- Shorts             | 25.43
-- Vests              | 24.00
-- Hydration Packs    | 21.00
-- Saddles            | 17.33
-- Lights             | 13.00
-- Helmets            | 13.00
-- Gloves             | 12.50
-- Locks              | 10.00
-- Pumps              | 9.00
-- Chains             | 9.00
-- Fenders            | 8.00
-- Tires and Tubes    | 7.18
-- Caps               | 7.00
-- Socks              | 3.00
-- Cleaners           | 3.00
-- Bottles and Cages  | 3.00


-- 3. Top 20 products by cost
SELECT
    product_key,
    product_name,
    cost
FROM gold.dim_products
ORDER BY cost DESC
LIMIT 20;

-- Result:
-- product_key | product_name               | cost
-- ------------+----------------------------+------
-- 18          | Road-150 Red- 52           | 2171
-- 19          | Road-150 Red- 56           | 2171
-- 16          | Road-150 Red- 44           | 2171
-- 17          | Road-150 Red- 48           | 2171
-- 20          | Road-150 Red- 62           | 2171
-- 7           | Mountain-100 Silver- 38    | 1912
-- 10          | Mountain-100 Silver- 48    | 1912
-- 9           | Mountain-100 Silver- 44    | 1912
-- 8           | Mountain-100 Silver- 42    | 1912
-- 3           | Mountain-100 Black- 38     | 1898
-- 6           | Mountain-100 Black- 48     | 1898
-- 5           | Mountain-100 Black- 44     | 1898
-- 4           | Mountain-100 Black- 42     | 1898
-- 139         | Road-250 Black- 44         | 1555
-- 140         | Road-250 Black- 48         | 1555
-- 141         | Road-250 Black- 52         | 1555
-- 142         | Road-250 Black- 58         | 1555
-- 143         | Road-250 Red- 58           | 1555
-- 50          | Road-250 Red- 52           | 1519
-- 48          | Road-250 Red- 44           | 1519



/*-----------------------------------------------------------------------------
V.2 PRICE ANALYSIS
-----------------------------------------------------------------------------*/


-- 1. Average price by category
SELECT
    p.category,
    ROUND(AVG(s.price)) AS avg_price
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY avg_price DESC;

-- Result:
-- category    | avg_price
-- ------------+----------
-- Bikes       | 1862
-- Clothing    | 37
-- Accessories | 19


-- 2. Average price by subcategory
SELECT
    p.subcategory,
    ROUND(AVG(s.price)) AS avg_price
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY avg_price DESC;

-- Result:
-- subcategory        | avg_price
-- -------------------+----------
-- Mountain Bikes     | 2002
-- Road Bikes         | 1800
-- Touring Bikes      | 1774
-- Bike Stands        | 159
-- Bike Racks         | 120
-- Shorts             | 70
-- Vests              | 64
-- Hydration Packs    | 55
-- Jerseys            | 52
-- Helmets            | 35
-- Gloves             | 24
-- Fenders            | 22
-- Tires and Tubes    | 14
-- Caps               | 9
-- Socks              | 9
-- Cleaners           | 8
-- Bottles and Cages  | 7


-- 3. Top 20 products by recorded price
SELECT
    p.product_key,
    p.product_name,
    MAX(s.price) AS price
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY
    p.product_key,
    p.product_name
ORDER BY price DESC
LIMIT 20;

-- Result:
-- product_key | product_name               | price
-- ------------+----------------------------+------
-- 16          | Road-150 Red- 44           | 3578
-- 17          | Road-150 Red- 48           | 3578
-- 20          | Road-150 Red- 62           | 3578
-- 18          | Road-150 Red- 52           | 3578
-- 19          | Road-150 Red- 56           | 3578
-- 8           | Mountain-100 Silver- 42    | 3400
-- 9           | Mountain-100 Silver- 44    | 3400
-- 7           | Mountain-100 Silver- 38    | 3400
-- 10          | Mountain-100 Silver- 48    | 3400
-- 4           | Mountain-100 Black- 42     | 3375
-- 6           | Mountain-100 Black- 48     | 3375
-- 3           | Mountain-100 Black- 38     | 3375
-- 5           | Mountain-100 Black- 44     | 3375
-- 142         | Road-250 Black- 58         | 2443
-- 48          | Road-250 Red- 44           | 2443
-- 50          | Road-250 Red- 52           | 2443
-- 49          | Road-250 Red- 48           | 2443
-- 143         | Road-250 Red- 58           | 2443
-- 139         | Road-250 Black- 44         | 2443
-- 140         | Road-250 Black- 48         | 2443



/*-----------------------------------------------------------------------------
V.3 QUANTITY ANALYSIS
-----------------------------------------------------------------------------*/


-- 1. Total quantity sold by category
SELECT
    p.category,
    SUM(s.quantity) AS total_quantity_sold
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_quantity_sold DESC;

-- Result:
-- category    | total_quantity_sold
-- ------------+--------------------
-- Accessories | 36112
-- Bikes       | 15205
-- Clothing    | 9106


-- 2. Total quantity sold by subcategory
SELECT
    p.subcategory,
    SUM(s.quantity) AS total_quantity_sold
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_quantity_sold DESC;

-- Result:
-- subcategory        | total_quantity_sold
-- -------------------+--------------------
-- Tires and Tubes    | 17336
-- Road Bikes         | 8068
-- Bottles and Cages  | 7995
-- Helmets            | 6441
-- Mountain Bikes     | 4970
-- Jerseys            | 3334
-- Caps               | 2190
-- Touring Bikes      | 2167
-- Fenders            | 2121
-- Gloves             | 1430
-- Shorts             | 1019
-- Cleaners           | 909
-- Hydration Packs    | 733
-- Socks              | 568
-- Vests              | 565
-- Bike Racks         | 328
-- Bike Stands        | 249


-- 3. Top 20 products by total quantity sold
SELECT
    p.product_key,
    p.product_name,
    SUM(s.quantity) AS total_quantity_sold
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY
    p.product_key,
    p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 20;

-- Result:
-- product_key | product_name               | total_quantity_sold
-- ------------+----------------------------+---------------------
-- 295         | Water Bottle - 30 oz.      | 4249
-- 259         | Patch Kit/8 Patches        | 3191
-- 289         | Mountain Tire Tube         | 3096
-- 290         | Road Tire Tube             | 2376
-- 246         | Sport-100 Helmet- Red      | 2230
-- 166         | AWC Logo Cap               | 2190
-- 245         | Sport-100 Helmet- Blue     | 2126
-- 174         | Fender Set - Mountain      | 2121
-- 244         | Sport-100 Helmet- Black    | 2085
-- 104         | Mountain Bottle Cage       | 2034
-- 105         | Road Bottle Cage           | 1712
-- 291         | Touring Tire Tube          | 1488
-- 284         | HL Mountain Tire           | 1397
-- 283         | ML Mountain Tire           | 1161
-- 285         | LL Road Tire               | 1044
-- 288         | Touring Tire               | 935
-- 286         | ML Road Tire               | 926
-- 168         | Bike Wash - Dissolver      | 909
-- 282         | LL Mountain Tire           | 864
-- 287         | HL Road Tire               | 858



/*-----------------------------------------------------------------------------
V.4 ORDER ANALYSIS
-----------------------------------------------------------------------------*/


-- 1. Number of orders by category
SELECT
    p.category,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_orders DESC;

-- Result:
-- category    | total_orders
-- ------------+-------------
-- Accessories | 18208
-- Bikes       | 15205
-- Clothing    | 7461


-- 2. Number of orders by subcategory
SELECT
    p.subcategory,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_orders DESC;

-- Result:
-- subcategory       | total_orders
-- ------------------+-------------
-- Tires and Tubes    | 9867
-- Road Bikes         | 8068
-- Helmets            | 6440
-- Mountain Bikes     | 4970
-- Bottles and Cages  | 4768
-- Jerseys            | 3332
-- Caps               | 2190
-- Touring Bikes      | 2167
-- Fenders            | 2121
-- Gloves             | 1430
-- Shorts             | 1019
-- Cleaners           | 908
-- Hydration Packs    | 733
-- Socks              | 568
-- Vests              | 562
-- Bike Racks         | 328
-- Bike Stands        | 249


-- 3. Top 20 products by number of orders
SELECT
    p.product_key,
    p.product_name,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY
    p.product_key,
    p.product_name
ORDER BY total_orders DESC
LIMIT 20;

-- Result:
-- product_key | product_name               | total_orders
-- ------------+----------------------------+-------------
-- 295         | Water Bottle - 30 oz.      | 4244
-- 259         | Patch Kit/8 Patches        | 3191
-- 289         | Mountain Tire Tube         | 3095
-- 290         | Road Tire Tube             | 2376
-- 246         | Sport-100 Helmet- Red      | 2230
-- 166         | AWC Logo Cap               | 2190
-- 245         | Sport-100 Helmet- Blue     | 2125
-- 174         | Fender Set - Mountain      | 2121
-- 244         | Sport-100 Helmet- Black    | 2085
-- 104         | Mountain Bottle Cage       | 2025
-- 105         | Road Bottle Cage           | 1712
-- 291         | Touring Tire Tube          | 1488
-- 284         | HL Mountain Tire           | 1396
-- 283         | ML Mountain Tire           | 1161
-- 285         | LL Road Tire               | 1044
-- 288         | Touring Tire               | 935
-- 286         | ML Road Tire               | 926
-- 168         | Bike Wash - Dissolver      | 908
-- 282         | LL Mountain Tire           | 862
-- 287         | HL Road Tire               | 858


-- 4. Top 20 customers by number of orders
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders DESC
LIMIT 20;

-- Result:
-- customer_key | first_name | last_name  | total_orders
-- -------------+------------+------------+-------------
-- 92           | Dalton     | Perez      | 28
-- 177          | Mason      | Roberts    | 28
-- 332          | Samantha   | Jenkins    | 27
-- 186          | Ashley     | Henderson  | 27
-- 331          | Ryan       | Thompson   | 27
-- 301          | Fernando   | Barnes     | 27
-- 712          | Daniel     | Davis      | 27
-- 288          | Henry      | Garcia     | 27
-- 201          | Jason      | Griffin    | 27
-- 263          | Jennifer   | Simmons    | 27
-- 224          | Hailey     | Patterson  | 27
-- 278          | Charles    | Jackson    | 27
-- 277          | Nancy      | Chapman    | 27
-- 567          | April      | Shan       | 25
-- 212          | Samantha   | Russell    | 17
-- 204          | Luis       | Diaz       | 17
-- 213          | Chloe      | Campbell   | 17
-- 143          | Eduardo    | Patterson  | 17
-- 20           | Luke       | Lal        | 17
-- 79           | Gina       | Martin     | 17


-- 5. Number of orders by gender
SELECT
    c.gender,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
GROUP BY c.gender
ORDER BY total_orders DESC;

-- Result:
-- gender | total_orders
-- -------+-------------
-- Male   | 13906
-- Female | 13737
-- n/a    | 16


-- 6. Number of orders by marital status
SELECT
    c.marital_status,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
GROUP BY c.marital_status
ORDER BY total_orders DESC;

-- Result:
-- marital_status | total_orders
-- ---------------+-------------
-- Married        | 15158
-- Single         | 12501


-- 7. Number of orders by country
SELECT
    c.country,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_orders DESC;

-- Result:
-- country        | total_orders
-- ---------------+-------------
-- United States  | 9230
-- Australia      | 6718
-- Canada         | 3375
-- United Kingdom | 3031
-- Germany        | 2484
-- France         | 2484
-- n/a            | 337



/*-----------------------------------------------------------------------------
V.5 SALES REVENUE ANALYSIS
-----------------------------------------------------------------------------*/


-- 1. Total revenue by category
SELECT
    p.category,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Result:
-- category    | total_revenue
-- ------------+--------------
-- Bikes       | 28316272
-- Accessories | 700262
-- Clothing    | 339716


-- 2. Total revenue by subcategory
SELECT
    p.subcategory,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC;

-- Result:
-- subcategory        | total_revenue
-- -------------------+--------------
-- Road Bikes         | 14519438
-- Mountain Bikes     | 9952254
-- Touring Bikes      | 3844580
-- Tires and Tubes    | 244634
-- Helmets            | 225435
-- Jerseys            | 173084
-- Shorts             | 71330
-- Bottles and Cages  | 56993
-- Fenders            | 46662
-- Hydration Packs    | 40315
-- Bike Stands        | 39591
-- Bike Racks         | 39360
-- Vests              | 36160
-- Gloves             | 34320
-- Caps               | 19710
-- Cleaners           | 7272
-- Socks              | 5112


-- 3. Top 20 products by total revenue
SELECT
    p.product_key,
    p.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY
    p.product_key,
    p.product_name
ORDER BY total_revenue DESC
LIMIT 20;

-- Result:
-- product_key | product_name               | total_revenue
-- ------------+----------------------------+--------------
-- 122         | Mountain-200 Black- 46     | 1373454
-- 121         | Mountain-200 Black- 42     | 1363128
-- 123         | Mountain-200 Silver- 38    | 1339394
-- 125         | Mountain-200 Silver- 46    | 1301029
-- 120         | Mountain-200 Black- 38     | 1294854
-- 124         | Mountain-200 Silver- 42    | 1257368
-- 17          | Road-150 Red- 48           | 1205786
-- 20          | Road-150 Red- 62           | 1202208
-- 18          | Road-150 Red- 52           | 1080556
-- 19          | Road-150 Red- 56           | 1055510
-- 16          | Road-150 Red- 44           | 1005418
-- 141         | Road-250 Black- 52         | 734425
-- 143         | Road-250 Red- 58           | 702666
-- 140         | Road-250 Black- 48         | 691213
-- 139         | Road-250 Black- 44         | 628384
-- 142         | Road-250 Black- 58         | 622026
-- 158         | Touring-1000 Blue- 46      | 421968
-- 135         | Road-350-W Yellow- 40      | 418446
-- 162         | Touring-1000 Yellow- 46    | 410048
-- 136         | Road-350-W Yellow- 42      | 399735



-- 4. Top 20 customers by total revenue
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC
LIMIT 20;

-- Result:
-- customer_key | first_name | last_name  | total_revenue
-- -------------+------------+------------+--------------
-- 1133         | Kaitlyn    | Henderson  | 13294
-- 1302         | Nichole    | Nara       | 13294
-- 1309         | Margaret   | He         | 13268
-- 1132         | Randall    | Dominguez  | 13265
-- 1301         | Adriana    | Gonzalez   | 13242
-- 1322         | Rosa       | Hu         | 13215
-- 1125         | Brandi     | Gill       | 13195
-- 1308         | Brad       | She        | 13172
-- 1297         | Francisco  | Sara       | 13164
-- 434          | Maurice    | Shan       | 12914
-- 440          | Janet      | Munoz      | 12488
-- 242          | Lisa       | Cai        | 11468
-- 418          | Lacey      | Zheng      | 11248
-- 421          | Jordan     | Turner     | 11200
-- 243          | Larry      | Munoz      | 11067
-- 1656         | Larry      | Vazquez    | 10899
-- 2264         | Kate       | Anand      | 10871
-- 1324         | Lawrence   | Alonso     | 10836
-- 1334         | Terrance   | Rodriguez  | 10829
-- 1651         | Aaron      | Wright     | 10813


-- 5. Total revenue by gender
SELECT
    c.gender,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
GROUP BY c.gender
ORDER BY total_revenue DESC;

-- Result:
-- gender | total_revenue
-- -------+--------------
-- Female | 14804168
-- Male   | 14522393
-- n/a    | 29689


-- 6. Total revenue by marital status
SELECT
    c.marital_status,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
GROUP BY c.marital_status
ORDER BY total_revenue DESC;

-- Result:
-- marital_status | total_revenue
-- ---------------+--------------
-- Married        | 15185985
-- Single         | 14170265


-- 7. Total revenue by country
SELECT
    c.country,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_revenue DESC;

-- Result:
-- country        | total_revenue
-- ---------------+--------------
-- United States  | 9162327
-- Australia      | 9060172
-- United Kingdom | 3391376
-- Germany        | 2894066
-- France         | 2643751
-- Canada         | 1977738
-- n/a            | 226820