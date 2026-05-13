create database olist_db;
use olist_db;

show tables;

SELECT count(*) from orders_stage;
SELECT count(*) from customers_stage;
SELECT count(*) from geolocation_stage;
SELECT count(*) from order_items_stage;
SELECT count(*) from order_payments_stage;
SELECT count(*) from order_reviews_stage;
SELECT count(*) from product_category_translation_stage;
SELECT count(*) from products_stage;
SELECT count(*) from sellers_stage;

-- 1. Orders NULL check
SELECT 
    'orders_stage' as table_name,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) as order_id_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) as customer_id_nulls,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) as order_status_nulls,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) as purchase_ts_nulls,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) as approved_nulls,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) as carrier_nulls,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) as customer_nulls,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) as estimated_nulls
FROM orders_stage;

-- 2. Customers NULL check
SELECT
    'customers_stage' as table_name,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) as customer_id_nulls,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) as unique_id_nulls,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) as zip_nulls,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) as city_nulls,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) as state_nulls
FROM customers_stage;

-- 3. Order Items NULL check
SELECT
    'order_items_stage' as table_name,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) as order_id_nulls,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) as item_id_nulls,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) as product_id_nulls,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) as seller_id_nulls,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) as price_nulls,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) as freight_nulls
FROM order_items_stage;

-- 4. Payments NULL check
SELECT
    'order_payments_stage' as table_name,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) as order_id_nulls,
    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) as sequential_nulls,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) as type_nulls,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) as installments_nulls,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) as value_nulls
FROM order_payments_stage;

-- 5. Reviews NULL check
SELECT
    'order_reviews_stage' as table_name,
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) as review_id_nulls,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) as order_id_nulls,
    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) as score_nulls,
    SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) as title_nulls,
    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) as message_nulls,
    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) as creation_nulls,
    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) as answer_nulls
FROM order_reviews_stage;

-- 6. Products NULL check
SELECT
    'products_stage' as table_name,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) as product_id_nulls,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) as category_nulls,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) as name_len_nulls,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) as desc_len_nulls,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) as photos_nulls,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) as weight_nulls,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) as length_nulls,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) as height_nulls,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) as width_nulls
FROM products_stage;

-- 7. Sellers NULL check
SELECT
    'sellers_stage' as table_name,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) as seller_id_nulls,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) as zip_nulls,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) as city_nulls,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) as state_nulls
FROM sellers_stage;

-- 8. Geolocation NULL check
SELECT
    'geolocation_stage' as table_name,
    SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) as zip_nulls,
    SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) as lat_nulls,
    SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) as lng_nulls,
    SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) as city_nulls,
    SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) as state_nulls
FROM geolocation_stage;

SELECT
	'product_category_translation_stage' as table_name,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) as name_nulls,
	SUM(CASE WHEN product_category_name_english IS NULL THEN 1 ELSE 0 END) as name_english_nulls

from product_category_translation_stage;



# change the Orders_stage string data type to date 

ALTER TABLE orders_stage
MODIFY COLUMN order_purchase_timestamp TIMESTAMP,
MODIFY COLUMN order_approved_at TIMESTAMP,
MODIFY COLUMN order_delivered_carrier_date TIMESTAMP,
MODIFY COLUMN order_delivered_customer_date TIMESTAMP,
MODIFY COLUMN order_estimated_delivery_date TIMESTAMP;

# Now we add a new column to the to the orders table for Null handling ==>

ALTER TABLE orders_stage                   # Adding the column
ADD COLUMN delivery_status VARCHAR(50);

UPDATE orders_stage
SET delivery_status =
    CASE 
        WHEN order_delivered_customer_date IS NULL 
         AND order_delivered_carrier_date IS NULL 
        THEN 'NOT_DELIVERED'

        WHEN order_delivered_customer_date IS NULL 
        THEN 'IN_TRANSIT'

        ELSE 'DELIVERED'
    END;
    
# Now we fill the Null values of Reviews table

UPDATE order_reviews_stage
SET review_comment_title =
    COALESCE(review_comment_title, 'No Title');
    
UPDATE order_reviews_stage
SET review_comment_message =
    COALESCE(review_comment_message, 'No Comment');

# Now for Products_stage

UPDATE products_stage
SET
    product_category_name = COALESCE(product_category_name, 'Unknown Category'),

    product_name_lenght = COALESCE(product_name_lenght, 0),
    product_description_lenght = COALESCE(product_description_lenght, 0),
    product_photos_qty = COALESCE(product_photos_qty, 0),

    product_weight_g = COALESCE(product_weight_g, 0),
    product_length_cm = COALESCE(product_length_cm, 0),
    product_height_cm = COALESCE(product_height_cm, 0),
    product_width_cm = COALESCE(product_width_cm, 0);



