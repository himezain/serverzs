--This will first create quintiles using the ntile function
--Then factor in the conditions
--Then combine the score
--Then the substrings will seperate each score's individual points

SELECT *,
	SUBSTRING(rfm_combined,1,1) AS recency_score,
	SUBSTRING(rfm_combined,2,1) AS frequency_score,
	SUBSTRING(rfm_combined,3,1) AS monetary_score
FROM (

SELECT
	customer_id,
	rfm_recency*100 + rfm_frequency*10 + rfm_monetary AS rfm_combined
FROM
	(SELECT
	customer_id,
	ntile(5) over (order by last_order_date) AS rfm_recency,
	ntile(5) over (order by count_order) AS rfm_frequency,
	ntile(5) over (order by total_spent) AS rfm_monetary
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
	AND oms_order_date BETWEEN '2019-01-01' AND CURRENT_DATE

GROUP BY customer_id))

ORDER BY customer_id desc)


--The below will simply provide the total revenue a customer has provided
--Grouped by customer_id

SELECT 
	customer_id, 
	SUM(quantity_ordered*unit_price_amount) AS revenue
FROM 
	l_dmw_order_report
WHERE
	order_type NOT IN ('Sales Return', 'Sales Price Adjustment')
	AND item_description_1 NOT IN ('freight', 'FREIGHT', 'Freight')
	AND line_status NOT IN ('CANCELLED', 'HOLD')
	AND oms_order_date BETWEEN '2019-01-01' AND CURRENT_DATE
	
GROUP BY customer_id
ORDER BY customer_id desc