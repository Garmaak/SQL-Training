SELECT [ORDER ID]
	, [ITEM NAME]
	, [CATEGORY]
	, [PRICE (£)]
	, [ORDER DATE & TIME]
	, [ORDER DELIVERED]
	, [WAITER’S NAME]
	--convert WaitersStartDate_SQL to date format 'dd/MM/yyyy as per requirement
	, CONVERT(VARCHAR, [WaitersStartDate_SQL], 103) AS [WAITER’S START DATE]
	, [WAITER’S EMAIL ADDRESS]
	, [WAITER’S PHONE NUMBER]
	, [WAITER RETIRED]
	--get the difference between two dates and use DAY as the interval
	--the date diff wil return integer in days because of DAY 
	, CASE
		WHEN [WAITER RETIRED] = 'Y' THEN DATEDIFF(DAY, [WAITER’S RETIRED DATE], GETDATE())
		ELSE NULL
	END AS [DAYS SINCE WAITER RETIRED]
	--if waiter retired is 'N' THEN return the difference between WaitersStartDate_SQL and current date in months
	--else return the difference between WaitersStartDate_SQL and waietr's retired date in months
	, CASE
		WHEN [WAITER RETIRED] = 'N' THEN DATEDIFF(MONTH, CONVERT(DATE, WaitersStartDate_SQL), CONVERT(DATE, GETDATE()))
		ELSE DATEDIFF(MONTH, CONVERT(DATE, WaitersStartDate_SQL), [WAITER’S RETIRED DATE]) 
	END AS [MONTHS SINCE WAITER STARTED]
	--if waiter retired is 'N' THEN return the difference between WaitersStartDate_SQL and current date in years
	--else return the difference between WaitersStartDate_SQL and waietr's retired date in years
	, CASE
		WHEN [WAITER RETIRED] = 'N' THEN DATEDIFF(YEAR, CONVERT(DATE, WaitersStartDate_SQL), CONVERT(DATE, GETDATE()))
		ELSE DATEDIFF(YEAR, CONVERT(DATE, WaitersStartDate_SQL), [WAITER’S RETIRED DATE]) 
	END AS [WAITER’S YEARS OF SERVICE]
	, [WAITER’S WINDOWS LOGIN]
	, Retired
	, Datetime_Retired
	, [WaitersStartDate_SQL] FROM
	--select * from the initial code and derive [WAITER’S RETIRED DATE], so it can be selected as a column in the code above
	(SELECT *, 
			--if waiter retired is 'Y' AND datetime retired is NOT populated THEN '2023-07-30'
			--if waiter retired is 'Y' AND datetime retired is populated THEN convert  datetime retired to date data type
			CASE
				WHEN [WAITER RETIRED] = 'Y' AND Datetime_Retired IS NULL THEN '2023-07-30'
				WHEN [WAITER RETIRED] = 'Y' AND Datetime_Retired IS NOT NULL THEN CONVERT(DATE, Datetime_Retired)
				ELSE NULL
			END AS [WAITER’S RETIRED DATE] FROM
		(SELECT orders.orderID AS [ORDER ID]								
			, menu.itemName AS [ITEM NAME]									
			, menu.category AS CATEGORY									
			, menu.price AS [PRICE (£)]
			--convert order date & time to string values, join both values together with '_' to separate them
			, CONCAT(CONVERT(VARCHAR, orders.orderDate, 103), '_', CONVERT(VARCHAR, orders.orderTime, 8)) AS [ORDER DATE & TIME]
			--use ISNULL() to ensure that NULLs will be treated as FALSE (0), then if ordered delivered is 1 then return 'Y', else 'N'
			, IIF(ISNULL(orders.orderDelivered, 0) = 1, 'Y', 'N') AS [ORDER DELIVERED]
			--concatenate/join first and late names together
			, CONCAT(w.First_Name, ' ' , w.Last_Name) AS [WAITER’S NAME]
			, CASE
				--if Start_Date's pattern is 'DD/MM/YYYY'
				WHEN PATINDEX('%[0-3][0-9]/[0-1][0-9]/[1-2][89][0-9][0-9]%', w.[Start_Date]) = 1 THEN
					CONVERT(DATE, CONCAT(RIGHT(w.[Start_Date], 4), '-', SUBSTRING(w.[Start_Date], 4, 2), '-', LEFT(w.[Start_Date], 2)))
				--if Start_Date's starts with 2 numbers, a space, then letters that starts with any of [JFMASOND], another space add 4 numbers
				WHEN PATINDEX('[0-3][0-9] [JFMASOND][a-z]% [1-2][89][0-9][0-9]', w.[Start_Date]) = 1 THEN
					CONVERT(DATE, w.[Start_Date])
				--if Start_Date does not match any of the 2 patterns above, return NULL value
				ELSE NULL
			END AS WaitersStartDate_SQL
			, CASE
				--if @ symbol's position is greater than zero then email address
				WHEN CHARINDEX('@', w.Email_Address, 1) > 0 THEN w.Email_Address
				--else return 'Unknown'
				ELSE 'Unknown'
			END AS [WAITER’S EMAIL ADDRESS]
			, CASE
				--if @ symbol's position is greater than zero then email address
				WHEN ISNUMERIC(LEN(REPLACE(w.Phone_Number, ' ', ''))) = 1  THEN w.Phone_Number
				--else return 'Unknown'
				ELSE 'Unknown'
			END AS [WAITER’S PHONE NUMBER]
			, CASE
				--if retired is 'TRUE', 'YES' or 'Y' return 'Y'
				WHEN TRIM(w.Retired) IN ('TRUE', 'YES', 'Y') THEN 'Y'
				--if retired is 'FALSE', 'N' or 'N' return 'N'
				WHEN TRIM(w.Retired) IN ('FALSE', 'NO', 'N') THEN 'N'
				--if datetime retired is populated and is date return 'Y'
				WHEN ISDATE(w.Datetime_Retired) = 1 THEN 'Y'
				--else return 'N'
				ELSE 'N'
			END AS [WAITER RETIRED]
			--select the first non-null value between last and first names, get the first letter
			--concatenate/join letter to waiter's id
			, CONCAT(LOWER(LEFT(COALESCE(w.Last_Name, w.First_Name), 1)), w.ID) AS [WAITER’S WINDOWS LOGIN]
			, Retired
			, Datetime_Retired FROM								
			restaurant.tblOrderDetails orders										
			LEFT JOIN									
			restaurant.tblMenuItems menu								
			ON orders.menuItemID = menu.ID
			LEFT JOIN
			restaurant.tblOrdersAndWaiters oWaiters
			ON orders.orderID = oWaiters.Order_ID
			LEFT JOIN
			restaurant.tblWaiters w
			ON oWaiters.Waiters_ID = w.ID
		) a
	)b
ORDER BY [ORDER ID], [ITEM NAME], CATEGORY