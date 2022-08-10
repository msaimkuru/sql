-- Loading data into a single database table
LOAD DATA
TRUNCATE INTO TABLE saimk.sqlldr_example1_emails
FIELDS TERMINATED BY ","
(
email_id,
email
)
