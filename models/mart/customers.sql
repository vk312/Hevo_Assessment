{{ config(materialized='table') }}

WITH customer_orders AS (
    SELECT 
        "user_id" AS "customer_id",
        MIN("order_date") AS first_order,
        MAX("order_date") AS most_recent_order,
        COUNT(*) AS number_of_orders
    FROM HEVO_DB.SRC_PUBLIC."raw_orders"
    GROUP BY "user_id"
),
customer_lifetime_value AS (
    SELECT 
        o."user_id" AS "customer_id",
        SUM(TRY_CAST(p."amount" AS NUMBER(38,2))) AS customer_lifetime_value
    FROM HEVO_DB.SRC_PUBLIC."raw_payments" p
    JOIN HEVO_DB.SRC_PUBLIC."raw_orders" o
        ON p."order_id" = o."id"
    GROUP BY o."user_id"
)
SELECT 
    c."id" AS customer_id,
    c."first_name",
    c."last_name",
    co.first_order,
    co.most_recent_order,
    co.number_of_orders,
    COALESCE(clv.customer_lifetime_value, 0) AS customer_lifetime_value
FROM HEVO_DB.SRC_PUBLIC."raw_customers" c
LEFT JOIN customer_orders co 
    ON c."id" = co."customer_id"
LEFT JOIN customer_lifetime_value clv 
    ON c."id" = clv."customer_id"