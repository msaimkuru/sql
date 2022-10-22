/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html
 * -----------------------------------------------------------------------------
 * 7. Reading a Complex Query Plan
 * ----------------------------------------------------------------------------- 
 * Run this query and get its plan:
 */
SELECT c.colour, COUNT(*)
FROM saimk.colours c 
JOIN(
  SELECT colour, shape FROM saimk.bricks
  UNION ALL
  SELECT colour, toy_name FROM saimk.cuddly_toys
  UNION ALL
  SELECT colour, pen_type FROM saimk.pens
) t
ON t.colour = c.colour
GROUP  BY c.colour
;

--find sql id foer the executed sql
SELECT t.sql_id, t.* FROM v$sql t 
WHERE t.sql_text LIKE '%SELECT c.colour, COUNT(*)%'
AND t.sql_text NOT LIKE '%ORDER BY t.LAST_LOAD_TIME DESC%'
ORDER BY t.LAST_LOAD_TIME DESC
;

SELECT * 
FROM  TABLE( DBMS_XPLAN.display_cursor('2zpn09c3h5fbs', NULL, 'TYPICAL') )
;

/*
 * 
   PLAN_TABLE_OUTPUT
   SQL_ID  2zpn09c3h5fbs, child number 0
   -------------------------------------
   SELECT c.colour, COUNT(*) FROM saimk.colours c  JOIN(   SELECT colour, 
   shape FROM saimk.bricks   UNION ALL   SELECT colour, toy_name FROM 
   saimk.cuddly_toys   UNION ALL   SELECT colour, pen_type FROM saimk.pens 
   ) t ON t.colour = c.colour GROUP  BY c.colour
    
   Plan hash value: 1792629648
    
   -------------------------------------------------------------------------------------
   | Id  | Operation             | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
   -------------------------------------------------------------------------------------
   |   0 | SELECT STATEMENT      |             |       |       |    13 (100)|          |
   |   1 |  HASH GROUP BY        |             |     3 |    33 |    13   (8)| 00:00:01 |
   |*  2 |   HASH JOIN           |             |    23 |   253 |    12   (0)| 00:00:01 |
   |   3 |    TABLE ACCESS FULL  | COLOURS     |     3 |    15 |     3   (0)| 00:00:01 |
   |   4 |    VIEW               |             |    38 |   228 |     9   (0)| 00:00:01 |
   |   5 |     UNION-ALL         |             |       |       |            |          |
   |   6 |      TABLE ACCESS FULL| BRICKS      |    24 |   120 |     3   (0)| 00:00:01 |
   |   7 |      TABLE ACCESS FULL| CUDDLY_TOYS |     5 |    30 |     3   (0)| 00:00:01 |
   |   8 |      TABLE ACCESS FULL| PENS        |     9 |    54 |     3   (0)| 00:00:01 |
   -------------------------------------------------------------------------------------
    
   Predicate Information (identified by operation id):
   ---------------------------------------------------
    
      2 - access(""T"".""COLOUR""=""C"".""COLOUR"")
 *------------------------------------------------------------------------------
 * The order of operations in this plan is:
 *------------------------------------------------------------------------------
 * This uses the same four tables as the previous query. But accesses them in a 
 * different way. Here the order of operations is:
 *
 * 1) Travel down the plan to the first leaf. This is the TABLE ACCESS FULL of 
 * the COLOURS table in step 3.
 *
 * 2) Pass the rows from this table up to the first leaf’s parent, the HASH JOIN 
 * in step 2.
 *
 * 3) Find the next leaf, which is the TABLE ACCESS FULL of the BRICKS table in 
 * step 6.
 *
 * 4) Its parent is a multichild operation—UNION-ALL—so the database will next 
 * execute steps 7 and 8. (There is an optimization—concurrent execution of 
 * UNION-ALL—that means that the database can run all of these table scans at 
 * the same time in parallel queries.)
 *
 * 5) Pass the rows from the tables at steps 6, 7, and 8 up to the UNION-ALL in 
 * step 5. This step combines the rows into one dataset.
 *
 * 6) Work back up the tree to the HASH JOIN in step 2.
 *
 * 7) Join the rows from steps 3 and 5, passing the surviving rows up to the 
 * HASH GROUP BY in step 1.
 *
 * 8) Finally, return the data to the client.
 *
 * Note that UNION-ALL can combine many tables in one operation. This is 
 * different to joins, which always combine exactly two data sources. Joins and 
 * unions are separate operations - the optimizer can't swap one for another.
 *------------------------------------------------------------------------------ 
 */
/*----------------------------------------------------------------------------*/