declare @Date_From	datetime
declare @Date_To	datetime
declare	@District	varchar(50)

set @Date_From	= '20140101' 
set @Date_To	= '20150601'
set @District	= 'cañadon seco'

select	md.Date,
		isnull(i.Action, 'No Valve Movement') Action
from
(
select	
mPeriod Date,
'(ninguno)' District,
'No Valve Movement' Action
from Master_Dates md
WHERE mPeriod BETWEEN @Date_From AND @Date_To
group by mPeriod
) md
LEFT JOIN
(
select
Date - DAY(Date) + 1 as Date,
d.Nombre,
Action
from dbo.Injection_Valves_Movement_Main v
inner join dbo.Pozos p ON p.Id = v.ID_Well
inner join dbo.maeDistritos d ON d.id = p.IDdistrito
WHERE d.Nombre IN (@District)
AND
Date - DAY(Date) + 1 BETWEEN @Date_From AND @Date_To
) i
ON i.Date = md.Date
