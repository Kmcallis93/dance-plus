-- Obj: 
-- Concate Date and times together and then format the final DATETIME to 24 hour time to help know where the dancers stepped at
        
-- CTE combines the sets attended dates and times (Start & End)  
 With dates_combined As (
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
)

-- Time changed to 24-hour time duration of sets added
Select 
	dancer_id,
	dc.artist_id,
    artist_name,
    set_attended,
    str_to_date(dc.start, '%Y-%m-%d %h:%i:%s %p') as Start,
	str_to_date(dc.end, '%Y-%m-%d %h:%i:%s %p') as End,
    timediff(str_to_date(dc.end, '%Y-%m-%d %h:%i:%s %p'), str_to_date(dc.start, '%Y-%m-%d %h:%i:%s %p')) as Duration
from dates_combined as dc

