/*
 * -----------------------------------------------------------------------------
 * Resource:
 * ----------------------------------------------------------------------------- 
 * https://oracle-base.com/articles/misc/percent_rank-analytic-function#percent_rank
 * -----------------------------------------------------------------------------  
 */ 
/*
 * ----------------------------------------------------------------------------
 * PERCENT_RANK Analytic Function
 * ---------------------------------------------------------------------------- 
 * The basic description for the PERCENT_RANK analytic function is shown below.
 *
 * PERCENT_RANK() OVER ([ query_partition_clause ] order_by_clause)
 *
 * The PERCENT_RANK analytic function is order sensitive so the ORDER BY clause 
 * is mandatory. Omitting a partitioning clause from the OVER clause means 
 * the whole result set is treated as a single partition. The first row of the 
 * ordered set is assigned 0 and the last row of the set is assigned 1. If there 
 * is a single row in the set it is assigned 0. Ties are assigned the same 
 * value. 
 * 
 * In the following example we display the percent rank, or the relative 
 * position in the set, of each of all employees, as well as all the original 
 * data.
 */
SELECT t.empno,
       t.ename,
       t.deptno,
       t.sal,
       ROUND(PERCENT_RANK() OVER (ORDER BY t.sal), 2) AS percent_rank_sal,
       ROUND(PERCENT_RANK() OVER (ORDER BY t.sal) * 100) AS percent_rank_sal_pct
FROM saimk.emp t
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO  ENAME   DEPTNO    SAL   PERCENT_RANK_SAL   PERCENT_RANK_SAL_PCT
     -----  -----   ------    ----  ----------------   --------------------     
     7369   SMITH       20     800                 0                      0
     7900   JAMES       30     950              0,08                      8
     7876   ADAMS       20    1100              0,15                     15
     7521    WARD       30    1250              0,23                     23
     7654  MARTIN       30    1250              0,23                     23
     7934  MILLER       10    1300              0,38                     38
     7844  TURNER       30    1500              0,46                     46
     7499   ALLEN       30    1600              0,54                     54
     7782   CLARK       10    2450              0,62                     62
     7698   BLAKE       30    2850              0,69                     69
     7566   JONES       20    2975              0,77                     77
     7788   SCOTT       20    3000              0,85                     85
     7902    FORD       20    3000              0,85                     85
     7839    KING       10    5000                 1                    100
 * ---------------------------------------------------------------------------- 
*/
/*
 * Adding the partitioning clause allows us to display the percent rank of each 
 * employee within a partition.
 */
SELECT t.empno,
       t.ename,
       t.deptno,
       t.sal,
       ROUND(PERCENT_RANK() OVER (PARTITION BY t.deptno ORDER BY t.sal), 2) AS percent_rank_sal_by_dept,
       ROUND(PERCENT_RANK() OVER (PARTITION BY t.deptno ORDER BY t.sal) * 100) AS percent_rank_sal_pct_by_dept
FROM saimk.emp t
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
   EMPNO  ENAME  DEPTNO  SAL   PERCENT_RANK_SAL_BY_DEPT   PERCENT_RANK_SAL_PCT_
                                                          BY_DEPT
   -----  -----  ------  ----  ------------------------   ----------------------   
   7934   MILLER     10  1300                         0                        0
   7782   CLARK      10  2450                       0,5                       50
   7839   KING       10  5000                         1                      100
   7369   SMITH      20   800                         0                        0
   7876   ADAMS      20  1100                      0,25                       25
   7566   JONES      20  2975                      0,5                        50
   7788   SCOTT      20  3000                      0,75                       75
   7902   FORD       20  3000                      0,75                       75
   7900   JAMES      30  950                          0                        0
   7654   MARTIN     30  1250                       0,2                       20
   7521   WARD       30  1250                       0,2                       20
   7844   TURNER     30  1500                       0,6                       60
   7499   ALLEN      30  1600                       0,8                       80
   7698   BLAKE      30  2850                       1                        100
 * ----------------------------------------------------------------------------  
 */
/*
 * ----------------------------------------------------------------------------
 * Top-N Queries By Means Of PERCENT_RANK()
 * ----------------------------------------------------------------------------
 * Assigning a percentage allows us to do a type of Top-N query based on the 
 * percentage. 
 * 
 * The following query returns the top 30% of employees in the company based 
 * on their pay.
 * ---------------------------------------------------------------------------- 
 */
SELECT v1.*
FROM (SELECT t.empno,
             t.ename,
             t.deptno,
             t.sal,
             ROUND(PERCENT_RANK() OVER (ORDER BY t.sal), 2) AS percent_rank_sal
      FROM saimk.emp t
     )v1
WHERE v1.percent_rank_sal >= 0.7
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO        ENAME        DEPTNO        SAL        PERCENT_RANK_SAL
     -----        -----        ------        ----       ----------------   
     7566         JONES            20        2975                   0,77
     7788         SCOTT            20        3000                   0,85
     7902          FORD            20        3000                   0,85
     7839          KING            10        5000                      1
 * ----------------------------------------------------------------------------       
 */
/* ---------------------------------------------------------------------------*/ 