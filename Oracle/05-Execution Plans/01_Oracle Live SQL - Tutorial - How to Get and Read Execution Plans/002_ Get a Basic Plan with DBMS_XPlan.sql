/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 1. Get a Basic Plan with DBMS_XPlan
 * ----------------------------------------------------------------------------- 
 * You can get the execution plan for a query using DBMS_XPlan. The table 
 * function DISPLAY_CURSOR fetches the plan from memory for the requested SQL 
 * statement.
 */

/* 
 * ----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------
 * Run this to get the execution plan for the join:
 * ---------------------------------------------------------------------------- 
 */
SELECT *
FROM saimk.bricks b
JOIN saimk.colours c
ON b.colour = c.colour
;

SELECT * 
FROM TABLE(
  DBMS_XPLAN.display_cursor(:LIVESQL_LAST_SQL_ID)
)
;
/*
 * The first argument of the DISPLAY_CURSOR is the SQL ID for the statement. 
 * LIVESQL_LAST_SQL_ID is a bind variable specific to Live SQL. Only use this in 
 * Live SQL. Normally you'll want to pass NULL or a SQL ID instead.
 *
 * Passing NULL gets the plan for the last SQL statement run in this session. 
 * Using a SQL ID searches for plans in the cursor cache for that statement.
 */
/*----------------------------------------------------------------------------*/ 
/* 
 * -----------------------------------------------------------------------------
 * 2. Find the SQL ID for a Statement
 * ----------------------------------------------------------------------------- 
 * To get the SQL ID for a statement, search for it in v$sql:
 *
      select sql_id, sql_text
      from   v$sql
      where  sql_text like 'select *%bricks b%'
      -- exclude this query
      and    sql_text not like '%not this%'
      ;
 *
 * The SQL ID is a hash of the statement's text. This means that changes to the 
 * formatting of a SQL statement will give it a new SQL ID, even though its 
 * meaning is identical. For example the only difference between these queries 
 * is the case of select. But they have different SQL IDs!
 *
      select *
      from   bricks b
      join   colours c
      on     b.colour = c.colour
      ;

      SELECT *
      from   bricks b
      join   colours c
      on     b.colour = c.colour
      ;  

      select sql_id, sql_text
      from   v$sql
      where  sql_text like '%bricks%join%colours%'
      --exclude this query
      and    sql_text not like '%not this%'
      ;
 *
 */
SELECT t.sql_id, t.sql_text --7a4qgufmbcyy0
FROM v$sql t
WHERE t.sql_text like 'SELECT *%bricks b%'
-- exclude this query
AND t.sql_text not like '%not this%'
;
/*----------------------------------------------------------------------------*/ 
/* 
 * -----------------------------------------------------------------------------
 * 3,4. Using SQL ID in DBMS_XPlan
 * -----------------------------------------------------------------------------
 * If you know the SQL ID for a statement, you can pass it directly to 
 * DBMS_XPlan:
 */
SELECT * 
FROM TABLE( DBMS_XPLAN.display_cursor('7a4qgufmbcyy0') )
;
/*----------------------------------------------------------------------------*/
/*
 * This is handy if you want to get the plan for a statement running in a 
 * different session.
 *
 * If you don't know the SQL ID, but have the statement's text, you can lookup 
 * its SQL ID and pass it to DBMS_XPlan in one statement.
 * -----------------------------------------------------------------------------
 * EXAMPLE 1: Below is an example for this:
 * -----------------------------------------------------------------------------
 */
 /* The sample sql for which we 'll lookup its SQL ID */
SELECT /* colours query */* FROM saimk.colours;

SELECT p.*  , s.sql_id, s.child_number--, s.*
FROM   v$sql s, TABLE (  
  DBMS_XPLAN.display_cursor (  
    s.sql_id, s.child_number, 'BASIC'  
  )  
) p  
WHERE s.sql_text LIKE '%colours query%'  /* enter text from the target statement here */
AND   s.sql_text NOT LIKE '%not this%'
;
/*----------------------------------------------------------------------------*/