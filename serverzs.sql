SELECT
	*
FROM 
	l_nvr_ec_returns
WHERE
	return_created_date BETWEEN '2019-09-01' AND '2019-09-29'
ORDER BY order_date desc

--//***********************//--

SELECT
	item_name, SUM(return_qty) "Number of Returns"
FROM 
	l_nvr_ec_returns
WHERE 
	return_created_date BETWEEN '2019-09-01' AND '2019-09-29'
	AND return_status NOT IN ('Cancelled', 'cancelled')

GROUP BY item_name
ORDER BY SUM(return_qty) desc
LIMIT 20


--//***********************//--

-- l_nvr_ec_returns
-- l_dmw_order_report
-- upc
-- product_sku
-- Based on the COMMON sku, divide RETURN and UNITS

SELECT SUBSTRING(product_sku,1,6), SUM(return_qty) R
FROM l_nvr_ec_returns
WHERE return_created_date BETWEEN '2019-10-01' AND '2019-10-31'
GROUP BY SUBSTRING(product_sku,1,6)


SELECT SUBSTRING(upc,1,6), SUM(quantity_ordered) O
FROM l_dmw_order_report
WHERE oms_order_date BETWEEN '2019-10-01' AND '2019-10-31'
GROUP BY SUBSTRING(upc,1,6)

SELECT R
FROM (SELECT SUBSTRING(product_sku,1,6), SUM(return_qty) R
FROM l_nvr_ec_returns
WHERE return_created_date BETWEEN '2019-10-01' AND '2019-10-31'
GROUP BY SUBSTRING(product_sku,1,6))


WITH returnz AS 
(SELECT R
FROM (SELECT SUBSTRING(product_sku,1,6), SUM(return_qty) R
FROM l_nvr_ec_returns
WHERE return_created_date BETWEEN '2019-10-01' AND '2019-10-31'
GROUP BY SUBSTRING(product_sku,1,6))), soldz AS
(SELECT SUBSTRING(upc,1,6), SUM(quantity_ordered) O
FROM l_dmw_order_report
WHERE oms_order_date BETWEEN '2019-10-01' AND '2019-10-31'
GROUP BY SUBSTRING(upc,1,6))

-- The above was updated in Aginity. Use that.


SELECT
	DISTINCT(SUBSTRING(product_sku,15,3)) unique_sizes, SUM((SUBSTRING(product_sku,15,3))) total_of_sizes
FROM 
	l_nvr_ec_returns
WHERE 
	return_created_date BETWEEN '2019-10-01' AND '2019-10-23'
	AND return_status NOT IN ('Cancelled', 'cancelled')
	AND return_qty > 0
	AND item_name LIKE '%OVERSIZE%'

GROUP BY unique_sizes
ORDER BY unique_sizes


--

--Number of Units Sold:
SELECT 
	SUBSTRING(upc,1,6) orders_skus, SUM(quantity_ordered)
FROM
	l_dmw_order_report
WHERE
	quantity_ordered > 0
	AND oms_order_date BETWEEN '2019-10-01' AND '2019-10-23'
	AND line_status NOT IN ('','return','RETURN')
	AND SUBSTRING(upc,1,6) = 415797

GROUP BY orders_skus
ORDER BY orders_skus


--Number of returns
SELECT
	DISTINCT(SUBSTRING(product_sku,1,6)) return_skus, SUM(return_qty) number_of_returns
FROM 
	l_nvr_ec_returns
WHERE 
	return_created_date BETWEEN '2019-10-01' AND '2019-10-23'
	AND return_status NOT IN ('Cancelled', 'cancelled')
	AND return_qty > 0
	AND item_name LIKE '%OVERSIZE%'

GROUP BY return_skus
ORDER BY return_skus

