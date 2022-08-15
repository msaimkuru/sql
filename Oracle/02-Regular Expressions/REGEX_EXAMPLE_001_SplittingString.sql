/*
 * 1st Parameter: String to split
 * 2nd Parameter: Delimiter to split the string 
 */
SELECT LEVEL AS ID, REGEXP_SUBSTR('A,Bx,Cy,D', '[^,]+', 1, LEVEL) AS data
FROM dual
CONNECT BY REGEXP_SUBSTR('A,B,C,D', '[^,]+', 1, LEVEL) IS NOT NULL
;
/*
    ----------------------------------------------------------------------------
    OUTPUT
    ----------------------------------------------------------------------------
    ID	DATA
    ----------------------------------------------------------------------------    
    1	A
    2	Bx
    3	Cy
    4	D
    ----------------------------------------------------------------------------    
*/