/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	[CaseReference]
      ,[CaseStartDate]
      ,[postCode]
      ,[DecisionTargetDate]
      ,[DecisionDate]
      ,[Decision]
      ,[DecisionType]
      ,[AppealDecision]
      ,[ServiceTypeLabel]
	  , CASE 
	   WHEN postCode LIKE 'MK1 %' THEN 1
	   WHEN postCode LIKE 'MK2 %' THEN 2
	   WHEN postCode LIKE 'MK3 %' THEN 3
	   WHEN postCode LIKE 'MK4 %' THEN 4
	   WHEN postCode LIKE 'MK5 %' THEN 5
	   WHEN postCode LIKE 'MK6 %' THEN 6
	   WHEN postCode LIKE 'MK7 %' THEN 7
	   WHEN postCode LIKE 'MK8 %' THEN 8
	   WHEN postCode LIKE 'MK9 %' THEN 9
	   WHEN postCode LIKE 'MK10%' THEN 10
	   WHEN postCode LIKE 'MK11%' THEN 11
	   WHEN postCode LIKE 'MK12%' THEN 12
	   WHEN postCode LIKE 'MK13%' THEN 13
	   WHEN postCode LIKE 'MK14%' THEN 14
	   WHEN postCode LIKE 'MK15%' THEN 15
	   WHEN postCode LIKE 'MK16%' THEN 16
	   WHEN postCode LIKE 'MK17%' THEN 17
	   WHEN postCode LIKE 'MK18%' THEN 18
	   WHEN postCode LIKE 'MK19%' THEN 19
	   WHEN postCode LIKE 'MK40%' THEN 40
	   WHEN postCode LIKE 'MK41%' THEN 41
	   WHEN postCode LIKE 'MK42%' THEN 42
	   WHEN postCode LIKE 'MK43%' THEN 43
	   WHEN postCode LIKE 'MK44%' THEN 44
	   WHEN postCode LIKE 'MK45%' THEN 45
	   WHEN postCode LIKE 'MK46%' THEN 46
	   WHEN postCode LIKE 'MK77%' THEN 77
	   END postcodeBin
	INTO CLEANBINNEDPlanning
  FROM [MKPlanning].[dbo].[CLEANPlanningDataMK]