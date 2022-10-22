/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html
 * -----------------------------------------------------------------------------
 * 8,9. View Rows Processed in the Plan
 * ----------------------------------------------------------------------------- 
 * A basic plan only gives you its shape. To assess whether the plan is good, 
 * you need to see the number of rows flowing out of each step of the plan.
 *
 * You do this with the format parameter of DBMS_XPlan. Using ROWSTATS adds the 
 * estimated and actual number of rows to each step.
 *
 * You should also specify which execution details you want. Control this with 
 * LAST or ALL:
 *
 * LAST - Only display the stats for the last execution.
 * ALL - Cumulative stats for every execution. This is the default.
 *
 * This gets the row details for the previous execution of the query:
 */
SELECT *
FROM saimk.bricks b
JOIN saimk.colours c
ON b.colour = c.colour
;

--find sql id foer the executed sql
SELECT t.sql_id, t.* FROM v$sql t 
WHERE t.sql_text LIKE '%JOIN saimk.colours c%'
AND t.sql_text NOT LIKE '%ORDER BY t.LAST_LOAD_TIME DESC%'
ORDER BY t.LAST_LOAD_TIME DESC
;

SELECT * 
FROM TABLE( DBMS_XPLAN.display_cursor('7a4qgufmbcyy0', format => 'ROWSTATS LAST') )
;

/*
 * 
   PLAN_TABLE_OUTPUT
   SQL_ID  7a4qgufmbcyy0, child number 0
   -------------------------------------
   SELECT * FROM saimk.bricks b JOIN saimk.colours c ON b.colour = c.colour
    
   Plan hash value: 2784388402
    
   -----------------------------------------------
   | Id  | Operation          | Name    | E-Rows |
   -----------------------------------------------
   |   0 | SELECT STATEMENT   |         |        |
   |*  1 |  HASH JOIN         |         |     24 |
   |   2 |   TABLE ACCESS FULL| COLOURS |      3 |
   |   3 |   TABLE ACCESS FULL| BRICKS  |     24 |
   -----------------------------------------------
 
   Predicate Information (identified by operation id):
   ---------------------------------------------------
    
      1 - access(""B"".""COLOUR""=""C"".""COLOUR"")
    
   Note
   -----
      - Warning: basic plan statistics not available. These are only collected when:
          * hint 'gather_plan_statistics' is used for the statement or
          * parameter 'statistics_level' is set to 'ALL', at session or system level
 *
 *
 * But it only shows the E(stimated)-rows column. The A(ctual)-rows are missing!
 *
 * As the note indicates, to capture this information either you need to:
 *
 * - Hint the query - add the hint /*+ gather_plan_statistics * / to your query
 * - Alter the session - Run alter session set statistics_level = all before the 
 * query.
 * 
 * This captures row stats by adding the hint to the query:
 */
SELECT /*+ gather_plan_statistics */c.*, pen_type, shape, toy_name 
FROM saimk.colours c
JOIN saimk.pens p
ON c.colour = p.colour
JOIN saimk.cuddly_toys t
ON c.colour = t.colour
JOIN saimk.bricks b
ON c.colour = b.colour
;

--find sql id for the executed sql
SELECT t.sql_id, t.* FROM v$sql t 
WHERE t.sql_text LIKE '%/*+ gather_plan_statistics */c.*, pen_type, shape, toy_name%'
AND t.sql_text NOT LIKE '%ORDER BY t.LAST_LOAD_TIME DESC%'
ORDER BY t.LAST_LOAD_TIME DESC
;

SELECT * 
FROM TABLE( DBMS_XPLAN.display_cursor('g7nbttxbnxsx6', format => 'ROWSTATS LAST') )
;
/*
 * 
   PLAN_TABLE_OUTPUT
   SQL_ID  g7nbttxbnxsx6, child number 0
   -------------------------------------
   SELECT /*+ gather_plan_statistics * /c.*, pen_type, shape, toy_name  
   FROM saimk.colours c JOIN saimk.pens p ON c.colour = p.colour JOIN 
   saimk.cuddly_toys t ON c.colour = t.colour JOIN saimk.bricks b ON 
   c.colour = b.colour
    
   Plan hash value: 1245878025
    
   -----------------------------------------------------------------------
   | Id  | Operation            | Name        | Starts | E-Rows | A-Rows |
   -----------------------------------------------------------------------
   |   0 | SELECT STATEMENT     |             |      1 |        |     56 |
   |*  1 |  HASH JOIN           |             |      1 |     68 |     56 |
   |*  2 |   HASH JOIN          |             |      1 |      8 |      7 |
   |*  3 |    HASH JOIN         |             |      1 |      4 |      3 |
   |   4 |     TABLE ACCESS FULL| COLOURS     |      1 |      3 |      3 |
   |   5 |     TABLE ACCESS FULL| CUDDLY_TOYS |      1 |      5 |      5 |
   |   6 |    TABLE ACCESS FULL | PENS        |      1 |      9 |      9 |
   |   7 |   TABLE ACCESS FULL  | BRICKS      |      1 |     24 |     24 |
   -----------------------------------------------------------------------
    
   Predicate Information (identified by operation id):
   ---------------------------------------------------
    
      1 - access(""C"".""COLOUR""=""B"".""COLOUR"")
      2 - access(""C"".""COLOUR""=""P"".""COLOUR"")
      3 - access(""C"".""COLOUR""=""T"".""COLOUR"")
 *------------------------------------------------------------------------------ 
 */
/*----------------------------------------------------------------------------*/