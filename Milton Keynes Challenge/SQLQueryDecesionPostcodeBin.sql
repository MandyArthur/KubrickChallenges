/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [CaseReference]
      ,[CaseStartDate]
      ,[postCode]
      ,[DecisionTargetDate]
      ,[DecisionDate]
      ,[Decision]
      ,[DecisionType]
      ,[AppealDecision]
      ,[ServiceTypeLabel]
      ,[postcodeBin]
  FROM [MKPlanning].[dbo].[CLEANBINNEDPlanning]

  SELECT DISTINCT
	COUNT(*) OVER(PARTITION BY(Decision) , (postcodeBin )) decisionCount, 
	postcodeBin,
	Decision
 FROM [MKPlanning].[dbo].[CLEANBINNEDPlanning]
 Order BY postcodeBin

