-- Obj: What were the total steps per day per dancer while they were at the festival

-- CTE creates fullname, and formats enddate from TEXT to DATETIME
With total_steps_per_dancer AS (
	select
		concat(firstname, " ", lastname) as fullname,
		step_count,
		str_to_date(enddate,'%m/%d/%Y %k:%i') as steps_recorded
	From steps as s
		Inner Join dancers as d
			On s.dancer_id = d.dancer_id
)

-- Query displays the total steps per day per dancer
 Select
	fullname,
    sum(step_count) as total_steps,
		Case
			When steps_recorded Between '2022-09-02 00:00' and '2022-09-02 23:59' Then 'Friday'
			When steps_recorded Between '2022-09-03 00:00' and '2022-09-03 23:59' Then 'Saturday'
			When steps_recorded Between '2022-09-04 00:00' and '2022-09-04 23:59' Then 'Sunday'
		End as festival_day
From total_steps_per_dancer
Group by fullname, festival_day With rollup -- RollUp Total Steps should match up with Dances Total Steps Query*/