LOAD DATA
TRUNCATE
INTO TABLE saimk.sqlldr_example1_emails
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(
email_id,
email
)
INTO TABLE saimk.sqlldr_example1_users
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
(email_id POSITION(1),
 skip_col1 FILLER,
 user_id,
 first_name,
 last_name,
 birth_date DATE "DD.MM.YYYY",
 sex,
 marital_status,
 occupation
)
