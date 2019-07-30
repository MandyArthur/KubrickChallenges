-- find outlier using stdev 
-- USED LAG & LEAD INSTEAD OF MIN & MAX 

-- Client ID 4915 has the highest std deviation therefore, outlier
; WITH allClientTrans
AS 
(
  SELECT DISTINCT
	t.trans_id,
	t.account_id,
	c.client_id,
	c.[date_of_birth],
	--lag & lead 
	LEAD([transDate]) OVER (PARTITION BY t.account_id ORDER BY c.client_id asc) as LeadtransDateByClient
	,LAG([transDate]) OVER (PARTITION BY t.account_id ORDER BY c.client_id desc) as LagtransDateByClient
 FROM [kub_lf].[dbo].[CleanTransaction] t
 INNER JOIN [kub_lf].[dbo].[disp] d ON d.account_id = t.account_id
 INNER JOIN [kub_lf].[dbo].[CleanClientDetails] c ON c.client_id = d.client_id
 WHERE t.Operation LIKE '%withdrawal'

), transDurations
AS
( 
SELECT  
	account_id,
	trans_id,
	client_id,
	[date_of_birth],
	LeadtransDateByClient,
	LagtransDateByClient,
	datediff(dd, LeadtransDateByClient, LagtransDateByClient) as transDuration
FROM allClientTrans
WHERE LagtransDateByClient IS NOT NULL

)
, maxdaysClient
AS 
(
SELECT DISTINCT
	trans_id,
	client_id,
	(transDuration - avg(transDuration) over ())/ (STDEV(transDuration) OVER()) as outlierScore,
	max(transDuration) OVER (PARTITION BY transDuration) maxDaysPerClient
	
	FROM transDurations

)
SELECT DISTINCT

client_id,
maxDaysPerClient,
outlierScore,
DENSE_RANK() OVER(ORDER BY maxDaysPerClient desc) as rnks
FROM maxdaysClient
	ORDER BY rnks
