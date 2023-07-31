CREATE TABLE teddy_ingestion.visit_products
(
  visit_id INTEGER,
  product_id INTEGER,
  product_quantity INTEGER
)
NO PRIMARY INDEX;

INSERT INTO teddy_ingestion.visit_products
SELECT vs_pd.visit_id, product_id, product_quantity FROM 
(
	LOCATION ='/gs/storage.googleapis.com/clearscape_analytics_demo_data/DEMO_TVUG_TPT_NOS/visit_products.csv'
) AS vs_pd
JOIN
	teddy_ingestion.visits  AS db_vs ON db_vs.visit_id = vs_pd.visit_id;