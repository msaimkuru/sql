-- Loading data into 1 database table with a single data file
LOAD DATA
TRUNCATE INTO TABLE saimk.sqlldr_example1_emails
FIELDS TERMINATED BY ","
(
email_id,
email
)
