/*
 * Source: http://www.dba-oracle.com/t_email_validation_regular_expressions.htm
 
   Email Validation Check

   The email validation on the list of emails can be performed to check whether 
   any of them violate the rules of email ID creation.

   The below query statement selects the email IDs with the below rules,

   1. The starting character must be an alphabet which is handled by the 
      condition ^[A-Za-z].

   2. The first part of the mail ID must contain only alphabets, numbers and 
      periods which is handled by the condition [A-Za-z0-9.].

   3. The second part of the mail ID must be prefixed with an “at the rate of” 
      (@) symbol and may contain only alphabets, numbers, hyphens and periods in 
      them. This is handled by the condition @[A-Za-z0-9.-].

   4. The last and third part of the mail ID must be prefixed with a DOT 
      followed by alphabets not less than 2 and no more than 4. This is handled 
      by the condition \.[A-Za-z]{2,4}$. Here, \. Searches for the literal 
      character DOT.
*/   

WITH V1 AS(
SELECT 'msk@gmail.com' email FROM DUAL UNION
SELECT 'msk80@gmail.com' email FROM DUAL UNION
SELECT '1sk@gmail.com' email FROM DUAL UNION
SELECT 'mskgmail.com' FROM DUAL UNION
SELECT '1234567890@gmail.com' FROM DUAL --UNION
)
SELECT t.email valid_email 
FROM V1 t
WHERE REGEXP_LIKE(t.email, '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
;