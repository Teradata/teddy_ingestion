CREATE MULTISET TABLE teddy_ingestion.visits AS
(
	SELECT visit_id, visits_products.customer_id, visit_duration, payment_method, order_date from (
		LOCATION ='/gs/storage.googleapis.com/clearscape_analytics_demo_data/DEMO_TVUG_TPT_NOS/visits.csv'
	) AS visits_products
	JOIN (
	  SELECT DISTINCT customer_id 
	  FROM teddy_ingestion.online_store
	) AS os 
	ON visits_products.customer_id = os.customer_id
) WITH DATA;
