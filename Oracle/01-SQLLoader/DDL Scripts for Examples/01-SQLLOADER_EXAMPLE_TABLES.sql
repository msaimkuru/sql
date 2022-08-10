CREATE TABLE saimk.sqlldr_example1_emails(
    email_id NUMBER PRIMARY KEY,
    email VARCHAR2(150) NOT NULL
);

COMMENT ON TABLE saimk.sqlldr_example1_emails IS 'Table created for SQL*LOADER examples';

CREATE TABLE saimk.sqlldr_example1_users(
    user_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    birth_date DATE,
    sex CHAR(1),
    marital_status CHAR(32),
    occupation VARCHAR2(100),
    email_id NUMBER
);

COMMENT ON TABLE saimk.sqlldr_example1_users IS 'Table created for SQL*LOADER examples';

--
--

SELECT * FROM  saimk.sqlldr_example1_emails;

SELECT * FROM  saimk.sqlldr_example1_users;

--DELETE FROM  saimk.sqlldr_example1_emails;

--DELETE FROM  saimk.sqlldr_example1_users;