-- Creating the database olist_db
CREATE DATABASE IF NOT EXISTS olist_db;

-- Selecting the desired Database
USE olist_db;

-- Creating the Tables

-- 1) Customers Dataset
DROP TABLES IF EXISTS olist_customers_dataset CASCADE;
CREATE TABLE olist_customers_dataset(
	customer_id VARCHAR(200),
    customer_unique_id VARCHAR(200),
	customer_zip_code_prefix VARCHAR(200),
	customer_city TEXT,
    customer_state TEXT,
    PRIMARY KEY (customer_id)
);

-- 2) Geolocation Dataset (No Primary Key as zip codes repeat)
DROP TABLES IF EXISTS olist_geolocation_dataset CASCADE;
CREATE TABLE olist_geolocation_dataset(
	geolocation_zip_code_prefix VARCHAR(200),
    geolocation_lat DOUBLE,
	geolocation_lang DOUBLE,
	geolocation_city TEXT,
    geolocation_state TEXT
);

-- 3) Products Dataset
DROP TABLES IF EXISTS olist_products_dataset CASCADE;
CREATE TABLE olist_products_dataset(
	product_id VARCHAR(200),
    product_category_name VARCHAR(200),
	product_name_leght INT,
	product_description_leght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    PRIMARY KEY (product_id)
);

-- 4) Sellers Dataset 
DROP TABLES IF EXISTS olist_sellers_dataset CASCADE;
CREATE TABLE olist_sellers_dataset(
	seller_id VARCHAR(200),
    seller_zip_code_prefix VARCHAR(200),
	seller_city VARCHAR(200),
	seller_state VARCHAR(200),
    PRIMARY KEY (seller_id)
);

-- 5) Orders Dataset
DROP TABLES IF EXISTS olist_orders_dataset CASCADE;
CREATE TABLE olist_orders_dataset(
	order_id VARCHAR(200),
    customer_id VARCHAR(200),
	order_status VARCHAR(200),
	order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    PRIMARY KEY (order_id)
);

-- 6) Orders Item Dataset
DROP TABLES IF EXISTS olist_order_items_dataset CASCADE;
CREATE TABLE olist_order_items_dataset(
	order_id VARCHAR(200),
    order_item_id INT,
	product_id VARCHAR(200),
    seller_id VARCHAR(200),
	shipping_limit_date TIMESTAMP,
    price DOUBLE,
    freight_value DOUBLE
);

-- 7) Order Payments Dataset
DROP TABLE IF EXISTS olist_order_payments_dataset CASCADE;
CREATE TABLE olist_order_payments_dataset (
    order_id VARCHAR(200),
    payment_sequential INT,
    payment_type VARCHAR(200),
    payment_installments INT,
    payment_value DOUBLE
);

-- 8) Order Reviews Dataset
DROP TABLE IF EXISTS olist_order_reviews_dataset CASCADE;
CREATE TABLE olist_order_reviews_dataset (
    review_id VARCHAR(200),
    order_id VARCHAR(200),
    review_score INT,
    review_comment_title VARCHAR(200),
    review_comment_message VARCHAR(200),
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- While inserting data into olist_order_reviews_dataset table found that VARCHAR datatype is small so changed it to TEXT datatype
ALTER TABLE olist_order_reviews_dataset
MODIFY review_comment_message TEXT;

-- 9) Product Category Name Translation
DROP TABLE IF EXISTS product_category_name_translation CASCADE;
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(200),
    product_category_name_english VARCHAR(200),
    PRIMARY KEY(product_category_name)
);


-- Establishing relationships between Tables/Databases (Using Foreign Keys)

-- 1) Link Orders to Customers
ALTER TABLE olist_orders_dataset
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset(customer_id);

-- 2) Link Order Items to Orders, Products, and Sellers
ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_items_orders
FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id),
ADD CONSTRAINT fk_items_products
FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id),
ADD CONSTRAINT fk_items_sellers
FOREIGN KEY (seller_id) REFERENCES olist_sellers_dataset(seller_id);

-- 3) Link Order Payments to Orders
ALTER TABLE olist_order_payments_dataset
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id);

-- 4) Link Order Reviews to Orders
ALTER TABLE olist_order_reviews_dataset
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id);