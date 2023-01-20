/* The following was executed to produce the Dance+ Data Model:
	1) CTE 'dates_combined':
		a) Join tables set_times & sets_attended
        	b) combines set_time dates and time of the artist(s) performance (Start & End)
        	c) Change datatype from text to date (Start & End)
	2) CTE 'dancers_settimes':
		a) Uses CTE 'dates_combined'
        	b) Converts combined sets date and time (Start & End) into 24-hour time
        	c) Change datatype again to reflect 24-hour time
        	d) Calculates the duration of each set
	3) CTE 'Steps_Per_Day':
		a) Join tables dancers and steps
        	b) combines first and last name of the dancer to create 'fullname'
        	c) converts step_time recorded into 24 hour 
        	d) categorizes steps per day with Day of the week (Friday, Saturday, Sunday, Additional [Outside festival hours])
	4) CTE 'Dancer_profile':
		a) Filters out 'Additonal' day to only include where step_count occurred on actual days
	5) CTE 'Summary':
		a) Join CTEs 'dancers_settimes' and 'Dancer_profile'
        	b) *Challenge* is that some sets that were attended fall into the same timeframe, which makes it difficult to:
			- allocate the right amount of steps to each set/artist(s)
           		- determine the duration the dancer spent at set/artist(s)
           		- Understand where exactly the dancer was at that timestamp
		c) Case statements and Window Functions are used to evenly disperse step_count to artist(s) with the same set time
	6) Final Query - further aggregation to produce [Total Steps / Artist(s) / Dancer(s)] */
    
-- CTE combines the dancers sets they attended with dates and times (Start & End)  
 With dates_combined As 
 (
	 Select
		dancer_id,
        st.artist_id,
        st.artist_name,
        set_attended,
		concat(date_format(str_to_date(Date,'%m/%d/%Y'),'%Y-%m-%d'), " ", set_starttime)  as start,
		concat(date_format(str_to_date(Date,'%m/%d/%Y'),'%Y-%m-%d'), " ", set_endtime)  as end
	from set_times as st
	Inner Join sets_attended as sa
		On st.set_Id = sa.set_attended
),

-- Using CTE 'dates_combined', Time changed to 24-hour time duration of sets added
dancers_settimes As 
(
	Select 
		dancer_id,
		dc.artist_id,
		artist_name,
		set_attended,
		str_to_date(dc.start, '%Y-%m-%d %h:%i:%s %p') as Start,
		str_to_date(dc.end, '%Y-%m-%d %h:%i:%s %p') as End,
		timediff(str_to_date(dc.end, '%Y-%m-%d %h:%i:%s %p'), str_to_date(dc.start, '%Y-%m-%d %h:%i:%s %p')) as Duration
	from dates_combined as dc
),

-- CTE categorizes step_time recorded by dancer with Day of the week & formats time to YYYY-MM-DD HH:MM:SS (24-Hour time with date)
Steps_Per_Day As 
(
	select
		s.dancer_id,
		concat(firstname, " ", lastname) as fullname,
		step_count,
		str_to_date(enddate,'%m/%d/%Y %k:%i') as step_time,
	Case
		When str_to_date(enddate,'%m/%d/%Y %k:%i') Between '2022-09-02 15:00' and '2022-09-02 23:00' Then 'Friday'
		When str_to_date(enddate,'%m/%d/%Y %k:%i') Between '2022-09-03 12:00' and '2022-09-03 23:00' Then 'Saturday'
		When str_to_date(enddate,'%m/%d/%Y %k:%i') Between '2022-09-04 12:00' and '2022-09-04 23:00' Then 'Sunday'
		Else 'Additional' 
	End as festival_day
	From steps as s
	Inner Join dancers as d
		On s.dancer_id = d.dancer_id
),

-- Using CTE 'Steps_Per_Day', it was formatted fully to show time, day of festival, and step_count (Excluding any additional steps that werent for artist(s))
Dancer_profile as 
(
	Select 
		spd.dancer_id,
		Fullname,
		Step_time,
		festival_day, 
		step_count
	From Steps_Per_Day as spd
	Where festival_day not like "%Additional%"
	Order by step_time
),


/* Summary CTE is created for the following:
	- Query shows the actual steps committed to each set/artist
	- However, there are duplicates showing the same amount of steps on the same timestamp which is invalid
		- Meaning the dancer saw two different artists within the same timestamp of artist's set
	- Case statements with Windwow fucntions are used to help solve this
    - further aggregation will be performed in the final query (Total Steps / Artist(s) / Dancer) */
Summary as 
(
select 
	dp.dancer_id,
    fullname,
    step_time,
    festival_day,
    step_count,
	Case 
		When step_time = lead(step_time) Over (Partition by fullname Order by step_time) Then Round((step_count / 2),1)
		When step_time = lag(step_time) Over (Partition by fullname Order by step_time) Then Round((step_count / 2),1)
		Else step_count
    End as Final_stepcount,
    artist_name,
    set_attended,
    Start,
    End,
    Duration
from dancer_profile as dp
Join dancers_settimes as ds
	On dp.dancer_id = ds.dancer_id 
	And dp.step_time Between ds.start And ds.end
Order by step_time
)

-- Final query further aggregates all steps per artist(s) per dancer
select 
	s.dancer_id,
    fullname,
    step_time,
    festival_day,
    Sum(final_stepcount) as final_total_steps,
    artist_name,
    set_attended,
    Start,
    End,
    Duration
from summary as s
Group by fullname, artist_name
Order by s.dancer_id, step_time
;
