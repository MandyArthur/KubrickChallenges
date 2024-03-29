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
	  ,DATEDIFF(dd, [CaseStartDate], [DecisionDate]) as decisionDuration
	INTO CLEANBINDURPlanning
  FROM [MKPlanning].[dbo].[CLEANBINNEDPlanning]

  SELECT DISTINCT
  decisionDuration,
	COUNT(*) OVER(PARTITION BY(Decision) , (postcodeBin )) decisionCount, 
	postcodeBin,
	Decision
 FROM [MKPlanning].[dbo].[CLEANBINNEDPlanning]
 Order BY postcodeBin

