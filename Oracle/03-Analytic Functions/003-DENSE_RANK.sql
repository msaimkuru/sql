/*
 * -----------------------------------------------------------------------------
 * Resource:
 * ----------------------------------------------------------------------------- 
 * https://oracle-base.com/articles/misc/rank-dense-rank-first-last-analytic-functions#dense_rank
 * -----------------------------------------------------------------------------  
 */ 
/*
 * ----------------------------------------------------------------------------
 * DENSE_RANK Analytic Function
 * ---------------------------------------------------------------------------- 
 * The basic description for the DENSE_RANK analytic function is shown below.
 *
 * DENSE_RANK() OVER([ query_partition_clause ] order_by_clause)
 *
 * The DENSE_RANK function acts like the RANK function except that it assigns 
 * consecutive ranks.
 */
SELECT t.empno,
       t.deptno,
       t.sal,
       DENSE_RANK() OVER (PARTITION BY t.deptno ORDER BY t.sal) as myrank
FROM saimk.emp t
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO      DEPTNO      SAL      MYRANK
     -----      ------     ----      ------
      7934          10     1300           1
      7782          10     2450           2
      7839          10     5000           3
      7369          20      800           1
      7876          20     1100           2
      7566          20     2975           3
      7788          20     3000           4
      7902          20     3000           4
      7900          30      950           1
      7654          30     1250           2
      7521          30     1250           2
      7844          30     1500           3
      7499          30     1600           4
      7698          30     2850           5
 * ---------------------------------------------------------------------------- 
 * What we see here is where two people have the same salary they are assigned 
 * the same rank. When multiple rows share the same rank the next rank in the 
 * sequence is consecutive. For example empno 7844 took value 3 instead 
 * of taking value of 4 where it would be with RANK function.This is where 
 * DENSE_RANK function differs from RANK function.
 */
/*
 * ----------------------------------------------------------------------------
 * Top-N Queries By Means Of DENSE_RANK()
 * ----------------------------------------------------------------------------
 * As with the RANK analytic function, we can do a Top-N query on a 
 * per-department basis. The example below assigns the dense rank in the inline 
 * view, then uses that rank to restrict the rows to the top 2 (best paid) 
 * employees in each department.
 * 
 * ---------------------------------------------------------------------------- 
 */
SELECT v1.*
FROM (SELECT t.empno,
             t.deptno,
             t.sal,
             DENSE_RANK() OVER (PARTITION BY t.deptno ORDER BY t.sal) AS myrank
      FROM saimk.emp t
     )v1
WHERE v1.myrank <= 2
;
/*
 * ----------------------------------------------------------------------------
 * OUTPUT:
 * ---------------------------------------------------------------------------- 
     EMPNO     DEPTNO        SAL     MYRANK
   ------- ---------- ---------- ----------
      7934         10       1300          1
      7782         10       2450          2
      7369         20        800          1
      7876         20       1100          2
      7900         30        950          1
      7521         30       1250          2
      7654         30       1250          2
 * ----------------------------------------------------------------------------       
 */
/* ---------------------------------------------------------------------------*/ 