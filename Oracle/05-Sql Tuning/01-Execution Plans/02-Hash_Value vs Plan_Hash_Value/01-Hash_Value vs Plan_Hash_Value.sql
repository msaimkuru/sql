/* 
 * -----------------------------------------------------------------------------
 * Resource: https://stackoverflow.com/questions/16011976/hash-value-for-sql-statement/16012239#16012239
 * -----------------------------------------------------------------------------
 * Hash_value is the hash of the text of the SQL statement and is what Oracle 
 * uses to determine whether a particular SQL statement already exists in the 
 * shared pool. On the other hand, plan_hash_value is the hash of the plan that 
 * is generated for the SQL statement. There is, potentially, a many-to-many 
 * relationship between the two. A single SQL statement (sql_id/ hash_value) can 
 * have multiple different plans (plan_hash_value) and multiple different SQL 
 * statements can share the same plan.
 *
 * So, for example, if we write two same SQL statements with different case
 * that are querying a particular row from the EMP table, we'll get different 
 * SQL hash values and the same plan_hash_value.
 */
select * from saimk.emp where ename = 'BOB';

--find sql id for the executed sql
SELECT t.sql_id, t.HASH_VALUE, t.PLAN_HASH_VALUE, t.* --6gsgf8uz4csnv, 3192283803, 3956160932
FROM v$sql t 
WHERE t.sql_text LIKE '%from%ename = ''BOB''%'
AND t.sql_text NOT LIKE '%ORDER BY t.LAST_LOAD_TIME DESC%'
ORDER BY t.LAST_LOAD_TIME DESC
;

select * FROM saimk.emp where ename = 'BOB';

--find sql id for the executed sql
SELECT t.sql_id, t.HASH_VALUE, t.PLAN_HASH_VALUE, t.* --cyfjst19mgrcw, 1396170140, 3956160932
FROM v$sql t 
WHERE t.sql_text LIKE '%FROM%ename = ''BOB''%'
AND t.sql_text NOT LIKE '%ORDER BY t.LAST_LOAD_TIME DESC%'
ORDER BY t.LAST_LOAD_TIME DESC
;

SELECT * 
FROM TABLE( DBMS_XPLAN.display_cursor('6gsgf8uz4csnv', format => 'ROWSTATS LAST') )
;
/*
 *
   PLAN_TABLE_OUTPUT
   SQL_ID  6gsgf8uz4csnv, child number 0
   -------------------------------------
   select * from saimk.emp where ename = 'BOB'
 
   Plan hash value: 3956160932
 
   -------------------------------------------
   | Id  | Operation         | Name | E-Rows |
   -------------------------------------------
   |   0 | SELECT STATEMENT  |      |        |
   |*  1 |  TABLE ACCESS FULL| EMP  |      1 |
   -------------------------------------------
 
   Predicate Information (identified by operation id):
   ---------------------------------------------------
 
      1 - filter(""ENAME""='BOB')
 
   Note
   -----
      - Warning: basic plan statistics not available. These are only collected when:
          * hint 'gather_plan_statistics' is used for the statement or
          * parameter 'statistics_level' is set to 'ALL', at session or system level
 *------------------------------------------------------------------------------ 
 */
SELECT * 
FROM TABLE( DBMS_XPLAN.display_cursor('cyfjst19mgrcw', format => 'ROWSTATS LAST') )
;
/*
 *
   PLAN_TABLE_OUTPUT
   SQL_ID  cyfjst19mgrcw, child number 0
   -------------------------------------
   select * FROM saimk.emp where ename = 'BOB'
 
   Plan hash value: 3956160932
 
   -------------------------------------------
   | Id  | Operation         | Name | E-Rows |
   -------------------------------------------
   |   0 | SELECT STATEMENT  |      |        |
   |*  1 |  TABLE ACCESS FULL| EMP  |      1 |
   -------------------------------------------
 
   Predicate Information (identified by operation id):
   ---------------------------------------------------
 
      1 - filter(""ENAME""='BOB')
 
   Note
   -----
      - Warning: basic plan statistics not available. These are only collected when:
          * hint 'gather_plan_statistics' is used for the statement or
          * parameter 'statistics_level' is set to 'ALL', at session or system level
 *------------------------------------------------------------------------------ 
 */
/*----------------------------------------------------------------------------*/