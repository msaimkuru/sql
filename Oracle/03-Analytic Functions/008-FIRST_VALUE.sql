/*
 * -----------------------------------------------------------------------------
 * Resource:
 * ----------------------------------------------------------------------------- 
 * https://oracle-base.com/articles/misc/first-value-and-last-value-analytic-functions#first-value
 * -----------------------------------------------------------------------------  
 */ 
/*
 * ----------------------------------------------------------------------------
 * NTH_VALUE Analytic Function
 * ---------------------------------------------------------------------------- 
 * This article gives an overview of the NTH_VALUE analytic function, which is 
 * similar to the FIRST_VALUE and LAST_VALUE analytic functions.
 *
 * The basic description for the NTH_VALUE analytic function is shown below.
 *
 * NTH_VALUE (measure_expr, n)
     [ FROM { FIRST | LAST } ][ { RESPECT | IGNORE } NULLS ] 
     OVER (analytic_clause)
 *
 * The measure_expr is typically going to be a column, with "n" being the offset 
 * from the window boundary. Using the default FROM FIRST means we are counting 
 * to the Nth value from the top of the window. Using FROM LAST means we are 
 * counting back from the end of the window.
 *
 * The lack of a partitioning clause in the OVER clause means the whole result 
 * set is treated as a single partition, so we get the Nth salary for all 
 * employees, as well as all the original data. The NTH_VALUE analytic function 
 * is order-sensitive, so it doesn't really make sense to use it without an 
 * ORDER BY in the analytic clause. Remember that as soon as you have an 
 * ORDER BY in the analytic clause you get the default window clause of 
 * RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW. You need to be sure this 
 * is what you need or you might get a unexpected result as seen below.
 */
/*
 * We want to display the raw employee data along with the third lowest and
 * third highest salaries in the company. 
 * 
 * In both cases we use NTH_VALUE(sal, 3), but in the first call we use 
 * FROM FIRST to indicate we are stepping from the start of the result set down. 
 * In the second call we use FROM LAST to indicate we are stepping from the ends
 * of the result set up. There is no partitioning clause so the whole table is 
 * treated as a single partition.
 */
SELECT t.empno,
       t.ename,
       t.deptno,
       t.sal,
       NTH_VALUE(t.sal, 3) FROM FIRST OVER (ORDER BY t.sal) AS third_lowest_sal,
       NTH_VALUE(t.sal, 3) FROM LAST OVER (ORDER BY t.sal) AS third_highest_sal
FROM saimk.emp t
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
   EMPNO    ENAME    DEPTNO    SAL      THIRD_LOWEST_SAL    THIRD_HIGHEST_SAL
   -----    ------   ------    ------   ----------------    -----------------
   7369     SMITH        20       800             (null)               (null)
   7900     JAMES        30       950             (null)               (null)  
   7876     ADAMS        20      1100               1100                  800
   7521     WARD         30      1250               1100                 1100
   7654     MARTIN       30      1250               1100                 1100
   7934     MILLER       10      1300               1100                 1250
   7844     TURNER       30      1500               1100                 1250
   7499     ALLEN        30      1600               1100                 1300
   7782     CLARK        10      2450               1100                 1500
   7698     BLAKE        30      2850               1100                 1600
   7566     JONES        20      2975               1100                 2450
   7788     SCOTT        20      3000               1100                 2975
   7902     FORD         20      3000               1100                 2975
   7839     KING         10      5000               1100                 3000
 * ---------------------------------------------------------------------------- 
 *
 * The call using FROM FIRST almost gives us the result we expect, but it is 
 * missing values for the first two rows. In contrast the call using FROM LAST 
 * seems to be giving us a LAG of 2, rather than the third highest salary. In 
 * both cases we are not getting the result we expect because of the default 
 * windowing clause. What we wanted in this case was the following. 
 */
SELECT t.empno,
       t.ename,
       t.deptno,
       t.sal,
       NTH_VALUE(t.sal, 3) FROM FIRST OVER (ORDER BY t.sal
         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS third_lowest_sal,
       NTH_VALUE(t.sal, 3) FROM LAST OVER (ORDER BY t.sal
         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS third_highest_sal
FROM saimk.emp t
; 
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
   EMPNO    ENAME    DEPTNO    SAL      THIRD_LOWEST_SAL    THIRD_HIGHEST_SAL
   -----    ------   ------    ------   ----------------    -----------------
   7369     SMITH        20       800               1100                 3000
   7900     JAMES        30       950               1100                 3000  
   7876     ADAMS        20      1100               1100                 3000
   7521     WARD         30      1250               1100                 3000
   7654     MARTIN       30      1250               1100                 3000
   7934     MILLER       10      1300               1100                 3000
   7844     TURNER       30      1500               1100                 3000
   7499     ALLEN        30      1600               1100                 3000
   7782     CLARK        10      2450               1100                 3000
   7698     BLAKE        30      2850               1100                 3000
   7566     JONES        20      2975               1100                 3000
   7788     SCOTT        20      3000               1100                 3000
   7902     FORD         20      3000               1100                 3000
   7839     KING         10      5000               1100                 3000
 * ---------------------------------------------------------------------------- 
 *
 * Now we can see both the 3rd lowest and third highest salaries displaying as 
 * required.
 */
/*
 * Adding the partitioning clause allows us to limit the search within a 
 * partition. In the following example we want to display the second smallest 
 * and second largest salary, in addition to the employee data, on a department 
 * basis.
 */
SELECT t.empno,
       t.ename,
       t.deptno,
       t.sal,
       NTH_VALUE(t.sal, 2) FROM FIRST OVER (PARTITION BY t.deptno ORDER BY sal
         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS second_lowest_sal,
       NTH_VALUE(t.sal, 2) FROM LAST OVER (PARTITION BY t.deptno ORDER BY sal 
         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS second_highest_sal
FROM saimk.emp t
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
   EMPNO    ENAME    DEPTNO    SAL      SECOND_LOWEST_SAL    SECOND_HIGHEST_SAL
   -----    ------   ------    ------   -----------------    ------------------
   7934     MILLER       10      1300                2450                  2450
   7782     CLARK        10      2450                2450                  2450
   7839     KING         10      5000                2450                  2450
   7369     SMITH        20       800                1100                  3000
   7876     ADAMS        20      1100                1100                  3000
   7566     JONES        20      2975                1100                  3000
   7788     SCOTT        20      3000                1100                  3000
   7902     FORD         20      3000                1100                  3000
   7900     JAMES        30       950                1250                  1600
   7654     MARTIN       30      1250                1250                  1600
   7521     WARD         30      1250                1250                  1600
   7844     TURNER       30      1500                1250                  1600
   7499     ALLEN        30      1600                1250                  1600
   7698     BLAKE        30      2850                1250                  1600
 * ---------------------------------------------------------------------------- 
 */
/* ---------------------------------------------------------------------------*/ 