/*
===============================================================================
II. DIMENSIONS EXPLORATION
===============================================================================
Purpose:
    Identify distinct values in dimension attributes and understand possible
    groupings and the granularity of the dimensions.
===============================================================================
*/

-- 1. gender values
SELECT DISTINCT gender
FROM gold.dim_customers;

-- Result:
-- gender
-- -------
-- n/a
-- Female
-- Male


-- 2. marital status values
SELECT DISTINCT marital_status
FROM gold.dim_customers;

-- Result:
-- marital_status
-- --------------
-- Married
-- Single


-- 3. country values
SELECT DISTINCT country
FROM gold.dim_customers;

-- Result:
-- country
-- ---------------
-- United Kingdom
-- n/a
-- Australia
-- Germany
-- Canada
-- France
-- United States


-- 4. product line values
SELECT DISTINCT product_line
FROM gold.dim_products;

-- Result:
-- product_line
-- ------------
-- Other Sales
-- n/a
-- Road
-- Mountain
-- Touring


-- 5. product category values
SELECT DISTINCT category
FROM gold.dim_products;

-- Result:
-- category
-- ----------
-- Clothing
-- Components
-- Accessories
-- Bikes


-- 6. product subcategory values
SELECT DISTINCT subcategory
FROM gold.dim_products;

-- Result:
-- subcategory
-- ------------------
-- Road Frames
-- Pumps
-- Mountain Frames
-- Chains
-- Panniers
-- Bottom Brackets
-- Wheels
-- Mountain Bikes
-- Tights
-- Headsets
-- Bike Stands
-- Pedals
-- Lights
-- Bike Racks
-- Handlebars
-- Cleaners
-- Bib-Shorts
-- Brakes
-- Socks
-- Touring Bikes
-- Vests
-- Caps
-- Touring Frames
-- Hydration Packs
-- Helmets
-- Gloves
-- Fenders
-- Saddles
-- Shorts
-- Forks
-- Tires and Tubes
-- Road Bikes
-- Cranksets
-- Locks
-- Jerseys
-- Bottles and Cages
-- Derailleurs


-- 7. maintenance values
SELECT DISTINCT maintenance
FROM gold.dim_products;

-- Result:
-- maintenance
-- -----------
-- No
-- Yes