/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 5. Reading an Execution Plan
 * ----------------------------------------------------------------------------- 
 * An execution plan is a tree. The database uses depth-first search to traverse
 * it.
 * 
 * This starts from the SELECT operation at the top of the plan. Then travels 
 * down to the top-most leaf. After reading the data from this source, it goes 
 * back up to its parent.
 * 
 * At this point the process repeats. Travel down the plan to find the next 
 * unvisited leaf. After reading, this, pass the rows back up to its parent.
 */
/* 
 * ----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------
 */
SELECT b.*, c.* /* example 3.1 */
FROM saimk.bricks b
JOIN saimk.colours c
ON b.colour = c.colour
;

--find sql id foer the executed sql
SELECT t.sql_id, t.* FROM v$sql t 
WHERE t.sql_text LIKE '%b.*, c.* /* example 3.1 */%'
ORDER BY t.LAST_LOAD_TIME DESC
;

SELECT * 
FROM  TABLE( DBMS_XPLAN.display_cursor('77wjv8jkfqhr3', NULL, 'TYPICAL') )
;
/*
 * 
   PLAN_TABLE_OUTPUT
   SQL_ID  77wjv8jkfqhr3, child number 0
   -------------------------------------
   SELECT b.*, c.* /* example 3.1 * / FROM saimk.bricks b JOIN 
   saimk.colours c ON b.colour = c.colour
 
   Plan hash value: 2784388402
 
   ------------------------------------------------------------------------------
   | Id  | Operation          | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
   ------------------------------------------------------------------------------
   |   0 | SELECT STATEMENT   |         |       |       |     6 (100)|          |
   |*  1 |  HASH JOIN         |         |    24 |   552 |     6   (0)| 00:00:01 |
   |   2 |   TABLE ACCESS FULL| COLOURS |     3 |    36 |     3   (0)| 00:00:01 |
   |   3 |   TABLE ACCESS FULL| BRICKS  |    24 |   264 |     3   (0)| 00:00:01 |
   ------------------------------------------------------------------------------
 
   Predicate Information (identified by operation id):
   ---------------------------------------------------
 
      1 - access(""B"".""COLOUR""=""C"".""COLOUR"")
 * 
 * Start from the top (SELECT STATEMENT) and go down the tree to the first leaf. 
 * This is the TABLE ACCESS FULL of the COLOURS table.
 *
 * Pass the rows from this table up to the first leaf’s parent, the HASH JOIN.
 *
 * Look for the next unvisited child of step 1. This is the TABLE ACCESS FULL 
 * of the BRICKS table.
 *
 * Pass the rows from this table up to its parent, the HASH JOIN.
 *
 * All the children of step 1 have been accessed, so pass the rows that survive 
 * the join to the SELECT STATEMENT and back to the client.
 */
/*----------------------------------------------------------------------------*/