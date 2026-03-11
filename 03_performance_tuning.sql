-- Skrypt 3: Optymalizacja pod odczyt: dodanie kluczy, indeksów i widoku zmaterializowanego

-- 1. Klucze Główne
ALTER TABLE dim_customer ADD PRIMARY KEY (customer_id);
ALTER TABLE dim_product ADD PRIMARY KEY (product_id);
ALTER TABLE dim_date ADD PRIMARY KEY (date_key);

-- 2. Klucze Obce
ALTER TABLE fact_sales ADD CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id);
ALTER TABLE fact_sales ADD CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES dim_product(product_id);
ALTER TABLE fact_sales ADD CONSTRAINT fk_sales_date FOREIGN KEY (order_date) REFERENCES dim_date(date_key);

-- 3. Indeksy pod szybkie filtrowanie w Power BI
CREATE INDEX idx_fact_customer_id ON fact_sales(customer_id);
CREATE INDEX idx_fact_product_id ON fact_sales(product_id);
CREATE INDEX idx_fact_date ON fact_sales(order_date);

-- 4. Widok zmaterializowany
CREATE MATERIALIZED VIEW mv_monthly_sales_by_category AS
SELECT 
    d.year,
    d.month,
    d.month_name,
    p.product_category_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.price) AS total_revenue
FROM fact_sales f
JOIN dim_date d ON f.order_date = d.date_key
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY 
    d.year,
    d.month,
    d.month_name,
    p.product_category_name;