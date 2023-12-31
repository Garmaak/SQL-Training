/*
Created by:		Ganiu for Garmaak
Created on:		07-01-2024
Last updated:	date ranges added by G on 01-01-2023
Purpose:		for order details summary report.
*/

CREATE PROC [restaurant].[spWaitersOrdersSummary_DynamicQuery]
--declare parameters
(@category VARCHAR(50) = NULL
, @waitersName NVARCHAR(100) = NULL
, @numberOfOrders_From INT = NULL
, @numberOfOrders_To INT = NULL)
AS
BEGIN
	DECLARE @sqlQuery NVARCHAR(MAX);

	SET @sqlQuery = '
		SELECT *
			, ([TOTAL - PRICE (£)]/[NUMBER OF ORDERS]) AS [AVERAGE - PRICE (£)] FROM
			(SELECT CATEGORY
				, [WAITER’S NAME]
				, SUM([PRICE (£)]) AS [TOTAL - PRICE (£)]
				, COUNT([ORDER ID]) AS [NUMBER OF ORDERS]
			FROM [restaurant].[vOrderDetails]
			WHERE CATEGORY IS NOT NULL
			GROUP BY CATEGORY, [WAITER’S NAME]
			) a
		WHERE 1 = 1'

	--if value for category is supplied
	IF @category IS NOT NULL
	BEGIN
		SET @sqlQuery = @sqlQuery + ' AND CATEGORY = ' + QUOTENAME(@category, '''');
	END;

	--if value for waietr's name is supplied
	IF @waitersName IS NOT NULL
	BEGIN
		SET @sqlQuery = @sqlQuery + ' AND [WAITER’S NAME] = ' + QUOTENAME(@waitersName, '''');
	END;

	--if only value for number of orders FROM is supplied
	IF @numberOfOrders_From IS NOT NULL AND @numberOfOrders_To IS NULL
	BEGIN
		SET @sqlQuery = @sqlQuery + ' AND [NUMBER OF ORDERS] >= ' + CONVERT(VARCHAR, @numberOfOrders_From);
	END;

	--if only value for number of orders TO is supplied
	IF @numberOfOrders_From IS NULL AND @numberOfOrders_To IS NOT NULL
	BEGIN
		SET @sqlQuery = @sqlQuery + ' AND [NUMBER OF ORDERS] <= ' + CONVERT(VARCHAR, @numberOfOrders_To);
	END;

	--if values are supplied for both number of orders FROM/TO
	IF @numberOfOrders_From IS NOT NULL AND @numberOfOrders_To IS NOT NULL
	BEGIN
		SET @sqlQuery = @sqlQuery + ' AND [NUMBER OF ORDERS] BETWEEN ' + 
										CONVERT(VARCHAR, @numberOfOrders_From) +  ' AND ' + CONVERT(VARCHAR, @numberOfOrders_To);
	END;

	--add the order by clause to the statement
	SET @sqlQuery = @sqlQuery + ' ORDER BY [NUMBER OF ORDERS], [WAITER’S NAME], [TOTAL - PRICE (£)]';

	PRINT(@sqlQuery);
END;