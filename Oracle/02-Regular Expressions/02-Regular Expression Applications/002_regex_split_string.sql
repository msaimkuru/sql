/*
 * 1st Parameter: String to split
 * 2nd Parameter: Delimiter to split the string 
 */

WITH V1 AS(
SELECT 'A,Bx,Cy,D' text FROM DUAL
)
SELECT LEVEL AS ID, REGEXP_SUBSTR(t.text, '[^,]+', 1, LEVEL) AS splitted_text_data
FROM V1 t
CONNECT BY REGEXP_SUBSTR(t.text, '[^,]+', 1, LEVEL) IS NOT NULL
;

/*
 * ----------------------------------------------------------------------------
   OUTPUT:
   ----------------------------------------------------------------------------
   ID   SPLITTED_TEXT_DATA
   ----------------------------------------------------------------------------    
   1    A
   2    Bx
   3    Cy
   4    D
 * ----------------------------------------------------------------------------    
 */