/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT [loan_id]
--      ,[account_id]
--      ,[loanGrantedOn]
--      ,[amountOfloan]
--      ,[loanDuration]
--      ,[monthlyPayments]
--      ,[loanStatus]
--  FROM [kub_lf].[dbo].[CleanLoanDetails]


-----------------------------------------------------
; WITH clientLoanDetails
AS (
  SELECT DISTINCT
  c.client_id, 
  c.date_of_birth,
  l.[amountOfLoan], 
  [loan_id],
  loanGrantedOn, 
 -- SUM(l.[amountOfLoan]) OVER (PARTITION BY c.client_id) as totalLoanPerClient, 
  CASE 
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 20 THEN 10
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 30 THEN 20
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 40 THEN 30
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 50  THEN 40
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 60  THEN 50
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 70  THEN 60
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) <  80 THEN 70
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) <  90 THEN 80
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 100 THEN 90
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 110 THEN 100
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 120 THEN 110
		 WHEN datediff(year,[date_of_birth], [loanGrantedOn]) < 130  THEN 120
			ELSE 
			-1
		END ageBins
   FROM [kub_lf].[dbo].[CleanLoanDetails] l
 JOIN  [kub_lf].[dbo].[disp] d ON d.account_id = l.account_id 
JOIN [kub_lf].[dbo].[CleanClientDetails] c ON d.client_id = c.client_id
WHERE d.type LIKE 'Own%'
  
  ) 
  SELECT DISTINCT
ageBins, 
   AVG([amountOfLoan]) OVER (Partition BY ageBins) AvgLoanPerAgeGroup
  FROM clientLoanDetails
  ORDER BY AvgLoanPerAgeGroup desc
 















	-----------------------------------------------------
; WITH clientLoanDetails
AS (
  SELECT DISTINCT
  c.client_id, 
  --l.[amountOfLoan], 
  [loan_id], 
  SUM(l.[amountOfLoan]) OVER (PARTITION BY c.client_id) as totalLoanPerClient


   FROM [kub_lf].[dbo].[CleanLoanDetails] l
  FULL OUTER JOIN  dbo.account a ON a.account_id = l.account_id 
  JOIN [kub_lf].[dbo].[CleanClientDetails] c ON c.district_id = a.district_id
  
  ) , ClientAge
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
  ca.ageBins,

  SUM(totalLoanPerClient) OVER (PARTITION BY  
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
			END) as totalLoanPerAgeGroup
	FROM ClientAge ca
	INNER JOIN clientLoanDetails cld on cld.client_id = ca.client_id
	ORDER BY totalLoanPerAgeGroup desc