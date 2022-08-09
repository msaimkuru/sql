/*
 * -----------------------------------------------------------------------------
 * SQL JOINS: 1- Content of This File
 * -----------------------------------------------------------------------------
 * Here, in this file you can find SQL JOIN explanations and example SQLs 
 * which employ the SQL JOIN types for demonstration. 
 *
 * We could use tables, but For demonstration we use WITH CLAUSE to select from 
 * subquery views instead of tables so as to avoid the need of creating tables
 * before running the example SQLs. So you can just copy and paste the SELECT
 * scripts and immediately execute them.
 * -----------------------------------------------------------------------------
 * 1) INNER JOIN: The INNER JOIN keyword selects records that have matching 
 * values in both tables. 
 * 
 * 2) LEFT (OUTER) JOIN: The LEFT JOIN joins two tables based on a common 
 * column or columns, and selects records that have matching values in these 
 * columns and remaining rows from the left table.
 *
 * 3) RIGHT (OUTER)JOIN: The RIGHT JOIN joins two tables based on a common 
 * column or columns, and selects records that have matching values in these 
 * columns and remaining rows from the right table. 
 *
 * 4) FULL (OUTER JOIN): The FULL OUTER JOIN  joins two tables based on a 
 * common column or columns, and selects records that have matching values in 
 * these columns and remaining rows from both of the tables.
 * 
 * -----------------------------------------------------------------------------
 * SQL JOINS: 2- The Rows of the Subquery Views V1, and V2
 * ----------------------------------------------------------------------------- 
   -------------------                  -------------------
      VIEW V1 DATA                         VIEW V2 DATA
   -------------------                  -------------------
   ID       TXT                         ID       TXT
   -----    -----                       -----    -----
   10       A1                          10       A2
   11       B1                          12       B2
   30       C1                          30       C2
   NULL     D1                          NULL     D2   
   NULL     E1                          NULL     E2   
   -------------------                  40       F2
                                        -------------------
 * -----------------------------------------------------------------------------
 * Number of Elemenents for Set Operations Based/Joined on column ID
 * -----------------------------------------------------------------------------
 * n(V1 n V2) = 2                   --> INNER JOIN on column ID
 * n(V1) = 5                        --> LEFT (OUTER) JOIN on column ID
 * n(V1 / V2) = 3                   --> LEFT (OUTER) JOIN on column ID 
                                        WHERE V2.ID IS NULL
 * n(V2) = 6                        --> RIGHT (OUTER) JOIN on column ID
 * n(V2 / V1) = 4                   --> RIGHT (OUTER) JOIN on column ID 
                                        WHERE V1.ID IS NULL
 * n(V1 U V2) = 9                   --> FULLL (OUTER) JOIN on column ID
 * n((V1 U V2) / (V1 n V2)) = 7     --> FULLL (OUTER) JOIN on column ID 
                                        WHERE V1.ID IS NULL OR V2.ID IS NULL
 * ----------------------------------------------------------------------------- 
 */
 
/* 
 * INNER JOIN: V1 n V2
 * Number of rows returned: 2
 */
WITH 
V1 AS (SELECT 10 ID, 'A1' TXT FROM DUAL UNION SELECT 11, 'B1' FROM DUAL UNION SELECT 30, 'C1' FROM DUAL UNION SELECT NULL, 'D1' FROM DUAL UNION SELECT NULL, 'E1' FROM DUAL),
V2 AS (SELECT 10 ID, 'A2' TXT FROM DUAL UNION SELECT 12, 'B2' FROM DUAL UNION SELECT 30, 'C2' FROM DUAL UNION SELECT NULL, 'D2' FROM DUAL UNION SELECT NULL, 'E2' FROM DUAL
       UNION SELECT 40,'F2' FROM DUAL)
SELECT * FROM V1 INNER JOIN V2 ON v1.ID = V2.ID
ORDER BY V1.ID NULLS LAST, V2.ID NULLS LAST, V1.TXT NULLS LAST, V2.TXT NULLS LAST
;

/* 
 * LEFT JOIN: V1 
 * Number of rows returned: 5
 */
WITH 
V1 AS (SELECT 10 ID, 'A1' TXT FROM DUAL UNION SELECT 11, 'B1' FROM DUAL UNION SELECT 30, 'C1' FROM DUAL UNION SELECT NULL, 'D1' FROM DUAL UNION SELECT NULL, 'E1' FROM DUAL),
V2 AS (SELECT 10 ID, 'A2' TXT FROM DUAL UNION SELECT 12, 'B2' FROM DUAL UNION SELECT 30, 'C2' FROM DUAL UNION SELECT NULL, 'D2' FROM DUAL UNION SELECT NULL, 'E2' FROM DUAL
       UNION SELECT 40,'F2' FROM DUAL)SELECT * FROM V1 LEFT JOIN V2 ON v1.ID = V2.ID
ORDER BY V1.ID NULLS LAST, V2.ID NULLS LAST, V1.TXT NULLS LAST, V2.TXT NULLS LAST
;

/* 
 * LEFT JOIN (WITHOUT V1 n V2): V1 / V2 
 * Number of rows returned: 3
 */
WITH 
V1 AS (SELECT 10 ID, 'A1' TXT FROM DUAL UNION SELECT 11, 'B1' FROM DUAL UNION SELECT 30, 'C1' FROM DUAL UNION SELECT NULL, 'D1' FROM DUAL UNION SELECT NULL, 'E1' FROM DUAL),
V2 AS (SELECT 10 ID, 'A2' TXT FROM DUAL UNION SELECT 12, 'B2' FROM DUAL UNION SELECT 30, 'C2' FROM DUAL UNION SELECT NULL, 'D2' FROM DUAL UNION SELECT NULL, 'E2' FROM DUAL
       UNION SELECT 40,'F2' FROM DUAL)SELECT * FROM V1 LEFT JOIN V2 ON v1.ID = V2.ID WHERE V2.ID IS NULL
ORDER BY V1.ID NULLS LAST, V2.ID NULLS LAST, V1.TXT NULLS LAST, V2.TXT NULLS LAST
;

/* 
 * RIGHT JOIN: V2 
 * Number of rows returned: 6
 */
WITH 
V1 AS (SELECT 10 ID, 'A1' TXT FROM DUAL UNION SELECT 11, 'B1' FROM DUAL UNION SELECT 30, 'C1' FROM DUAL UNION SELECT NULL, 'D1' FROM DUAL UNION SELECT NULL, 'E1' FROM DUAL),
V2 AS (SELECT 10 ID, 'A2' TXT FROM DUAL UNION SELECT 12, 'B2' FROM DUAL UNION SELECT 30, 'C2' FROM DUAL UNION SELECT NULL, 'D2' FROM DUAL UNION SELECT NULL, 'E2' FROM DUAL
       UNION SELECT 40,'F2' FROM DUAL)SELECT * FROM V1 RIGHT JOIN V2 ON v1.ID = V2.ID
ORDER BY V1.ID NULLS LAST, V2.ID NULLS LAST, V1.TXT NULLS LAST, V2.TXT NULLS LAST
;

/* 
 * RIGHT JOIN (WITHOUT V1 n V2): V2 / V1 
 * Number of rows returned: 4
 */
WITH 
V1 AS (SELECT 10 ID, 'A1' TXT FROM DUAL UNION SELECT 11, 'B1' FROM DUAL UNION SELECT 30, 'C1' FROM DUAL UNION SELECT NULL, 'D1' FROM DUAL UNION SELECT NULL, 'E1' FROM DUAL),
V2 AS (SELECT 10 ID, 'A2' TXT FROM DUAL UNION SELECT 12, 'B2' FROM DUAL UNION SELECT 30, 'C2' FROM DUAL UNION SELECT NULL, 'D2' FROM DUAL UNION SELECT NULL, 'E2' FROM DUAL
       UNION SELECT 40,'F2' FROM DUAL)SELECT * FROM V1 RIGHT JOIN V2 ON v1.ID = V2.ID WHERE V1.ID IS NULL
ORDER BY V1.ID NULLS LAST, V2.ID NULLS LAST, V1.TXT NULLS LAST, V2.TXT NULLS LAST
;

/* 
 * FULL JOIN: V1 U V2 
 * Number of rows returned: 9 
 */
WITH 
V1 AS (SELECT 10 ID, 'A1' TXT FROM DUAL UNION SELECT 11, 'B1' FROM DUAL UNION SELECT 30, 'C1' FROM DUAL UNION SELECT NULL, 'D1' FROM DUAL UNION SELECT NULL, 'E1' FROM DUAL),
V2 AS (SELECT 10 ID, 'A2' TXT FROM DUAL UNION SELECT 12, 'B2' FROM DUAL UNION SELECT 30, 'C2' FROM DUAL UNION SELECT NULL, 'D2' FROM DUAL UNION SELECT NULL, 'E2' FROM DUAL
       UNION SELECT 40,'F2' FROM DUAL)SELECT * FROM V1 FULL JOIN V2 ON v1.ID = V2.ID
ORDER BY V1.ID NULLS LAST, V2.ID NULLS LAST, V1.TXT NULLS LAST, V2.TXT NULLS LAST
;

/* 
 * FULL JOIN (WITHOUT V1 n V2): (V1 U V2) / (V1 n V2) 
 * Number of rows returned: 7
 */
WITH 
V1 AS (SELECT 10 ID, 'A1' TXT FROM DUAL UNION SELECT 11, 'B1' FROM DUAL UNION SELECT 30, 'C1' FROM DUAL UNION SELECT NULL, 'D1' FROM DUAL UNION SELECT NULL, 'E1' FROM DUAL),
V2 AS (SELECT 10 ID, 'A2' TXT FROM DUAL UNION SELECT 12, 'B2' FROM DUAL UNION SELECT 30, 'C2' FROM DUAL UNION SELECT NULL, 'D2' FROM DUAL UNION SELECT NULL, 'E2' FROM DUAL
       UNION SELECT 40,'F2' FROM DUAL)SELECT * FROM V1 FULL JOIN V2 ON v1.ID = V2.ID WHERE(V1.ID IS NULL OR V2.ID IS NULL)
ORDER BY V1.ID, V2.ID
;