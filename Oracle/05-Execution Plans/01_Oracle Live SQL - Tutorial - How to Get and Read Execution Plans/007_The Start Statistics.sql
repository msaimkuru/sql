/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html
 * -----------------------------------------------------------------------------
 * 10. The Start Statistics
 * ----------------------------------------------------------------------------- 
 * In the queries so far, the database reads each table once during execution. 
 * In some queries the database will read the same table many times.
 *
 * To check this, look at the Starts column included in the row stats. This 
 * states how many times the operation began while the query was running.
 *
 * This query uses a scalar subquery. The database may run this once for each 
 * row from the colours table. Verify this by looking at the starts column:
 */
SELECT /*+ gather_plan_statistics */ c.rgb_hex_value,
       ( SELECT COUNT (*)
         FROM saimk.bricks b
         WHERE  b.colour = c.colour 
       ) brick#
FROM saimk.colours c
;

--find sql id for the executed sql
SELECT t.sql_id, t.* 
FROM v$sql t 
WHERE t.sql_text LIKE '%/*+ gather_plan_statistics */ c.rgb_hex_value%'
AND t.sql_text NOT LIKE '%ORDER BY t.LAST_LOAD_TIME DESC%'
ORDER BY t.LAST_LOAD_TIME DESC
;

SELECT * 
FROM TABLE(DBMS_XPLAN.display_cursor('0nu0r54xwy6v2', format => 'ROWSTATS LAST') )
;

/*
 *
   PLAN_TABLE_OUTPUT
   SQL_ID  0nu0r54xwy6v2, child number 0
   -------------------------------------
   SELECT /*+ gather_plan_statistics * / c.rgb_hex_value,        ( SELECT 
   COUNT (*)          FROM saimk.bricks b          WHERE  b.colour = 
   c.colour         ) brick# FROM saimk.colours c
    
   Plan hash value: 3387836170
    
   -----------------------------------------------------------------
   | Id  | Operation          | Name    | Starts | E-Rows | A-Rows |
   -----------------------------------------------------------------
   |   0 | SELECT STATEMENT   |         |      1 |        |      3 |
   |   1 |  SORT AGGREGATE    |         |      3 |      1 |      3 |
   |*  2 |   TABLE ACCESS FULL| BRICKS  |      3 |      8 |     24 |
   |   3 |  TABLE ACCESS FULL | COLOURS |      1 |      3 |      3 |
   -----------------------------------------------------------------
    
   Predicate Information (identified by operation id):
   ---------------------------------------------------
    
      2 - filter(""B"".""COLOUR""=:B1)
 
 * 
 * Note that this plan also breaks the read the top-most leaf first rule! BRICKS 
 * appears above COLOURS in the plan. But it receives rows from the colours 
 * table. So the database must read COLOURS before BRICKS.
 *
 * Be aware that there are many special cases when it comes to execution plans.
 * This series discusses general principles. But you will be able to find cases 
 * where the rules don't apply.
 *------------------------------------------------------------------------------ 
 */
/*----------------------------------------------------------------------------*/