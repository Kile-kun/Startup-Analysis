USE startup_db;

/*SOLUTIONS TO DATASET QUESTION*/

/*1. LARGEST INVESTMENT IN AFRICA*/
SELECT TOP 10  ob.name, co.name AS country, ob.funding_total_usd
FROM objects ob
JOIN countries co
ON ob.country_code = co.country_code
WHERE co.region = 'Africa'
ORDER BY ob.funding_total_usd DESC;

/*2. IMPACT OF FOUNDER'S DEGREE ON STARTUP FUNDING ROUNDS*/
SELECT
 (CASE
	WHEN 
	(de.degree_type LIKE ('B%') OR de.degree_type LIKE ('%BSc%') OR 
	de.degree_type LIKE ('%Bachelor%') OR de.degree_type LIKE ('JD%')  OR de.degree_type LIKE ('Juris%') OR de.degree_type LIKE ('Law%') OR de.degree_type LIKE ('%Degree%'))THEN 'Bachelors'
	WHEN 
	(de.degree_type LIKE ('%M.%')OR de.degree_type LIKE ('%Grad%') OR de.degree_type LIKE ('%MBA%') OR de.degree_type LIKE ('%MS%') OR de.degree_type LIKE ('%MB%') OR de.degree_type LIKE ('%Master%')) THEN 'Masters' 
    WHEN 
	(de.degree_type LIKE ('%Ph%')OR de.degree_type LIKE ('%Phil%') OR de.degree_type LIKE ('%Doctor%')OR de.degree_type LIKE ('D.%')) THEN 'Ph.D'
	WHEN 
	(de.degree_type LIKE ('%Dip%')) THEN 'Diploma'
	ELSE 'Others'
	END) AS degree_type,
COUNT((CASE
	WHEN 
	(de.degree_type LIKE ('B%') OR de.degree_type LIKE ('%BSc%') OR 
	de.degree_type LIKE ('%Bachelor%') OR de.degree_type LIKE ('JD%')  OR de.degree_type LIKE ('Juris%') OR de.degree_type LIKE ('Law%') OR de.degree_type LIKE ('%Degree%'))THEN 'Bachelors'
	WHEN 
	(de.degree_type LIKE ('%M.%')OR de.degree_type LIKE ('%Grad%') OR de.degree_type LIKE ('%MBA%') OR de.degree_type LIKE ('%MS%') OR de.degree_type LIKE ('%MB%') OR de.degree_type LIKE ('%Master%')) THEN 'Masters' 
    WHEN 
	(de.degree_type LIKE ('%Ph%')OR de.degree_type LIKE ('%Phil%') OR de.degree_type LIKE ('%Doctor%')OR de.degree_type LIKE ('D.%')) THEN 'Ph.D'
	WHEN 
	(de.degree_type LIKE ('%Dip%')) THEN 'Diploma'
	ELSE 'Others'
	END)) AS no_of_founders,
SUM(ob.funding_total_usd) total_funding_generated,
SUM(ob.funding_rounds) AS no_of_funding_rounds,
SUM(ob.funding_total_usd)/NULLIF(COUNT((CASE
	WHEN 
	(de.degree_type LIKE ('B%') OR de.degree_type LIKE ('%BSc%') OR 
	de.degree_type LIKE ('%Bachelor%') OR de.degree_type LIKE ('JD%')  OR de.degree_type LIKE ('Juris%') OR de.degree_type LIKE ('Law%') OR de.degree_type LIKE ('%Degree%'))THEN 'Bachelors'
	WHEN 
	(de.degree_type LIKE ('%M.%')OR de.degree_type LIKE ('%Grad%') OR de.degree_type LIKE ('%MBA%') OR de.degree_type LIKE ('%MS%') OR de.degree_type LIKE ('%MB%') OR de.degree_type LIKE ('%Master%')) THEN 'Masters' 
    WHEN 
	(de.degree_type LIKE ('%Ph%')OR de.degree_type LIKE ('%Phil%') OR de.degree_type LIKE ('%Doctor%')OR de.degree_type LIKE ('D.%')) THEN 'Ph.D'
	WHEN 
	(de.degree_type LIKE ('%Dip%')) THEN 'Diploma'
	ELSE 'Others'
	END)),0) AS funding_per_degree
from degrees de
JOIN relationships re
ON de.object_id = re.person_object_id
JOIN objects ob
ON re.relationship_object_id =ob.object_id
WHERE re.title LIKE '%Founder%'
GROUP BY( (CASE
	WHEN 
	(de.degree_type LIKE ('B%') OR de.degree_type LIKE ('%BSc%') OR 
	de.degree_type LIKE ('%Bachelor%') OR de.degree_type LIKE ('JD%')  OR de.degree_type LIKE ('Juris%') OR de.degree_type LIKE ('Law%') OR de.degree_type LIKE ('%Degree%'))THEN 'Bachelors'
	WHEN 
	(de.degree_type LIKE ('%M.%')OR de.degree_type LIKE ('%Grad%') OR de.degree_type LIKE ('%MBA%') OR de.degree_type LIKE ('%MS%') OR de.degree_type LIKE ('%MB%') OR de.degree_type LIKE ('%Master%')) THEN 'Masters' 
    WHEN 
	(de.degree_type LIKE ('%Ph%')OR de.degree_type LIKE ('%Phil%') OR de.degree_type LIKE ('%Doctor%')OR de.degree_type LIKE ('D.%')) THEN 'Ph.D'
	WHEN 
	(de.degree_type LIKE ('%Dip%')) THEN 'Diploma'
	ELSE 'Others'
	END))
ORDER BY degree_type;

/*2a. FOUNDER WITH THE MOST FUNDING ROUND*/

SELECT CONCAT(po.last_name, ' ', po.first_name) AS full_name, de.institution, re.title, ob.name, ob.funding_rounds
FROM people po
INNER JOIN degrees de
ON po.object_id = de.object_id
INNER JOIN relationships re
ON de.object_id = re.person_object_id
INNER JOIN objects ob
ON re.relationship_object_id = ob.object_id
WHERE re.title LIKE('Founder%')
ORDER BY ob.funding_rounds DESC;

/*2b. NUMBER OF FOUNDER THAT GRADUATED FROM UNIVERSITY FROM RESULT ABOVE (UNIVERSITY OF MICHIGAN)*/
SELECT DISTINCT CONCAT(po.last_name, ' ', po.first_name) AS full_name, 
de.institution, 
re.title, 
ob.name,
ob.funding_rounds,
ob.funding_total_usd
FROM people po
INNER JOIN degrees de
ON po.object_id = de.object_id
INNER JOIN relationships re
ON de.object_id = re.person_object_id
INNER JOIN objects ob
ON ob.object_id = re.relationship_object_id
INNER JOIN ipos ip
ON re.relationship_object_id = ip.object_id
WHERE re.title LIKE('Founder%') AND de.institution = 'University of Michigan';

/*3a. COUNTRIES WITH THE MOST STARTUPS */
SELECT TOP 1 co.name  AS country, COUNT(co.name) AS no_of_startups, 
SUM(ob.funding_total_usd) AS total_fund_recieved
FROM [dbo].[countries] co
JOIN
[dbo].[objects] ob
ON co.country_code = ob.country_code
GROUP BY co.name
ORDER BY no_of_startups DESC;

/*3b. COUNTRIES WITH THE MOST STARTUPS */
SELECT TOP 1 co.region, COUNT(co.region) AS no_of_startups, 
SUM(ob.funding_total_usd) AS total_fund_recieved
FROM [dbo].[countries] co
JOIN
[dbo].[objects] ob
ON co.country_code = ob.country_code
GROUP BY co.region
ORDER BY no_of_startups DESC;

/*4. STARTUP WITH THE MOST FUNDING ROUND*/
SELECT ob.name AS startup_name, ob.funding_rounds, CONCAT(po.last_name, ' ', po.first_name) AS founders_name, re.title
FROM objects ob
JOIN relationships re
ON ob.object_id = re.relationship_object_id
JOIN people po
ON re.person_object_id = po.object_id
WHERE re.title LIKE '%Founder%'
ORDER BY ob.funding_rounds DESC;