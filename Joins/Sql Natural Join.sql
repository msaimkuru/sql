/* --------------------------------------------------------------------------------
 * NATURAL JOIN
 * Natural Join joins two tables based on same attribute name and datatypes. 
 * The resulting table will contain all the attributes of both the table but keep 
 * only one copy of each common column. 
 * --------------------------------------------------------------------------------
 * Resultset of the query below;

        --------------------------------
        SUB_VALUE     MAIN_VALUE    TXT
        --------------------------------
        20            10            Z
        30            10            W
        --------------------------------
 */

WITH V1 AS
(SELECT 10 SUB_VALUE, NULL MAIN_VALUE FROM DUAL UNION
 SELECT 20 SUB_VALUE, 10 MAIN_VALUE FROM DUAL UNION
 SELECT 21 SUB_VALUE, 10 MAIN_VALUE FROM DUAL UNION
 SELECT 22 SUB_VALUE, 10 MAIN_VALUE FROM DUAL UNION
 SELECT 30 SUB_VALUE, 10 MAIN_VALUE FROM DUAL
),
V2 AS(
 --
 SELECT 200 SUB_VALUE, 20 MAIN_VALUE, 'X' TXT FROM DUAL UNION
 SELECT 10 SUB_VALUE, 20 MAIN_VALUE, 'Y' TXT  FROM DUAL UNION
 SELECT 20 SUB_VALUE, 10 MAIN_VALUE, 'Z' TXT  FROM DUAL UNION
 SELECT 21 SUB_VALUE, 30 MAIN_VALUE, 'T' TXT  FROM DUAL UNION 
 SELECT 30 SUB_VALUE, 10 MAIN_VALUE, 'W' TXT  FROM DUAL
)
SELECT *
FROM V1 NATURAL JOIN V2
;