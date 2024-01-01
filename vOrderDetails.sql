/*
Created by:	Ganiu for Garmaak
Created on:	01-01-2024
Last updated:	
Purpose:		for order details report, see requirement XXXX in ticket flow system for more info.
*/

CREATE VIEW [restaurant].[vOrderDetails]
AS
	SELECT orders.orderID AS [ORDER ID]								
		, menu.itemName AS [ITEM NAME]									
		, menu.category AS CATEGORY									
		, menu.price AS [PRICE (£)]					
		, CONCAT(CONVERT(VARCHAR, orders.orderDate, 103), '_', CONVERT(VARCHAR, orders.orderTime, 8)) AS [ORDER DATE & TIME]	
		, IIF(ISNULL(orders.orderDelivered, 0) = 1, 'Y', 'N') AS [ORDER DELIVERED]		
		, w.[WAITER’S NAME]
		, CONVERT(VARCHAR, w.[WaitersStartDate_SQL], 103) AS [WAITER’S START DATE]
		, w.[WAITER’S EMAIL ADDRESS]
		, w.[WAITER’S PHONE NUMBER]
		, w.[WAITER RETIRED]
		, FORMAT(w.[WAITER’S RETIRED DATE], 'dd MMM yyyy') AS [WAITER’S RETIRED DATE]
		, w.[DAYS SINCE WAITER RETIRED]
		, w.[MONTHS SINCE WAITER STARTED]
		, w.[WAITER’S YEARS OF SERVICE]
		, w.[WAITER’S WINDOWS LOGIN]
		, w.[WaitersStartDate_SQL] 
		, orders.orderDate FROM								
	restaurant.tblOrderDetails orders										
	LEFT JOIN									
	restaurant.tblMenuItems menu								
	ON orders.menuItemID = menu.ID
	LEFT JOIN
	restaurant.tblOrdersAndWaiters oWaiters
	ON orders.orderID = oWaiters.Order_ID
	LEFT JOIN
	restaurant.vWaiter w
	ON oWaiters.Waiters_ID = w.ID;
GO


