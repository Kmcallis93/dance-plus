-- Changing column from 'value' to Steps 
-- [Must use this everytime "steps" table is updated]
ALTER TABLE steps
RENAME COLUMN value TO step_count 
;

 -- Adding rows for 'dancer_id' to help connect tables to step count
 -- Update steps table to include dancer who provided the data
 -- [MUST USE THESE QUERIES THIS EVERYTIME A NEW DANCER IS ADDED]
Alter table steps
Add dancer_id int
;
Update steps 
set dancer_id = 1
Where sourcename = 'Tmack\'s iPhone'
;
Update steps
set dancer_id = 2
Where sourcename = 'Sandys Iphone'
;
Update steps
set dancer_id = 5
Where sourcename = 'Rafaelas iPhone'
;
Update steps
set dancer_id = 6
Where sourcename = 'Juans iPhone'
;
Update steps
set dancer_id = 4
Where 
	sourcename = 'Jackies iPhone2'
	OR sourcename = 'Jackies Apple Watch';

-- Update demographic info of dancers table
insert into dancers (dancer_id, firstname, lastname, birthdate, gender)
values (9, 'Brandon', 'Diaz', '1997-09-09', 'Male')
;
Update dancers
set birthdate = '1994-12-14'
Where dancer_id = 8
;
Update dancers
set birthdate = '1998-07-28'
Where dancer_id = 5
;
Update dancers
set birthdate = '1999-06-09'
Where dancer_id = 6
;
Update dancers
set birthdate = '1996-03-19'
Where dancer_id = 4
;
