/*
Created by:	Ganiu for Garmaak
Created on:	01-01-2024
Last updated:	
Purpose:		to fix data quality issues and transformation of tblWaiters

*/

CREATE VIEW [restaurant].[vWaiter]
AS
	SELECT *	
		, CASE
			WHEN [WAITER RETIRED] = 'Y' THEN DATEDIFF(DAY, [WAITER�S RETIRED DATE], GETDATE())
			ELSE NULL
			END AS [DAYS SINCE WAITER RETIRED] 
		, CASE
			WHEN [WAITER RETIRED] = 'N' THEN DATEDIFF(MONTH, CONVERT(DATE, WaitersStartDate_SQL), CONVERT(DATE, GETDATE()))
			ELSE DATEDIFF(MONTH, CONVERT(DATE, WaitersStartDate_SQL), [WAITER�S RETIRED DATE]) 
		END AS [MONTHS SINCE WAITER STARTED]
		, CASE
			WHEN [WAITER RETIRED] = 'N' THEN DATEDIFF(YEAR, CONVERT(DATE, WaitersStartDate_SQL), CONVERT(DATE, GETDATE()))
			ELSE DATEDIFF(YEAR, CONVERT(DATE, WaitersStartDate_SQL), [WAITER�S RETIRED DATE]) 
		END AS [WAITER�S YEARS OF SERVICE] FROM
		(SELECT *
		--[WAITER�S RETIRED DATE]
			, CASE
				WHEN [WAITER RETIRED] = 'Y' AND Datetime_Retired IS NULL THEN '2023-07-30'
				WHEN [WAITER RETIRED] = 'Y' AND Datetime_Retired IS NOT NULL THEN CONVERT(DATE, Datetime_Retired)
				ELSE NULL
			END AS [WAITER�S RETIRED DATE] FROM
		--the derived columns we need to derive [MONTHS SINCE WAITER STARTED]	
			(SELECT *
			--WaitersStartDate_SQL
				, CASE
					WHEN PATINDEX('[0-3][0-9]/[0-1][0-9]/[1-2][89][0-9][0-9]', [Start_Date]) = 1 THEN
						CONVERT(DATE, CONCAT(RIGHT([Start_Date], 4), '-', SUBSTRING([Start_Date], 4, 2), '-', LEFT([Start_Date], 2)))
					WHEN PATINDEX('[0-3][0-9] [JFMASOND][a-z]% [1-2][89][0-9][0-9]', [Start_Date]) = 1 THEN
						CONVERT(DATE, [Start_Date])
					ELSE NULL
				END AS WaitersStartDate_SQL
			--[WAITER RETIRED]
				, CASE
					WHEN TRIM(Retired) IN ('TRUE', 'YES', 'Y') THEN 'Y'
					WHEN TRIM(Retired) IN ('FALSE', 'NO', 'N') THEN 'N'
					WHEN ISDATE(Datetime_Retired) = 1 THEN 'Y'
					ELSE 'N'
				END AS [WAITER RETIRED]
			FROM restaurant.tblWaiters
		) tbl
	) v
GO

