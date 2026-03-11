-- Skrypt 2: Transformacja surowych danych w architekturę Star Schema

CREATE TABLE Fact_Sales AS
SELECT 
    i.order_id,
    i.order_item_id,
    o.customer_id,
    i.product_id,
    o.order_purchase_timestamp::DATE AS order_date,
    i.price,
    i.freight_value
FROM stg_order_items i
JOIN stg_orders o ON i.order_id = o.order_id
WHERE o.order_status = 'delivered';

CREATE TABLE Dim_Customer AS
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM stg_customers;

CREATE TABLE Dim_Date AS
SELECT
    datum AS date_key,
    EXTRACT(YEAR FROM datum) AS year,
    EXTRACT(MONTH FROM datum) AS month,
    TO_CHAR(datum, 'Month') AS month_name,
    EXTRACT(DAY FROM datum) AS day,
    EXTRACT(QUARTER FROM datum) AS quarter,
    EXTRACT(ISODOW FROM datum) AS day_of_week
FROM (
    SELECT generate_series(
        '2016-01-01'::DATE, 
        '2019-12-31'::DATE, 
        '1 day'::interval
    )::DATE AS datum
) AS dates;

CREATE TABLE Dim_Product AS
SELECT 
    product_id,
    product_category_name
FROM stg_products;