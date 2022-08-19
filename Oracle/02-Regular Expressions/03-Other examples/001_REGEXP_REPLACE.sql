/*
 *  Source: https://www.w3resource.com/oracle/character-functions/oracle-regexp_replace-function.php#h_one
 */
 
/*
 *
    Grouping Classes:
    
    Character	Description
    [ ]	Matches any character in the set
    Example. [ABC] - matches any of a, b, or c
    ( )	Capture groups of sequence character together
    Example. (name) - matches sequence of group character
*/

/*
 * Example 1: case-sensitive
 */
 
SELECT REGEXP_REPLACE('ABCDEFGHIJdgij', '[DGI]', 'X', 1, 0, 'c') change_dgi 
FROM DUAL
;--> Result: ABCXEFXHXJdgij

/* 
 *  Example 2: ignore-case
 */
 
SELECT REGEXP_REPLACE('ABCDEFGHIJdgij', '[DGI]', 'X', 1, 0, 'i') 
FROM DUAL
;--> Result: ABCXEFXHXJXXXj

/*
 * Example 3: 
 * ----------
 * The following example examines country_name and puts a space after each 
 * non-null character in the string.
 */

WITH V1 AS(
SELECT 1 ID, 'Argentina' country FROM DUAL UNION
SELECT 2 ID, 'Canada' country FROM DUAL UNION
SELECT 3 ID, 'Germany' country FROM DUAL UNION
SELECT 4 ID, 'Ireland' country FROM DUAL   
)
SELECT v1.ID,
REGEXP_REPLACE(v1.country, '(.)', '\1 ') "REGEXP_REPLACE"
FROM v1
ORDER BY v1.ID;

/*
 * OUTPUT:
 * -------------------------------------------
   ID	REGEXP_REPLACE
   -------------------------------------------
    1	A r g e n t i n a 
    2	C a n a d a 
    3	G e r m a n y 
    4	I r e l a n d    
 * -------------------------------------------
 */

/*
 * Example 4 
 * ----------
 * The following example examines the string, looking for two or more spaces. 
 * Each occurrence of two or more spaces will be replaced by a single space.
 */

SELECT REGEXP_REPLACE('the   web     development    tutorial  w3resource.com', '( ){2,}', ' ') "REGEXP_REPLACE"
FROM DUAL
;

/*
 * OUTPUT:
 * -------------------------------------------
   REGEXP_REPLACE
   -------------------------------------------
   the web development tutorial w3resource.com
 * -------------------------------------------  
 */

/*
 * Example 5:
 * ----------
 * The following example examines phone_number, looking for the pattern 
 * xxx.xxx.xxxx. Oracle reformats this pattern with (xxx) xxx-xxxx
 */
WITH V1 AS(
SELECT 1 ID, '089.871.3242' phone_number FROM DUAL UNION
SELECT 2, '089-8713242' phone_number FROM DUAL UNION
SELECT 3, '(089)8713242' phone_number FROM DUAL UNION
SELECT 4, '0898713242' phone_number FROM DUAL   
)
SELECT v1.ID,
REGEXP_REPLACE(V1.phone_number,
'([[:digit:]]{3})(.)*([[:alpha:]]*[[:digit:]]{3})(.)*([[:alpha:]]*[[:digit:]]{4})',
'(\1) \3-\5') "REGEXP_REPLACE"
FROM V1
ORDER BY v1.ID, "REGEXP_REPLACE";