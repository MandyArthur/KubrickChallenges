--/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP 1000 [CaseReference]
--      ,[CaseStartDate]
--      ,[postCode]
--      ,[DecisionTargetDate]
--      ,[DecisionDate]
--      ,[Decision]
--      ,[DecisionType]
--      ,[AppealDecision]
--      ,[ServiceTypeLabel]
--      ,[postcodeBin]
--      ,[decisionDuration]
--  FROM [MKPlanning].[dbo].[AppealDecesion]

;WITH
someyj
as
(
     SELECT DISTINCT
  AVG(decisionDuration) OVER(PARTITION BY(CaseReference)) avgDurationDecPostCode ,
	COUNT(*) OVER(PARTITION BY(CaseReference)) AmountOfTimesAppealed, 
	postcodeBin,
	Decision
	  FROM [MKPlanning].[dbo].[CLEANBINDURPlanning]
	  
)
SELECT distinct
AVG(avgDurationDecPostCode) OVER(PARTITION BY(Decision) , (postcodeBin ))  avgDurationPostcode,
--AVG(AmountOfTimesAppealed) OVER(PARTITION BY(postcodeBin)) avgAmountOfTimesAppealed, 
postcodeBin,
	Decision
		INTO final
	FROM someyj

	ORDER BY avgDurationPostcode


-- everyone only appealed once but on average Area 15 took the longest and was refused, area 12 took the longest to approve, area 9 & 5 took teh shorest to refuse and approve