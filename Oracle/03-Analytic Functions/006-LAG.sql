/*
 * -----------------------------------------------------------------------------
 * Resource:
 * ----------------------------------------------------------------------------- 
 * https://oracle-base.com/articles/misc/lag-lead-analytic-functions#lag
 * -----------------------------------------------------------------------------  
 */ 
/*
 * ----------------------------------------------------------------------------
 * LAG Analytic Function
 * ---------------------------------------------------------------------------- 
 * Both LAG and LEAD functions have the same usage, as shown below.
 *
    LAG
      { ( value_expr [, offset [, default]]) [ { RESPECT | IGNORE } NULLS ] 
      | ( value_expr [ { RESPECT | IGNORE } NULLS ] [, offset [, default]] )
      }
      OVER ([ query_partition_clause ] order_by_clause)
    
    LEAD
      { ( value_expr [, offset [, default]] ) [ { RESPECT | IGNORE } NULLS ] 
      | ( value_expr [ { RESPECT | IGNORE } NULLS ] [, offset [, default]] )
      }
      OVER ([ query_partition_clause ] order_by_clause)

 * value_expr - Can be a column or a built-in function, except for other 
 *              analytic functions.
 *     offset - The number of rows preceeding/following the current row, from 
                which the data is to be retrieved. The default value is 1.
 *    default - The value returned if the offset is outside the scope of the 
 *              window. The default value is NULL.
 * ----------------------------------------------------------------------------  
 */
/*
 * Looking at the EMP table, we query the data in salary (SAL) order.
 */
SELECT t.empno,
       t.ename,
       t.job,
       t.sal
FROM saimk.emp t
ORDER BY t.sal
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO    ENAME     JOB           SAL
     -----    ------    --------      ------     
     7369     SMITH     CLERK            800
     7900     JAMES     CLERK            950
     7876     ADAMS     CLERK           1100
     7521     WARD      SALESMAN        1250
     7654     MARTIN    SALESMAN        1250
     7934     MILLER    CLERK           1300
     7499     ALLEN     SALESMAN        1600
     7782     CLARK     MANAGER         2450
     7698     BLAKE     MANAGER         2850
     7566     JONES     MANAGER         2975
     7788     SCOTT     ANALYST         3000
     7902     FORD      ANALYST         3000
     7839     KING      PRESIDENT       5000
 * ---------------------------------------------------------------------------- 
 */
/*
 * The LAG function is used to access data from a previous row. The following 
 * query returns the salary from the previous row to calculate the difference 
 * between the salary of the current row and that of the previous row. Notice 
 * that the ORDER BY of the LAG function is used to order the data by salary.
 * ---------------------------------------------------------------------------- 
 */
SELECT t.empno,
       t.ename,
       t.job,
       t.sal,
       LAG(t.sal, 1, 0) OVER (ORDER BY t.sal) AS sal_prev,
       t.sal - LAG(t.sal, 1, 0) OVER (ORDER BY t.sal) AS sal_diff
FROM saimk.emp t
;

/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO    ENAME    JOB         SAL    SAL_PREV    SAL_DIFF
     -----    ------   ---------   -----  --------    --------  
      7369    SMITH    CLERK        800          0         800
      7900    JAMES    CLERK        950        800         150
      7876    ADAMS    CLERK       1100        950         150
      7521    WARD     SALESMAN    1250       1100         150
      7654    MARTIN   SALESMAN    1250       1250           0
      7934    MILLER   CLERK       1300       1250          50
      7844    TURNER   SALESMAN    1500       1300         200
      7499    ALLEN    SALESMAN    1600       1500         100
      7782    CLARK    MANAGER     2450       1600         850
      7698    BLAKE    MANAGER     2850       2450         400
      7566    JONES    MANAGER     2975       2850         125
      7788    SCOTT    ANALYST     3000       2975          25
      7902    FORD     ANALYST     3000       3000           0
      7839    KING     PRESIDENT   5000       3000        2000
 * ----------------------------------------------------------------------------       
 */
/* ---------------------------------------------------------------------------*/ 