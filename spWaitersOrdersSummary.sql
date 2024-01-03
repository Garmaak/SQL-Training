/*
Created by:		Ganiu for Garmaak
Created on:		03-01-2024
Last updated:	date ranges added by G on 01-01-2023
Purpose:		for order details summary report.
*/

CREATE PROCEDURE restaurant.spWaitersOrdersSummary
--declare parameters
(@orderDate_From DATE = NULL
, @orderDate_To DATE = NULL)
AS
BEGIN
	--no date is selected
	IF @orderDate_From IS NULL AND @orderDate_To IS NULL
	BEGIN
		SELECT [WAITER’S NAME]
		  , SUM([PRICE (£)]) AS [TOTAL WAITED (£)]
		  , FORMAT(orderDate, 'MMM yyy') AS [ORDER DATE]
		FROM [restaurant].[vOrderDetails]
		GROUP BY [WAITER’S NAME]
			  , FORMAT(orderDate, 'MMM yyy')
		ORDER BY SUM([PRICE (£)]) DESC;
	END;
	
	--only order from date is selected
	IF @orderDate_From IS NOT NULL AND @orderDate_To IS NULL
	BEGIN
		SELECT [WAITER’S NAME]
		  , SUM([PRICE (£)]) AS [TOTAL WAITED (£)]
		  , FORMAT(orderDate, 'MMM yyy') AS [ORDER DATE]
		FROM [restaurant].[vOrderDetails]
		WHERE orderDate >= @orderDate_From
		GROUP BY [WAITER’S NAME]
			  , FORMAT(orderDate, 'MMM yyy')
		ORDER BY SUM([PRICE (£)]) DESC;
	END;
	
	--only order to date is selected
	IF @orderDate_From IS NULL AND @orderDate_To IS NOT NULL
	BEGIN
		SELECT [WAITER’S NAME]
		  , SUM([PRICE (£)]) AS [TOTAL WAITED (£)]
		  , FORMAT(orderDate, 'MMM yyy') AS [ORDER DATE]
		FROM [restaurant].[vOrderDetails]
		WHERE orderDate <= @orderDate_To
		GROUP BY [WAITER’S NAME]
			  , FORMAT(orderDate, 'MMM yyy')
		ORDER BY SUM([PRICE (£)]) DESC;
	END;
	
	--both dates are selected
	IF @orderDate_From IS NOT NULL AND @orderDate_To IS NOT NULL
	BEGIN
		SELECT [WAITER’S NAME]
		  , SUM([PRICE (£)]) AS [TOTAL WAITED (£)]
		  , FORMAT(orderDate, 'MMM yyy') AS [ORDER DATE]
		FROM [restaurant].[vOrderDetails]
		WHERE orderDate BETWEEN @orderDate_From AND @orderDate_To
		GROUP BY [WAITER’S NAME]
			  , FORMAT(orderDate, 'MMM yyy')
		ORDER BY SUM([PRICE (£)]) DESC;
	END;
END;