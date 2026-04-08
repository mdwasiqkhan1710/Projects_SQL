-- Copying Data from CSV files into our created Database

-- 1)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE 
	olist_customers_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 2)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE 
	olist_geolocation_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 3)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE 
	olist_products_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 4)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE 
	olist_sellers_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 5)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE 
	olist_orders_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id, customer_id, order_status,
	@order_purchase_timestamp,
	@order_approved_at,
	@order_delivered_carrier_date,
	@order_delivered_customer_date,
	@order_estimated_delivery_date
)

SET
order_purchase_timestamp = STR_TO_DATE(NULLIF(@order_purchase_timestamp,''), '%d-%m-%Y %H:%i'),
order_approved_at = STR_TO_DATE(NULLIF(NULLIF(@order_approved_at,'null'),''), '%d-%m-%Y %H:%i'),
order_delivered_carrier_date = STR_TO_DATE(NULLIF(NULLIF(@order_delivered_carrier_date,'null'),''), '%d-%m-%Y %H:%i'),
order_delivered_customer_date = STR_TO_DATE(NULLIF(NULLIF(@order_delivered_customer_date,'null'),''), '%d-%m-%Y %H:%i'),
order_estimated_delivery_date = STR_TO_DATE(NULLIF(NULLIF(@order_estimated_delivery_date,'null'),''), '%d-%m-%Y %H:%i');

SELECT * FROM olist_orders_dataset;

-- 6)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE 
	olist_order_items_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 7)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
INTO TABLE 
	olist_order_payments_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 8)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE 
	olist_order_reviews_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

(@review_id,
 @order_id,
 @review_score,
 @review_comment_title,
 @review_comment_message,
 @review_creation_date,
 @review_answer_timestamp)

SET
review_id = @review_id,
order_id = @order_id,
review_score = @review_score,
review_comment_title = @review_comment_title,
review_comment_message = @review_comment_message,
review_creation_date = 
CASE 
  WHEN @review_creation_date IN ('', 'null') THEN NULL
  ELSE STR_TO_DATE(@review_creation_date, '%Y-%m-%d %H:%i:%s')
END,
review_answer_timestamp = 
CASE 
  WHEN @review_answer_timestamp IN ('', 'null') THEN NULL
  ELSE STR_TO_DATE(@review_answer_timestamp, '%Y-%m-%d %H:%i:%s')
END;

-- 9)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
IGNORE
INTO TABLE 
	product_category_name_translation
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;