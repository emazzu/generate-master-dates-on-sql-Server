--procedure [dbo].[generate_master_Dates]
--@w_var_desde datetime, @w_var_hasta datetime
--as

set dateformat ymd
set datefirst 1
set nocount on


declare @w_var_desde datetime
declare @w_var_hasta datetime

set @w_var_desde = '19900101'
set @w_var_hasta = '20150630'

--delete dbo.Master_Dates

if not exists (select Name from dbo.sysObjects where Name = 'Master_Dates')
begin
		CREATE TABLE [dbo].[Master_Dates](
			[mDate]		datetime NOT NULL,
			[mPeriod]	datetime NOT NULL,
			[mYear]		int NOT NULL,
			[mMonth]	int NOT NULL,
			[mDay]		int NOT NULL,
			[mQuarter]	int NOT NULL,
		 CONSTRAINT [PK_Master_Dates] PRIMARY KEY NONCLUSTERED 
		(
			[mDate] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
		) ON [PRIMARY]
end

declare @w_date datetime

while @w_var_desde <= @w_var_hasta 
begin 
            
	set @w_date =  @w_var_desde 

	SELECT @w_var_desde = @w_var_desde + 1

	if not exists (select mDate from dbo.Master_Dates where mDate = convert(date, @w_date))
	begin
		insert into dbo.Master_Dates (mDate, mPeriod, mYear, mMonth, mDay, mQuarter)
		select	convert(date, @w_date), 
				convert(date, @w_date - DAY(@w_date) + 1), 
				DATEPART (yyyy, @w_date), 
				DATEPART (mm, @w_date), 
				DATEPART (dd, @w_date), 
				DATEPART (q, @w_date)
	end
						
end
GO
