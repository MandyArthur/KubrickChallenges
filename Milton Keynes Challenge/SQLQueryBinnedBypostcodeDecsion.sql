/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [CaseReference]
      ,[CaseStartDate]
      ,[postCode]
      ,[DecisionTargetDate]
      ,[DecisionDate]
      ,[Decision]
      ,[DecisionType]
      ,[AppealDecision]
      ,[ServiceTypeLabel]
      ,[postcodeBin]
      ,[decisionDuration]
  FROM [MKPlanning].[dbo].[CLEANBINDURPlanning]

    SELECT DISTINCT
  AVG(decisionDuration) OVER(PARTITION BY(Decision) , (postcodeBin )) avgDurationDecPostCode ,
	COUNT(*) OVER(PARTITION BY(Decision) , (postcodeBin )) decisionCount, 
	postcodeBin,
	Decision
	  FROM [MKPlanning].[dbo].[CLEANBINDURPlanning]
	  Order BY postcodeBin