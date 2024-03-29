/****** Script for SelectTopNRows command from SSMS  ******/
; WITH CleanCTE
AS
(
SELECT 
	  [CaseReference]
      ,CAST([CaseDate] AS DATE) CaseStartDate
      --,[LocationText]
	  ,LtRIM(cast(RIGHT([LocationText],9) AS varchar(10))) AS postCode
      ,CAST([DecisionTargetDate] AS DATE) DecisionTargetDate
      
      ,CAST([DecisionDate]AS DATE) DecisionDate
      ,[Decision]
      ,[DecisionType]
      ,[AppealDecision]
 ,[ServiceTypeLabel]

  FROM [MKPlanning].[dbo].[PlanningDataLGASchema]
  Where [Status] = 'Decided' and ([Decision] = 'Approve' OR [Decision] = 'Refuse')
  ) 
  SELECT * 
  INTO CLEANPlanningDataMK
  FROM CleanCTE
 
  WHERE postCode LIKE 'MK%'