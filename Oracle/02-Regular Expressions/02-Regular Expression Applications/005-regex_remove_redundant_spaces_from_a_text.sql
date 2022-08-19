/*
 * The following example examines the string, looking for two or more spaces. 
 * Each occurrence of two or more spaces will be replaced by a single space.
 */

WITH V1 AS(
  SELECT 'the   web     development    tutorial  w3resource.com' TEXT FROM DUAL
)
SELECT t.text, REGEXP_REPLACE(t.TEXT, '( ){2,}', ' ') redundant_spaces_removed_text
FROM V1 t
;

/*
 * OUTPUT:
 * --------------------------------------------------------------------------------------------------------
   TEXT                                                        REDUNDANT_SPACES_REMOVED_TEXT
   --------------------------------------------------------------------------------------------------------
   the   web     development    tutorial  w3resource.com	   the web development tutorial w3resource.com
 * --------------------------------------------------------------------------------------------------------
 */