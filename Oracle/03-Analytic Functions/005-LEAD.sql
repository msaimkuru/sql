/*
 * -----------------------------------------------------------------------------
 * Resource:
 * ----------------------------------------------------------------------------- 
 * https://oracle-base.com/articles/misc/lag-lead-analytic-functions#lead
 * -----------------------------------------------------------------------------  
 */ 
/*
 * ----------------------------------------------------------------------------
 * LEAD Analytic Function
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
 * The LEAD function is used to return data from rows further down the result 
 * set. The following query returns the salary from the next row to calculate 
 * the difference between the salary of the current row and the following row.
 * ---------------------------------------------------------------------------- 
 */
SELECT t.empno,
       t.ename,
       t.job,
       t.sal,
       LEAD(t.sal, 1, 0) OVER (ORDER BY t.sal) AS sal_next,
       LEAD(t.sal, 1, 0) OVER (ORDER BY t.sal) - t.sal AS sal_diff
FROM saimk.emp t
;

/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO    ENAME    JOB         SAL    SAL_NEXT    SAL_DIFF
     -----    ------   ---------   -----  --------    --------  
      7369    SMITH    CLERK        800        950         150
      7900    JAMES    CLERK        950       1100         150
      7876    ADAMS    CLERK       1100       1250         150
      7521    WARD     SALESMAN    1250       1250           0
      7654    MARTIN   SALESMAN    1250       1300          50
      7934    MILLER   CLERK       1300       1500         200
      7844    TURNER   SALESMAN    1500       1600         100
      7499    ALLEN    SALESMAN    1600       2450         850
      7782    CLARK    MANAGER     2450       2850         400
      7698    BLAKE    MANAGER     2850       2975         125
      7566    JONES    MANAGER     2975       3000          25
      7788    SCOTT    ANALYST     3000       3000           0
      7902    FORD     ANALYST     3000       5000        2000
      7839    KING     PRESIDENT   5000          0       -5000
 * ----------------------------------------------------------------------------       
 */
/* ---------------------------------------------------------------------------*/ 