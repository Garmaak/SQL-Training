--created on 10-01-2024 by Garnew for Garmaak Training
CREATE FUNCTION restaurant.fxnGetYearsToToday
--declare the date parameter to be supplied
(@date DATE)
--return integer
RETURNS INT
AS
BEGIN
	--declare variable and get the difference in years between supplied date and today
	DECLARE @dateDiff_Year INT = DATEDIFF(YEAR, @date, GETDATE());
	--declare variable and determine if month and day of supplied date is >= or < than today
	DECLARE @yearConfirmation INT = CASE WHEN
									--if specified date's month is greater than current date's month OR
									(MONTH(@date) > MONTH(GETDATE())) OR
									--if specified date's month equals current date's month AND day is greater then current date's day
									(MONTH(@date) = MONTH(GETDATE()) AND DAY(@date) > DAY(GETDATE())) THEN 1
									ELSE 0
								END;
	
	--declare variable and get the difference between the 2 variables above
	DECLARE @yearsToToday INT = @dateDiff_Year - @yearConfirmation;

	--return value
	RETURN @yearsToToday;
END