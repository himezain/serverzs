(SELECT
	e.first_name,
	e.department,
	e.hire_date,
	r.country
FROM
	employees e

INNER JOIN regions r ON e.region_id = r.region_id

WHERE
	hire_date = (SELECT MIN(hire_date) FROM employees)
LIMIT 1)
UNION ALL

SELECT
	e.first_name,
	e.department,
	e.hire_date,
	r.country
FROM
	employees e

INNER JOIN regions r ON e.region_id = r.region_id

WHERE
	hire_date = (SELECT MAX(hire_date) FROM employees)