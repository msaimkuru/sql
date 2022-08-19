/*
 * Example 1: 
 * ----------
 * If First 2 and Last 2 characters of a string are digits, then let's change 
 * the other characters of this string with 7 asterisk (*) characters.
 */
 
WITH V1 AS(
    SELECT 1 ID, '1234567890' text FROM DUAL UNION
    SELECT 2 ID, '1234567c890' text FROM DUAL UNION
    SELECT 3 ID, 'a1234567890' text FROM DUAL UNION 
    SELECT 4 ID, '1234567890z' text FROM DUAL 

)
SELECT t.ID, t.text
      ,(CASE WHEN REGEXP_LIKE(t.text, '(^[[:digit:]]{2})(.*)([[:digit:]]{2}$)') THEN 'Yes' ELSE 'No' END) is_masked
      ,REGEXP_REPLACE(t.text, '(^[[:digit:]]{2})(.*)([[:digit:]]{2}$)','\1*******\3') masked_text
FROM V1 t
ORDER BY t.ID
;

/*
 * OUTPUT:
 * -----------------------------------------------------------------------------
   ID     text                  IS_MASKED     MASKED_TEXT
   -----------------------------------------------------------------------------
   1      1234567890            Yes           12*******90
   2      1234567c890           Yes           12*******90
   3      a1234567890           No            a1234567890
   4      1234567890z           No            1234567890z
 * -----------------------------------------------------------------------------
 */

/*
 * Source:
 * -------
 * https://stackoverflow.com/questions/57291580/string-masking-with-regex-at-oracle
 *
 * Example 2: 
 * ----------
 * We want to mask name and surname in Oracle. For example; John Smith => Jo** Sm**
 * We want every 2 subsequent word character followed by any 1 or more word 
 * character replaced with 2 asteric characters.
 *
 * Note: 
 * -----
 * Word character (\w) matches any single letter, number or underscore.
 */
 
WITH V1 AS(
    SELECT 1 ID, 'John Smith' text FROM DUAL UNION
    SELECT 2 ID, 'John.Smith' text FROM DUAL UNION
    SELECT 3 ID, 'John.Smith.' text FROM DUAL UNION 
    SELECT 4 ID, '.John.Smith.' text FROM DUAL UNION
    SELECT 5 ID, 'Jo Smith' text FROM DUAL UNION
    SELECT 6 ID, 'Jo Sm' text FROM DUAL UNION
    SELECT 7 ID, '222 3333 55555' text FROM DUAL UNION
    SELECT 8 ID, '___' text FROM DUAL 
)
SELECT REGEXP_REPLACE(t.text, '(\w{2})\w+', '\1**') masked_text
,(CASE WHEN REGEXP_LIKE(t.text, '(\w{2})\w+') THEN 'Yes' ELSE 'No' END) is_masked
,REGEXP_SUBSTR(t.text, '(\w{2})\w+', 1,1) first_masked_data
,REGEXP_SUBSTR(t.text, '(\w{2})\w+', 1,2) second_masked_data
FROM V1 t
ORDER BY t.ID
;

/*
 * OUTPUT:
 * -----------------------------------------------------------------------------
   MASKED_TEXT        IS_MASKED     FIRST_MASKED_DATA     SECOND_MASKED_DATA
   -----------------------------------------------------------------------------
   Jo** Sm**          Yes           John                  Smith
   Jo**.Sm**          Yes           John                  Smith
   Jo**.Sm**.         Yes           John                  Smith
   .Jo**.Sm**.        Yes           John                  Smith
   Jo Sm**            Yes           Smith                 (null)
   Jo Sm              No            (null)                (null)
   22** 33** 55**     Yes           222                   3333
   __**               Yes           ___                   (null)
 * -----------------------------------------------------------------------------
 */