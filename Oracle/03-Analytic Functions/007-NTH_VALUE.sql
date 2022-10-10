/*
 * -----------------------------------------------------------------------------
 * Resource:
 * ----------------------------------------------------------------------------- 
 * https://oracle-base.com/articles/misc/rank-dense-rank-first-last-analytic-functions#rank
 * -----------------------------------------------------------------------------  
 */ 
/*
 * ----------------------------------------------------------------------------
 * RANK Analytic Function
 * ---------------------------------------------------------------------------- 
 * The basic description for the RANK analytic function is shown below.
 *
 * RANK() OVER ([ query_partition_clause ] order_by_clause)
 */
SELECT t.empno,
       t.deptno,
       t.sal,
       RANK() OVER (PARTITION BY t.deptno ORDER BY t.sal) as myrank
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
      7844          30     1500           4
      7499          30     1600           5
      7698          30     2850           6
 * ---------------------------------------------------------------------------- 
 * What we see here is where two people have the same salary they are assigned 
 * the same rank. When multiple rows share the same rank the next rank in the 
 * sequence is not consecutive. For example empno 7844 took value of 4 instead 
 * of taking 3.
 *
 * This is like olympic medaling in that if two 
 * people share the gold, there is no silver medal etc.
 */
/*
 * ----------------------------------------------------------------------------
 * Top-N Queries By Means Of RANK()
 * ----------------------------------------------------------------------------
 * The fact we can rank the rows in the department means we are able to do a 
 * Top-N query on a per-department basis. 
 * 
 * The example below assigns the rank in the inline view, then uses that rank to 
 * restrict the rows to the bottom 2 (worst paid) employees in each department.
 * ---------------------------------------------------------------------------- 
 */
SELECT v1.*
FROM (SELECT t.empno,
             t.deptno,
             t.sal,
             RANK() OVER (PARTITION BY t.deptno ORDER BY t.sal) AS myrank
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