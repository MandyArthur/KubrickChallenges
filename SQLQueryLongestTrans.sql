--/****** Script for SelectTopNRows command from SSMS  ******/SELECT TOP 1000 [trans_id]
--      ,[account_id]
--      ,[transDate]
--      ,[type]
--      ,[operation]
--      ,[amount]
--      ,[balance]
--      ,[k_symbol]
--      ,[bank]
--  FROM [kub_lf].[dbo].[CleanTransaction]


-- CLient with the longest CC transaction is client 588 and is in ageBin 50 
; WITH allClientTrans
AS 
(
  SELECT DISTINCT
	t.trans_id,
	t.account_id,
	c.client_id,
	c.[date_of_birth],
	--lag & lead 
	min([transDate]) OVER (PARTITION BY t.account_id ORDER BY c.client_id asc) as LeadtransDateByClient
	,max([transDate]) OVER (PARTITION BY t.account_id ORDER BY c.client_id desc) as LagtransDateByClient
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
	max(transDuration) OVER (PARTITION BY transDuration) maxDaysPerClient, 
	CASE 
		 WHEN datediff(year,[date_of_birth], getdate()) < 20 THEN 10
		 WHEN datediff(year,[date_of_birth], getdate()) < 30 THEN 20
		 WHEN datediff(year,[date_of_birth], getdate()) < 40 THEN 30
		 WHEN datediff(year,[date_of_birth], getdate()) < 50  THEN 40
		 WHEN datediff(year,[date_of_birth], getdate()) < 60  THEN 50
		 WHEN datediff(year,[date_of_birth], getdate()) < 70  THEN 60
		 WHEN datediff(year,[date_of_birth], getdate()) <  80 THEN 70
		 WHEN datediff(year,[date_of_birth], getdate()) <  90 THEN 80
		 WHEN datediff(year,[date_of_birth], getdate()) < 100 THEN 90
		 WHEN datediff(year,[date_of_birth], getdate()) < 110 THEN 100
		 WHEN datediff(year,[date_of_birth], getdate()) < 120 THEN 110
		 WHEN datediff(year,[date_of_birth], getdate()) < 130  THEN 120
			ELSE 
			-1
			END as ageBins
	
	FROM transDurations

)
SELECT DISTINCT
ageBins,
client_id,
maxDaysPerClient,
DENSE_RANK() OVER(ORDER BY maxDaysPerClient desc) as rnks
FROM maxdaysClient
	ORDER BY rnks
