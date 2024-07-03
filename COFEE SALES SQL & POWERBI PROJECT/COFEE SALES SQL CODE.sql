select *from  coffee_shop_sales;

SELECT  round (SUM(transaction_qty * unit_price)) as total_sales
from coffee_shop_sales
WHERE
MONTH (transaction_date) = 3;

-- Month-Over-Month Growth? Month-over-month (MoM) growth shows the change in the value of a specific metric
 -- as a percentage of the previous month's value.
 
 SELECT 
    MONTH(transaction_date) AS month, -- NUMBER OF MONTH
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales, -- TOTAL SALES
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) -- DIVIDE BY PREVIOUS SALES
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (3, 2) -- for months of march  and february
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

-- TOTAL ORDERS
SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales 
WHERE MONTH (transaction_date)= 2 -- for month of (CM-feb)

-- TOTAL ORDERS KPI - MOM DIFFERENCE AND MOM GROWTH

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (2, 3) -- for feb and mar
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

-- TOTAL QUANTITY SOLD
SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 2 -- for month of (CM-feb)

-- TOTAL QUANTITY SOLD KPI - MOM DIFFERENCE AND MOM GROWTH

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (2, 3)   -- for feb and mer
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

-- CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS
SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-02-18'; --For 18 feb 2023
    
   -- If you want to get exact Rounded off values then use below query to get the result:
SELECT 
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1),'K') AS total_sales,
    CONCAT(ROUND(COUNT(transaction_id) / 1000, 1),'K') AS total_orders,
    CONCAT(ROUND(SUM(transaction_qty) / 1000, 1),'K') AS total_quantity_sold
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-02-18'; --For 18 feb 2023

-- SALES BY WEEKDAY / WEEKEND:
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS day_type,
    ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 2  -- Filter for May
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;


--  BY STORE LOCATION
SELECT 
	store_location,
	SUM(unit_price * transaction_qty) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) =2 
GROUP BY store_location
ORDER BY 	SUM(unit_price * transaction_qty) DESC


-- SALES BY PRODUCT CATEGORY
SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 3
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC

-- SALES BY PRODUCTS (TOP 10)
SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 2 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10

-- SALES BY DAY | HOUR
SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_shop_sales
WHERE 
    DAYOFWEEK(transaction_date) = 2 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 2; -- Filter for May (month number 5)

-- TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 3 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;

--TO GET SALES FOR ALL HOURS FOR MONTH OF feb
SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 2 -- Filter for May (month number 5)
GROUP BY 
    HOUR(transaction_time)
ORDER BY 
    HOUR(transaction_time);


-- SALES TREND OVER PERIOD
SELECT AVG(total_sales) AS average_sales
FROM (
    SELECT 
        SUM(unit_price * transaction_qty) AS total_sales
    FROM 
        coffee_shop_sales
	WHERE 
        MONTH(transaction_date) = 2  -- Filter for May
    GROUP BY 
        transaction_date
) AS internal_query;

