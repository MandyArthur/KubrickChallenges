--SELECT * FROM  [kub_lf].[dbo].[CleanTransaction]
; WITH leadnLage
AS 
(
SELECT * , 
LEAD([transDate]) OVER (PARTITION BY account_id ORDER BY [transDate] asc) as LeadtransDateByClient
	,LAG([transDate]) OVER (PARTITION BY account_id ORDER BY [transDate] asc) as LagtransDateByClient
FROM [kub_lf].[dbo].[CleanTransaction]
WHERE type = 'CREDIT'
--and account_id = '8316'

), longestConsSpree
AS
(
SELECT
--*, 
transDate,
account_id, 

--datediff(dd, LagtransDateByClient, LeadtransDateByClient) as duration_days, 
SUM(datediff(dd, LagtransDateByClient, LeadtransDateByClient)) OVER (PARTITION BY account_id Order by amount) LongestConsecutiveSpree, 
LagtransDateByClient, LeadtransDateByClient
FROM leadnLage
WHERE datediff(dd, LagtransDateByClient, LeadtransDateByClient) = 1
--ORDER BY LongestConsecutiveSpree desc -- acc 8316 14 days back to back 
)
SELECT DISTINCT
--l.account_id,
--d.client_id,
CASE 
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 20 THEN 10
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 30 THEN 20
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 40 THEN 30
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 50  THEN 40
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 60  THEN 50
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 70  THEN 60
		 WHEN datediff(year,c.date_of_birth,l.transDate) <  80 THEN 70
		 WHEN datediff(year,c.date_of_birth,l.transDate) <  90 THEN 80
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 100 THEN 90
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 110 THEN 100
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 120 THEN 110
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 130  THEN 120
			ELSE 
			0
		END agebins,
SUM(l.LongestConsecutiveSpree) OVER (PARTITION BY  
--(LongestConsecutiveSpree - avg(LongestConsecutiveSpree) over ())/ (STDEV(LongestConsecutiveSpree) OVER()) as outlierScore,
--	max(LongestConsecutiveSpree) OVER (PARTITION BY [transDate]) maxDaysPerClient,
CASE 
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 20 THEN 10
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 30 THEN 20
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 40 THEN 30
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 50  THEN 40
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 60  THEN 50
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 70  THEN 60
		 WHEN datediff(year,c.date_of_birth,l.transDate) <  80 THEN 70
		 WHEN datediff(year,c.date_of_birth,l.transDate) <  90 THEN 80
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 100 THEN 90
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 110 THEN 100
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 120 THEN 110
		 WHEN datediff(year,c.date_of_birth,l.transDate) < 130  THEN 120
			ELSE 
			0
		END) as ClientageBins
	INTO dbo.StDevCalsNew
FROM longestConsSpree l
JOIN [kub_lf].[dbo].[disp] d ON d.account_id = l.account_id
JOIN [kub_lf].[dbo].[CleanClientDetails] c ON d.client_id = c.client_id
WHERE d.type = 'OWNER'
--ORDER BY LongestConsecutiveSpree desc
-- Longest SPree by client in age bin 50 