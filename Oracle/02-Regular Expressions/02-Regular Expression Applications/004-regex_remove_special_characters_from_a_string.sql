/*
 * Source: https://www.oracletutorial.com/oracle-string-functions/oracle-regexp_replace/
 */   

/*
 * Example 1.1: Let's list all special characters in the string.
 *
 * NOTE: 
 * CONNECT BY LEVEL can be used without effecting the number of rows 
 * returned because there is only 1 row in V1.
 */

WITH V1 AS(
    SELECT '1.Th♥is∞ is a dem☻o of REGEXP_♫REPLACE function' text FROM DUAL
)
SELECT REGEXP_SUBSTR(t.text, '[^a-z_A-Z[:digit:]/. ]', 1, LEVEL) special_characters, LEVEL
FROM V1 t
CONNECT BY LEVEL <= REGEXP_COUNT(t.text, '[^a-z_A-Z[:digit:]/. ]')
;

/*
 * OUTPUT:
 * ------------------------------
   SPECIAL_CHARACTERS       LEVEL
   ------------------------------
   ♥                        1
   ∞                        2
   ☻                        3
   ♫                        4
 * ------------------------------
 */

/*
 * Example 1.2: Remove the special characters from the string
 */

WITH V1 AS(
    SELECT '1.Th♥is∞ is a dem☻o of REGEXP_♫REPLACE function' text FROM DUAL
)
SELECT t.text
      ,REGEXP_REPLACE(text, '[^a-z_A-Z[:digit:]/. ]', '') special_characters_removed_text
      ,REGEXP_REPLACE(text, '[a-z_A-Z[:digit:]/. ]', '') special_characters  
FROM V1 t
;

/*
 * OUTPUT:
 * ----------------------------------------------------------------------------------------------------------------------
   TEXT                                               SPECIAL_CHARACTERS_REMOVED_TEXT	               SPECIAL_CHARACTERS
   ----------------------------------------------------------------------------------------------------------------------
   Th♥is∞ is a dem☻o of REGEXP_♫REPLACE function	  This is a demo of REGEXP_REPLACE function	       ♥∞☻♫
 * ----------------------------------------------------------------------------------------------------------------------
 */