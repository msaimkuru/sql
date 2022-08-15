--Loading data into 1 database table with a single data file
LOAD DATA
TRUNCATE
INTO TABLE saimk.sqlldr_example3_rest_open_hours
FIELDS TERMINATED BY ","  OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
name_of_restaurant,
open_hours
)