--1) Create a load table for the csv raw data in rest_open_hours.csv

CREATE TABLE saimk.sqlldr_example3_rest_open_hours(
    name_of_restaurant VARCHAR2(100),
    open_hours VARCHAR2(200) NOT NULL
);

COMMENT ON TABLE saimk.sqlldr_example3_rest_open_hours IS 'Table created for SQL*LOADER examples';


SELECT * FROM  saimk.sqlldr_example3_rest_open_hours;

--2) Create target parsed-data table for the raw data in rest_open_hours.csv

CREATE TABLE saimk.rest_open_hours(
    name_of_restaurant VARCHAR2(100),
    open_hours_day VARCHAR2(3),
    open_hours_day_num NUMBER,
    open_hours_start VARCHAR2(32),
    open_hours_end VARCHAR2(32)
);

COMMENT ON TABLE saimk.rest_open_hours IS 'Table created for SQL*LOADER examples';