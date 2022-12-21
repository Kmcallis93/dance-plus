-- Tables created and will be used for analysis

-- dancers table data was partially entered into excel then converted to csv for importation 
-- table will be updated in mysql once more infomrmation is provided from more dancers
Create table dancers (
	dancer_id INT,
	firstname VARCHAR (20),
	lastname VARCHAR (20),
	birthdate INT,
	Gender text);
	
Create table reviews (
	dancer_id INT,
    	review VARCHAR (100),
    	num_review INT);
	
-- set_times table data was manually entered into excel then converted to csv for importation 
Create table set_times (
	set_id INT,
    	artist_id INT,
   	set_starttime Date,
    	set_endtime date);

-- steps table data was manually modify into excel then converted to csv for importation 
-- 50000 rows were filtered in excel for processing reasons
-- Unfortunately, MySQL made the date datatypes Text...Will configure/manipulate in other queries
Create table steps (
	sourcename text,
    	sourceversion decimal,
    	device VARCHAR (50),
    	creationdate timestamp,
    	startdate timestamp,
    	enddate timestamp,
    	value int);

Create table set_attended (
	dancer_id INT,
	set_attended INT,
    	artist_id INT,
    	Artists_seen_entires VARCHAR (20));

-- Intial creations but later dropped
Drop Table prospect; 
Drop Table genre;
Drop Table artists;

-- Defeats the purpose of this experiment
Drop Table reviews;
