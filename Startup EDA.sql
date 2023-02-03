USE startup_db;

/*I. STARTUPS PER ENTITIES AND TOTAL FUNDING RECEIVED*/

SELECT 
	entity_type AS startup_type, 
COUNT(entity_type) AS no_of_startups, 
SUM(funding_total_usd) AS total_funding 
FROM dbo.objects
GROUP BY entity_type;

/*II.	STARTUPS CREATION TIME SERIES ANALYSIS*/

SELECT 
FORMAT(founded_at, 'yyyy') AS year_founded,
COUNT(name) AS no_of_startups, 
SUM(funding_total_usd) AS funding_attracted
FROM [dbo].[objects]
WHERE entity_type != 'Person'
GROUP BY FORMAT(founded_at, 'yyyy')
ORDER BY FORMAT(founded_at, 'yyyy') ASC;

/*III.	ACQUISITION TIME SERIES ANALYSIS*/

SELECT 
FORMAT(acquired_at, 'yyyy') AS acquisition_year,
COUNT(acquiring_object_id) AS total_startups_acquired, 
SUM(price_amount) AS acquisition_value
FROM [dbo].[acquisitions]
GROUP BY FORMAT(acquired_at, 'yyyy')
ORDER BY FORMAT(acquired_at, 'yyyy') ASC;

/*IV. TOP ACQUISITIONS*/

SELECT 
ob.normalized_name,
COUNT(ob.normalized_name) as total_acquisitions,
SUM(ac.price_amount) as total_spent_on_acquisitions
FROM [dbo].[objects] ob
JOIN
[dbo].[acquisitions] ac
ON ob.object_id = ac.acquiring_object_id
GROUP BY ob.normalized_name
ORDER BY total_spent_on_acquisitions DESC;

/*V.	STARTUP WITH MOST FUNDING ROUNDS*/

SELECT ob.normalized_name AS startup_name, 
	COUNT(ob.normalized_name) AS no_of_rounds, 
	SUM(fr.raised_amount) AS total_funds_raised
FROM [dbo].[objects] ob
JOIN
[dbo].[funding_rounds] fr
ON fr.object_id = ob.object_id
GROUP BY ob.normalized_name
ORDER BY no_of_rounds DESC;

/*VI. TOP SUCCESSFUL ROUNDS RECORDED*/

SELECT funding_round_type, 
	COUNT(funding_round_type) AS no_of_funding_round, 
	SUM(raised_amount_usd) AS total_fund_disbursed
FROM dbo.funding_rounds
GROUP BY funding_round_type
HAVING SUM(raised_amount_usd) > 0
ORDER BY funding_round_type;

/*VII. TOP COMPANIES WITH SUCCESSFUL PUBLIC OFFERING (IPO)*/

SELECT ob.name AS company_name, 
		ip.raised_amount, 
		ip.valuation_amount
FROM [dbo].[objects] ob
JOIN [dbo].[ipos] ip
ON ob.object_id = ip.object_id
WHERE raised_amount > 0
ORDER BY raised_amount DESC;

/*VIII.  CATEGORIES OF STARTUPS WITH THE MOST FUNDING*/
SELECT ob.category_code,
	COUNT(ob.category_code) AS no_of_startups, 
	SUM(ob.funding_total_usd) AS total_funds_recieved,
	MAX(ob.funding_total_usd) AS highest_funding_recieved,
	SUM(ob.funding_total_usd)/NULLIF(COUNT(ob.category_code),0) AS funding_per_startup
FROM [dbo].[objects] ob
GROUP BY ob.category_code
ORDER BY no_of_startups DESC;

/*IX.	TOP INNOVATIVE COUNTRIES (NUMBER OF STARTUPS) AND INNOVATION INVESTMENT DESTINATIONS*/
SELECT co.name  AS country, COUNT(co.name) AS no_of_startups, 
SUM(ob.funding_total_usd) AS total_fund_recieved
FROM [dbo].[countries] co
JOIN
[dbo].[objects] ob
ON co.country_code = ob.country_code
WHERE ob.entity_type = 'Company'
GROUP BY co.name
ORDER BY no_of_startups DESC;

/*X.   DEGREE QUALIFICATION IMPACT ON STARTUPS FUNDING*/
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
GROUP BY((CASE
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

USE startup_db;
/*XI.	TOP INNOVATIVE AFRICAN COUNTRIES*/
SELECT co.name  AS country, COUNT(co.name) AS no_of_startups, 
SUM(ob.funding_total_usd) AS total_fund_recieved
FROM [dbo].[countries] co
JOIN
[dbo].[objects] ob
ON co.country_code = ob.country_code
WHERE ob.entity_type = 'Company' AND co.Region = 'Africa'
GROUP BY co.name
ORDER BY no_of_startups DESC;

/*XII. AFRICAN COMPANIES WITH SUCCESSFUL PUBLIC OFFERING (IPO)*/

SELECT ob.name AS company_name, 
		ip.raised_amount, 
		ip.valuation_amount
FROM [dbo].[ipos] ip
JOIN [dbo].[objects] ob
ON  ip.object_id = ob.object_id
JOIN [dbo].[countries] co
ON ob.country_code = co.country_code
WHERE raised_amount > 0 AND co.region = 'Africa'
ORDER BY raised_amount DESC;

/*XIII. TOP FOUNDERS PRODUCING UNIVERSITIES */
SELECT TOP 10 de.institution, 
COUNT(de.institution) AS no_of_alumni_founders
FROM degrees de
JOIN relationships re
ON de.object_id = re.person_object_id
WHERE re.title LIKE 'Founder%'
GROUP BY de.institution
ORDER BY no_of_alumni_founders DESC;












