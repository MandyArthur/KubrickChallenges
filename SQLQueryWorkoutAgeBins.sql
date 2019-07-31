/****** Script for SelectTopNRows command from SSMS  ******/


SELECT [loan_id]
      ,[account_id]
      ,[loanGrantedOn]
      ,CAST([amountOfLoan] AS FLOAT) amountOfloan
      ,[loanDuration]
      ,[monthlyPayments]
      ,[loanStatus]
	   INTO CleanLoanDetails
  FROM [kub_lf].[dbo].[loanDetails]
 
  ORDER BY [amountOfLoan]


    
  SELECT 
  c.client_id, 
  l.[amountOfLoan], 
  [loan_id], 
  SUM(CAST(l.[amountOfLoan] AS FLOAT)) OVER (PARTITION BY c.client_id) as totalLoanPerClient


  FROM [kub_lf].[dbo].[loanDetails] l
   JOIN dbo.account a ON a.account_id = l.account_id 
  JOIN dbo.CleanClientDetails c ON a.district_id = c.district_id
  
  ORDER BY [amountOfLoan]



  ; WITH ClientAge
AS 
(
  SELECT 
   client_id, 
   [date_of_birth]
  , datediff(year,[date_of_birth], getdate()) as age
,
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
  FROM [kub_lf].[dbo].[CleanClientDetails]
  )
  SELECT DISTINCT
  ageBins,
  client_id,
  COUNT(*) OVER (PARTITION BY  
  	CASE 
		 WHEN age < 10 THEN 0	
		 WHEN age < 20 THEN 10
		 WHEN age < 30 THEN 20
		 WHEN age < 40 THEN 30
		 WHEN age < 50  THEN 40
		 WHEN age < 60  THEN 50
		 WHEN age < 70  THEN 60
		 WHEN age <  80 THEN 70
		 WHEN age <  90 THEN 80
		 WHEN age < 100 THEN 90
		 WHEN age < 110 THEN 100
		 WHEN age < 120 THEN 110
		 WHEN age < 130  THEN 120
			ELSE 
			0
			END) as ageBinsSome
	FROM ClientAge
	ORDER BY ageBins