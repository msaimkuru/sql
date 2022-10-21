/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html
 * -----------------------------------------------------------------------------
 * 6. Reading a Four Table Join Execution Plan
 * ----------------------------------------------------------------------------- 
 * Run this four table join to get its plan:
 */
SELECT c.*, pen_type, shape, toy_name 
FROM saimk.colours c
JOIN saimk.pens p
ON c.colour = p.colour
JOIN saimk.cuddly_toys t
ON c.colour = t.colour
JOIN saimk.bricks b
ON c.colour = b.colour
;

--find sql id foer the executed sql
SELECT t.sql_id, t.* FROM v$sql t 
WHERE t.sql_text LIKE '%c.*, pen_type, shape, toy_name%'
ORDER BY t.LAST_LOAD_TIME DESC
;

SELECT * 
FROM  TABLE( DBMS_XPLAN.display_cursor('btgm2ch2d6j7p', NULL, 'TYPICAL') )
;

/*
 * 
   PLAN_TABLE_OUTPUT
   SQL_ID  btgm2ch2d6j7p, child number 0
   -------------------------------------
   SELECT c.*, pen_type, shape, toy_name  FROM saimk.colours c JOIN 
   saimk.pens p ON c.colour = p.colour JOIN saimk.cuddly_toys t ON 
   c.colour = t.colour JOIN saimk.bricks b ON c.colour = b.colour
 
   Plan hash value: 1245878025
 
   ------------------------------------------------------------------------------------
   | Id  | Operation            | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
   ------------------------------------------------------------------------------------
   |   0 | SELECT STATEMENT     |             |       |       |    12 (100)|          |
   |*  1 |  HASH JOIN           |             |    68 |  3876 |    12   (0)| 00:00:01 |
   |*  2 |   HASH JOIN          |             |     8 |   368 |     9   (0)| 00:00:01 |
   |*  3 |    HASH JOIN         |             |     4 |   124 |     6   (0)| 00:00:01 |
   |   4 |     TABLE ACCESS FULL| COLOURS     |     3 |    36 |     3   (0)| 00:00:01 |
   |   5 |     TABLE ACCESS FULL| CUDDLY_TOYS |     5 |    95 |     3   (0)| 00:00:01 |
   |   6 |    TABLE ACCESS FULL | PENS        |     9 |   135 |     3   (0)| 00:00:01 |
   |   7 |   TABLE ACCESS FULL  | BRICKS      |    24 |   264 |     3   (0)| 00:00:01 |
   ------------------------------------------------------------------------------------
 
   Predicate Information (identified by operation id):
   ---------------------------------------------------
 
      1 - access(""C"".""COLOUR""=""B"".""COLOUR"")
      2 - access(""C"".""COLOUR""=""P"".""COLOUR"")
      3 - access(""C"".""COLOUR""=""T"".""COLOUR"")
 *------------------------------------------------------------------------------
 * The order of operations in this plan is:
 *------------------------------------------------------------------------------
 * Start from the top of the plan (SELECT STATEMENT) and go down to the first 
 * leaf. This is the TABLE ACCESS FULL of the COLOURS table in execution plan 
 * step 4.
 *
 * Pass the rows from this table up to the first leaf’s parent, which is the 
 * HASH JOIN in step 3. Find the next unvisited child, which is the 
 * TABLE ACCESS FULL of the CUDDLY_TOYS table in step 5.
 *
 * Pass the rows to the HASH JOIN in step 3. Step 3 has no more children, 
 * so return the rows that survive the HASH JOIN in step 3 to the HASH JOIN in 
 * step 2.
 * 
 * Search for the next child of step 2. This is the TABLE ACCESS FULL of the 
 * PENS table in step 6.
 *
 * Pass these rows to the HASH JOIN in step 2. Step 2 has no more children, so 
 * return the rows that survive the HASH JOIN in step 2 to the HASH JOIN in 
 * step 1.
 * 
 * Repeat the process until you’ve run all the operations. So the complete order 
 * for accessing the execution plan step IDs is: 
 * 4, 3, 5, 3, 2, 6, 2, 1, 7, 1, and 0.
 *------------------------------------------------------------------------------ 
 */
/*----------------------------------------------------------------------------*/