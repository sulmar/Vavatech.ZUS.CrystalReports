
-- parametry wejsciowe
declare @starttime time = '07:00:00'
declare @stoptime time = '18:00:00'
declare @delta int = 20
declare @date datetime = '2019-05-31'


-- zmienne robocze
declare @q int = DATEDIFF(second, 0, @starttime) / @delta

declare @datetime datetime =  @date + cast(@starttime as datetime)




-- select DATEDIFF(s, @starttime, @stoptime) / @delta

declare @start int = 1
declare @end   int = DATEDIFF(s, @starttime, @stoptime) / @delta

;with numcte  
AS  
(  
  SELECT @start slot  
  UNION all  
  SELECT slot + 1 FROM numcte WHERE slot < @end 
),
mycalls as (SELECT 
	c.LineId,
	c.StartTime,
	DATEDIFF(SECOND, CONVERT(DATE,@datetime), c.StartTime) / @delta - @q as slotstart,
	c.StopTime,
	DATEDIFF(SECOND, CONVERT(DATE,@datetime), c.StopTime) / @delta - @q as slotstop
from
	Calls as c ),
lines as (select Distinct LineId from Calls)
     
SELECT slot,
lineid,
	(select count(*) from mycalls  as c
		where slot >= c.slotstart 
		and slot <= c.slotstop
		 and c.LineId = lines.LineId
		) as quantity
FROM numcte, lines option (maxrecursion 0)


-- select * from vwCalls