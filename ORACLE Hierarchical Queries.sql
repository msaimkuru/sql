/**
 * @author    Saim Kuru
 * @version 1.0
 * ------------
 * Objectives:
 * ------------ 
 * 1. Preparing create script  for creating a sample table to issue hierarchical 
 * query sqls on.
 *
 * 2. Understanding Hierarchical Queries In Oracle
 *
 * 3. Generating n Rows from dual using hierarchial queries.
 * 
 * 4. Listing 7 days back, beginning from today.
 * ------------
 * Difficulty: Medium
 * ------------ 
 */

/*
 * CREATE TABLE script for creating a sample table to issue hierarchical query 
 * sqls on.
 */
CREATE TABLE SAIMK.T_SAMPLE_PARENT_CHILD AS
SELECT * FROM
(-- ROOT NODE 1
 SELECT 1 ID, NULL PARENT_ID, 'Ireland' FAVORITE_REGION FROM DUAL UNION
 -- ROOT NODE 2
 SELECT 2 ID, NULL PARENT_ID, 'Turkey' FAVORITE_REGION FROM DUAL UNION
 -- CHILD NODES OF NODE 1
 SELECT 11 ID, 1 PARENT_ID, 'Dublin' FAVORITE_REGION FROM DUAL UNION
 SELECT 12 ID, 1 PARENT_ID, 'Howth(Dublin)' FAVORITE_REGION FROM DUAL UNION 
 -- CHILD NODES OF NODE 2
 SELECT 21 ID, 2 PARENT_ID, 'Mugla' FAVORITE_REGION FROM DUAL UNION
 SELECT 22 ID, 2 PARENT_ID, 'Istanbul' FAVORITE_REGION FROM DUAL UNION
 SELECT 23 ID, 2 PARENT_ID, 'Izmir' FAVORITE_REGION FROM DUAL UNION
 SELECT 24 ID, 2 PARENT_ID, 'Ankara' FAVORITE_REGION FROM DUAL UNION
 -- CHILD NODES OF NODE 21
 SELECT 211 ID, 21 PARENT_ID, 'Marmaris' FAVORITE_REGION FROM DUAL UNION
 SELECT 212 ID, 21 PARENT_ID, 'Datca' FAVORITE_REGION FROM DUAL UNION
 SELECT 213 ID, 21 PARENT_ID, 'Bozburun' FAVORITE_REGION FROM DUAL UNION
 -- CHILD NODES OF NODE 23
 SELECT 231 ID, 23 PARENT_ID, 'Ozdere' FAVORITE_REGION FROM DUAL UNION 
 SELECT 232 ID, 23 PARENT_ID, 'Alsancak' FAVORITE_REGION FROM DUAL UNION
 -- CHILD NODES OF NODE 231
 SELECT 2311 ID, 231 PARENT_ID, 'Cukuralti' FAVORITE_REGION FROM DUAL
)
;
COMMENT ON TABLE SAIMK.T_SAMPLE_PARENT_CHILD IS 'Created for hierarchical query demonstrations'
;
GRANT SELECT ON SAIMK.T_SAMPLE_PARENT_CHILD TO PUBLIC
;

/*
 *  Let's have a closer look in the T_SAMPLE_PARENT_CHILD table data.
 *
 *   ------------------------------------
 *   ID  |  PARENT_ID  |  FAVORITE_REGION
 *   ------------------------------------
 *   1   |  -          |  Ireland
 *   2   |  -          |  Turkey
 *   11  |  1          |  Dublin
 *   12  |  1          |  Howth(Dublin)
 *   21  |  2          |  Mugla
 *   22  |  2          |  Istanbul
 *   23  |  2          |  Izmir
 *   24  |  2          |  Ankara
 *   211 |  21         |  Marmaris
 *   212 |  21         |  Datca
 *   213 |  21         |  Bozburun
 *   231 |  23         |  Ozdere
 *   232 |  23         |  Alsancak
 *   2311|  231        |  Cukuralti
 *   -----------------------------------
 *
 *  Hierarchical view of data
 *
 *        1                                      2
 *     /¯¯ ¯¯\                 /¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯¯¯¯¯¯\¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\
 *   11      12              21                  22              23              24
 *                       /¯¯¯¯|¯¯¯¯¯\                         /¯¯  ¯¯\
 *                     211    212   213                     231      232
 *                                                          /
 *                                                       2311
 *
 * -----------------------------------------------------------------------------                                                  
 * INVESTIGATION of QUERY RESULTS
 * -----------------------------------------------------------------------------
 * SQL1
 * -----------------------------------------------------------------------------
 * Without a WHERE and START WITH clause the hierarchical query will return
 * 33 rows, as explained below.
 * 
 * ---------------------------------------------------------------------- 
 * Tree of Root Element 1    Tree of Root Element 2
 * ----------------------------------------------------------------------
 * (in a * b, a is level value and b is number of nodes in that nevel)
 * ----------------------------------------------------------------------    
 *         1 * 1          +         1 * 1          +
 *         2 * 2          +         2 * 4          +
 *                                  3 * 3          +         3 * 2          +
 *                                  4 * 1   = 33 rows.
 * -----------------------------------------------------------------------------
 * SQL2
 * -----------------------------------------------------------------------------
 * START WITH t.ID = 2 executes the hiearchical query to list only the hierarchy
 * having ID = 2 as the root. Therefore, this SQL returns 11 rows.
 * -----------------------------------------------------------------------------
 * SQL3
 * -----------------------------------------------------------------------------
 * START WITH t.ID IN(1, 2) executes the hiearchical query to list only the 
 * 2 hierarchies having ID = 1 as the root, and ID = 2 as the root. Therefore, 
 * this SQL returns 14 rows;
 * 3 rows for the hierarchy having ID=1 as the root, and
 * 11 rows for the hierarchy having ID=2 as the root. 
 */

/* List all data of the table */
SELECT t.*
FROM SAIMK.T_SAMPLE_PARENT_CHILD t
ORDER BY t.ID
;

/* 
 * These SQLs Shows data in the table in its hierarchical manners.
 * -----------------------------------------------------------------------------
 * EXPLANATIONS for the KEYWORDS
 * -----------------------------------------------------------------------------
 * 1) CONNECT BY: specifies the relationship between parent rows and child rows 
 * of the hierarchy.
 *
 * 2) PRIOR: In a hierarchical query, one expression in condition must be 
 * qualified with the PRIOR operator to refer to the parent row.
 *
 * 3) LEVEL: For each row returned by a hierarchical query, the LEVEL 
 * pseudocolumn returns 1 for a root row, 2 for a child of a root, and so on.
 *
 * 4) CONNECT_BY_ROOT: This operator extends the functionality of the 
 * CONNECT BY [PRIOR] condition of hierarchical queries by returning not only 
 * the immediate parent row but all ancestor rows in the hierarchy.
 *
 * 5) SYS_CONNECT_BY_PATH: It returns the path of a column value from root to 
 * node, with column values separated by char for each row returned by 
 * CONNECT BY condition.
 *
 * 6) ORDER SIBLINGS BY : In a hierarchical query, do not specify either 
 * ORDER BY or GROUP BY, as they will destroy the hierarchical order of the 
 * CONNECT BY results. If you want to order rows of siblings of the same parent, 
 * then use the ORDER SIBLINGS BY clause
 *
 * 7) START WITH: specifies the root row(s) of the hierarchy to be listed.
 */

/* SQL 1 */
SELECT t.*, CONNECT_BY_ROOT t.ID ROOT_ID_VALUE, CONNECT_BY_ROOT t.FAVORITE_REGION ROOT_FAVORITE_REGION_VALUE, SYS_CONNECT_BY_PATH(FAVORITE_REGION, '->') PATH, LEVEL 
FROM SAIMK.T_SAMPLE_PARENT_CHILD t
CONNECT BY PRIOR t.ID = t.PARENT_ID
ORDER SIBLINGS BY t.ID
;

/* SQL 2 */
SELECT t.*, CONNECT_BY_ROOT t.ID ROOT_ID_VALUE, CONNECT_BY_ROOT t.FAVORITE_REGION ROOT_FAVORITE_REGION_VALUE, SYS_CONNECT_BY_PATH(FAVORITE_REGION, '->') PATH, LEVEL 
FROM SAIMK.T_SAMPLE_PARENT_CHILD t
START WITH t.ID = 2
CONNECT BY PRIOR t.ID = t.PARENT_ID
ORDER SIBLINGS BY t.ID
;

/* SQL 3 */
SELECT t.*, CONNECT_BY_ROOT t.ID ROOT_ID_VALUE, CONNECT_BY_ROOT t.FAVORITE_REGION ROOT_FAVORITE_REGION_VALUE, SYS_CONNECT_BY_PATH(FAVORITE_REGION, '->') PATH, LEVEL 
FROM SAIMK.T_SAMPLE_PARENT_CHILD t
START WITH ID IN(1, 2)
CONNECT BY PRIOR t.ID = t.PARENT_ID
ORDER SIBLINGS BY t.ID
;

/*
 ************************************************************ Extra Queries ************************************************************
 */

/* SQL4: Only the direct child nodes of ID=1 and ID=2 is listed */
SELECT t.*, CONNECT_BY_ROOT t.ID ROOT_ID_VALUE, CONNECT_BY_ROOT t.FAVORITE_REGION ROOT_FAVORITE_REGION_VALUE, SYS_CONNECT_BY_PATH(FAVORITE_REGION, '->') PATH, LEVEL 
FROM SAIMK.T_SAMPLE_PARENT_CHILD t
WHERE LEVEL = 2
START WITH ID IN(1, 2)
CONNECT BY PRIOR t.ID = t.PARENT_ID
ORDER SIBLINGS BY ID
;

/* SQL 5: Only the direct child nodes of ID=2 and their direct child nodes is listed */
SELECT t.*, CONNECT_BY_ROOT t.ID ROOT_ID_VALUE, CONNECT_BY_ROOT t.FAVORITE_REGION ROOT_FAVORITE_REGION_VALUE, SYS_CONNECT_BY_PATH(FAVORITE_REGION, '->') PATH, LEVEL 
FROM SAIMK.T_SAMPLE_PARENT_CHILD t
WHERE LEVEL BETWEEN 2 AND 3
START WITH ID = 2
CONNECT BY PRIOR t.ID = t.PARENT_ID
ORDER SIBLINGS BY ID
;

/* SQL 6: Generating n Rows using dual */
SELECT ROWNUM, LEVEL
  FROM DUAL
CONNECT BY LEVEL <= &n
;

/* Listing 7 days back, beginning from today. */
SELECT TO_DATE (TO_CHAR (SYSDATE - LEVEL + 1, 'DD-MON-YYYY ' ) ,'DD-MON-YYYY' ) dates FROM DUAL CONNECT BY LEVEL<= 7
;