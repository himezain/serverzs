SELECT
	customer_id, 
	AVG(extended_amount),
	ntile(5) OVER (ORDER BY extended_amount) bin
FROM 
	mdwh.us_raw.l_dmw_order_report
WHERE 
	quantity_ordered > 0
	AND UPPER(line_status) NOT IN ('','RETURN', 'CANCELLED')
	AND UPPER(item_description_1) NOT IN ('','FREIGHT', 'RETURN LABEL FEE', 'VISIBLE STITCH')
	AND (quantity_ordered * unit_price_amount) > 0
	AND extended_amount < 1000 --NO BULK ORDERS
	AND oms_order_date BETWEEN '2020-01-01' AND '2020-01-31'
	AND SUBSTRING(upc,1,6) IN (SELECT item_code FROM item_master_zs WHERE new_division BETWEEN '11' AND '39')
--GROUP BY
--	customer_id,
--	extended_amount