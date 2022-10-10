/*
 * -----------------------------------------------------------------------------
 * Resource:
 * ----------------------------------------------------------------------------- 
 * https://oracle-base.com/articles/misc/row_number-analytic-function#row_number
 * -----------------------------------------------------------------------------  
 */ 
/*
 * ----------------------------------------------------------------------------
 * ROW_NUMBER Analytic Function
 * ---------------------------------------------------------------------------- 
 * If you have ever used the ROWNUM pseudocolumn, you will have an idea what the 
 * ROW_NUMBER analytic function does. It is used to assign a unique number from 
 * 1-N to the rows within a partition. At first glance this may seem similar to 
 * the RANK and DENSE_RANK analytic functions, but the ROW_NUMBER function 
 * ignores ties and always gives a unique number to each row.
 *
 * The basic description for the ROW_NUMBER analytic function is shown below. 
 *
 * ROW_NUMBER() OVER ([ query_partition_clause ] order_by_clause)
 * 
 * The ROW_NUMBER analytic function is order-sensitive and produces an error if 
 * you attempt to use it without an ORDER BY in the analytic clause. Unlike some 
 * other analytic functions, it doesn't support the windowing clause.
 *
 * Omitting a partitioning clause from the OVER clause means the whole result 
 * set is treated as a single partition. In the following example we assign a 
 * unique row number to each employee based on their salary (lowest to highest). 
 * The example also includes RANK and DENSE_RANK to show the difference in how 
 * ties are handled.
 */
SELECT t.empno,
       t.ename,
       t.deptno,
       t.sal,
       ROW_NUMBER() OVER (ORDER BY t.sal) AS row_num,
       RANK() OVER (ORDER BY t.sal) AS row_rank,
       DENSE_RANK() OVER (ORDER BY t.sal) AS row_dense_rank
FROM saimk.emp t
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO   ENAME    DEPTNO    SAL    ROW_NUM   ROW_RANK   ROW_DENSE_RANK
     -----   -----    ------    ----   -------   --------   --------------
      7369   SMITH        20     800         1          1                1
      7900   JAMES        30     950         2          2                2
      7876   ADAMS        20    1100         3          3                3
      7521   WARD         30    1250         4          4                4
      7654   MARTIN       30    1250         5          4                4
      7934   MILLER       10    1300         6          6                5
      7844   TURNER       30    1500         7          7                6
      7499   ALLEN        30    1600         8          8                7
      7782   CLARK        10    2450         9          9                8
      7698   BLAKE        30    2850        10         10                9
      7566   JONES        20    2975        11         11               10
      7788   SCOTT        20    3000        12         12               11
      7902   FORD         20    3000        13         12               11
      7839   KING         10    5000        14         14               12
 * ---------------------------------------------------------------------------- 
 */
/* 
 * Adding the partitioning clause allows us to assign the row number within a 
 * partition. In the following example we assign the row number within the 
 * department, based on highest to lowest salary.
 */
SELECT t.empno,
       t.ename,
       t.deptno,
       t.sal,
       ROW_NUMBER() OVER (PARTITION BY t.deptno ORDER BY t.sal DESC) AS row_num
FROM saimk.emp t
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO     ENAME     DEPTNO     SAL     ROW_NUM
     -----     -----     ------    ----     -------      
     7839       KING         10     5000          1
     7782      CLARK         10     2450          2
     7934     MILLER         10     1300          3
     7788      SCOTT         20     3000          1
     7902       FORD         20     3000          2
     7566      JONES         20     2975          3
     7876      ADAMS         20     1100          4
     7369      SMITH         20      800          5
     7698      BLAKE         30     2850          1
     7499      ALLEN         30     1600          2
     7844     TURNER         30     1500          3
     7654     MARTIN         30     1250          4
     7521       WARD         30     1250          5
     7900      JAMES         30      950          6
 * ---------------------------------------------------------------------------- 
 */
 
/*
 * ----------------------------------------------------------------------------
 * Top-N Queries By Means Of ROW_NUMBER()
 * ----------------------------------------------------------------------------
 * This allows us to write Top-N queries at the partition level. The following 
 * example brings back the best paid person in each department, ignoring ties.
 * ---------------------------------------------------------------------------- 
 */
SELECT v1.*
FROM (SELECT t.empno,
             t.ename,
             t.deptno,
             t.sal,
             ROW_NUMBER() OVER (PARTITION BY t.deptno ORDER BY t.sal DESC) AS row_num
      FROM saimk.emp t
     )v1
WHERE v1.row_num < 2
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO     ENAME     DEPTNO     SAL     ROW_NUM
   ------- ---------     ------     ----    -------
      7839      KING         10     5000          1
      7788     SCOTT         20     3000          1
      7698     BLAKE         30     2850          1
 * ----------------------------------------------------------------------------       
 */
/* ---------------------------------------------------------------------------*/ 