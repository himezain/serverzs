SELECT
	customer_id,
	rfm_recency*100 + rfm_frequency*10 + rfm_monetary AS rfm_combined
FROM
	(SELECT
	customer_id,
	ntile(4) over (order by last_order_date) AS rfm_recency,
	ntile(4) over (order by count_order) AS rfm_frequency,
	ntile(4) over (order by total_spent) AS rfm_monetary
FROM
	(SELECT
	customer_id,
	MAX(oms_order_date) AS last_order_date,
	COUNT(*) AS count_order,
	SUM(quantity_ordered * unit_price_amount) AS total_spent
FROM 
	l_dmw_order_report
WHERE
	order_type NOT IN ('Sales Return', 'Sales Price Adjustment')
	AND item_description_1 NOT IN ('freight', 'FREIGHT', 'Freight')
	AND line_status NOT IN ('CANCELLED', 'HOLD')

GROUP BY customer_id))
	