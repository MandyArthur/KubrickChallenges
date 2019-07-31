

    SELECT DISTINCT
  AVG(decisionDuration) OVER(PARTITION BY(Decision) , (postcodeBin )) avgDurationDecPostCode ,
	COUNT(*) OVER(PARTITION BY(Decision) , (postcodeBin )) decisionCount, 
	postcodeBin,
	Decision
	  FROM [MKPlanning].[dbo].[CLEANBINDURPlanning]
	  Order BY postcodeBin

	 