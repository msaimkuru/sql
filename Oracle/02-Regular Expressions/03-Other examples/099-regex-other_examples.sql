SELECT LEVEL, REGEXP_SUBSTR('abc12345cde.', '([[:digit:]]{2}|[[:alpha:]]{2})',1,LEVEL)pattern_matching_text
FROM DUAL CONNECT BY LEVEL <=5
;