/* 
 * -----------------------------------------------------------------------------
 * Examples are from the book
 *   Oracle Regular Expressions Pocket Reference (Pocket Reference (O'Reilly)) 
 *   (p. 6). O'Reilly Media. Kindle Edition. 
 * --------------------------
 */
 
/* 
 * Example 1:
 * -----------
 * REGEXP_LIKE searches, in this case, the park_name column to see whether 
 * it contains a string matching the pattern 'State Park‘. 
 * 
 * REGEXP_LIKE is similar to LIKE, but differs in one major respect:
 * LIKE requires its pattern to match the entire column value, 
 * whereas REGEXP_LIKE looks for its pattern anywhere within the column value.
 */

SELECT v1.park_name, REGEXP_INSTR(v1.park_name, 'State Park') position1
FROM SAIMK.park v1
WHERE REGEXP_LIKE(v1.park_name, 'State Park')
ORDER BY v1.park_name
;

/*
 * OUTPUT:
 * -----------------------------------------------------------------------------
   PARK_NAME                          POSITION1
   -----------------------------------------------------------------------------
   Fort Wilkins State Park            14
   Mackinac Island State Park         17
   Muskallonge Lake State Park        18
   Porcupine Mountains State Park     21
   Tahquamenon Falls State Park       19
 * -----------------------------------------------------------------------------
 */

/* 
 * Example 2: (METACHARACTER period (.)):
 * --------------------------------------
 * This query uses the regular expression METACHARACTER period (.), 
 * which matches any character. The expression does not look for three periods
 * followed by a dash followed by four periods. It looks for any three 
 * characters, followed by a dash, followed by any four characters. 
 * Because it matches any character, the period is a very commonly used 
 * regular expression metacharacter.
 *
 * Note:
 * -----
 * If you’re ever in doubt as to why REGEXP_LIKE reports the existence of a 
 * given pattern in a text value, use REGEXP_SUBSTR to extract that same pattern 
 * from the value in question, and you’ll see the text REGEXP_LIKE considered 
 * a match for your pattern.
 */

SELECT v1.park_name, REGEXP_SUBSTR(v1.description, '...-....') pattern_matching_text1
      ,REGEXP_SUBSTR(v1.description, '...-....', 1, 2) pattern_matching_text2
FROM SAIMK.park v1
WHERE REGEXP_LIKE(v1.description, '...-....')
;

/*
 * OUTPUT:
 * ------------------------------------------------------------------------------------
   PARK_NAME                          PATTERN_MATCHING_TEXT1     PATTERN_MATCHING_TEXT2
   ------------------------------------------------------------------------------------
   Färnebofjärden                     ack-thro                   (null)
   Mackinac Island State Park         800-44-P                   517-373-
   Fort Wilkins State Park            447-2757                   oup-camp
   Muskallonge Lake State Park        217-acre                   (null)
   Porcupine Mountains State Park     885-5275                   885-5275
   Skaftafell National Park           ond-larg                   (null)
   Gashaka-Gumti National Park        aka-Gumt                   are-kilo
   Jasper National Park               are-kilo                   (null)
   Pukaskwa National Park             807-229-                   (null)
 * ------------------------------------------------------------------------------------
 */
 
/*
 * Example 2.1:
 * ------------
 * It can be inconvenient to specify repetition by repeating the metacharacter,
 * so regular expression syntax allows you to follow a metacharacter with an 
 * indication of how many times you want that metacharacter to be repeated. 

   Table 1-1. Quantifiers used to specify repetition in a pattern 
   --------------------------------------------------------------
   Pattern        Matches
   --------------------------------------------------------------
   .*             Zero or more characters
   .+             One or more characters
   .?             Zero or one character
   .{3,4}         Three to four characters
   .{3,}          Three or more characters
   .{3}           Exactly three characters
 * --------------------------------------------------------------
 */

SELECT v1.park_name, REGEXP_SUBSTR(v1.description, '.{3}-.{4}') pattern_matching_text1
      ,REGEXP_SUBSTR(v1.description, '.{3}-.{4}', 1, 2) pattern_matching_text2
FROM SAIMK.park v1
WHERE REGEXP_LIKE(v1.description, '.{3}-.{4}')
;

/* 
 * Example 3: (BRACKET EXPRESSIONS, RANGES, CHARACTER CLASSES, and CARET (^) 
 *             as the first character within a bracket expression:
 * --------------------------------------------------------------------------
 * To specify a list of characters in square brackets ([ ]): 
 * Square brackets and their contents are referred to as bracket expressions, 
 * and define a specific subset of characters, any one of which can provide a 
 * single-character match.
 *
 * In this example, the bracket expressions each define the set of characters 
 * comprising the digits 0-9. 
 *
 * Following each list is a repeat count, either {3} or {4}.
 */

SELECT v1.park_name, REGEXP_SUBSTR(v1.description, '[0123456789]{3}-[0123456789]{4}') pattern_matching_text1
      ,REGEXP_SUBSTR(v1.description, '[0123456789]{3}-[0123456789]{4}', 1, 2) pattern_matching_text2
FROM SAIMK.park v1
WHERE REGEXP_LIKE(v1.description, '[0123456789]{3}-[0123456789]{4}')
ORDER BY v1.park_name
;

/*
 * OUTPUT:
 * ------------------------------------------------------------------------------------
   PARK_NAME                          PATTERN_MATCHING_TEXT1     PATTERN_MATCHING_TEXT2
   ------------------------------------------------------------------------------------	
   Fort Wilkins State Park            447-2757                   289-4210
   Mackinac Island State Park         373-1214                   (null)
   Porcupine Mountains State Park     885-5275                   885-5275
   Pukaskwa National Park             229-0801                   (null)
 * ------------------------------------------------------------------------------------
 */

/* 
 * Example 3.1 (RANGE OF CHARACTERS):
 * ----------------------------------
 * It’s painful to have to type out each of the digits 0-9, and it’s error-prone 
 * too, as you might skip a digit. A better solution is to specify a range of 
 * characters
 */
 
SELECT v1.park_name, REGEXP_SUBSTR(v1.description, '[0-9]{3}-[0-9]{4}') pattern_matching_text1
      ,REGEXP_SUBSTR(v1.description, '[0-9]{3}-[0-9]{4}', 1, 2) pattern_matching_text2
FROM SAIMK.park v1
WHERE REGEXP_LIKE(v1.description, '[0-9]{3}-[0-9]{4}')
ORDER BY v1.park_name
;

/* 
 * Example 3.2 (CHARACTER CLASSES):
 * --------------------------------
 * Even better, perhaps, in this case, is to use one of the named character 
 * classes. 
 *
 * Note: Character classes are supported only within bracket expressions. 
 * Thus you cannot write [:digit:]{3}, but instead must use [[:digit:]]{3}.
 */

SELECT v1.park_name, REGEXP_SUBSTR(v1.description, '[[:digit:]]{3}-[[:digit:]]{4}') pattern_matching_text1
      ,REGEXP_SUBSTR(v1.description, '[[:digit:]]{3}-[[:digit:]]{4}', 1, 2) pattern_matching_text2
FROM SAIMK.park v1
WHERE REGEXP_LIKE(v1.description, '[[:digit:]]{3}-[[:digit:]]{4}')
ORDER BY v1.park_name
;

/* 
 * Example 3.3 (CARET CHARACTER IN BRACKET EXPRESSIONS):
 * -----------------------------------------------------
 * You can even define a set of characters in terms of what it is not. 
 * The following example uses [^[:digit:]] to allow for any character other than 
 * a digit to separate the groups of a phone number: 
 * 
 * Any time you specify a caret (^) as the first character within a bracket 
 * expression, you are telling the regular expression engine to begin by 
 * including all possible characters in the set, and to then exclude only those 
 * that you list following the caret.
 */

SELECT v1.park_name, REGEXP_SUBSTR(v1.description, '[[:digit:]]{3}[^[:digit:]][[:digit:]]{4}') pattern_matching_text1
      ,REGEXP_SUBSTR(v1.description, '[[:digit:]]{3}[^[:digit:]][[:digit:]]{4}', 1, 2) pattern_matching_text2
FROM SAIMK.park v1
WHERE REGEXP_LIKE(v1.description, '[[:digit:]]{3}[^[:digit:]][[:digit:]]{4}')
ORDER BY v1.park_name
;

/*
 * OUTPUT:
 * -----------------------------------------------------------------------------------
   PARK_NAME                          PATTERN_MATCHING_TEXT1    PATTERN_MATCHING_TEXT2
   -----------------------------------------------------------------------------------
   Fort Wilkins State Park            447-2757                  289.4215
   Mackinac Island State Park         373-1214                  (null)
   Porcupine Mountains State Park     885-5275                  885-5275
   Pukaskwa National Park             229-0801                  (null)
   Tahquamenon Falls State Park       492.3415                  (null)
 * ----------------------------------------------------------------------------------
 */

/*
 * Example 3.3.1: Returns texts those having character(s) other than C, D, and E.
 */
WITH V1 AS
(SELECT 'CD' text FROM DUAL UNION 
 SELECT 'CDE'text FROM DUAL UNION
 SELECT 'CDEF'text FROM DUAL UNION
 SELECT 'FCDE'text FROM DUAL UNION
 SELECT 'FCDE1.'text FROM DUAL UNION
  SELECT '2CDE1F'text FROM DUAL 
)
SELECT t.*, REGEXP_SUBSTR(t.text, '[^CDE]') pattern_matching_text1
      ,REGEXP_SUBSTR(t.text, '[^CDE]', 1, 2) pattern_matching_text2
      ,REGEXP_SUBSTR(t.text, '[^CDE]', 1, 3) pattern_matching_text3
FROM V1 t
WHERE REGEXP_LIKE(t.text, '[^CDE]')
;

/*
 * OUTPUT:
 * ---------------------------------------------------------------------------------   
   TEXT     PATTERN_MATCHING_TEXT1   PATTERN_MATCHING_TEXT2   PATTERN_MATCHING_TEXT3
   ---------------------------------------------------------------------------------
   CDEF     F                        (null)                   (null)
   FCDE     F                        (null)                   (null)
   FCDE1.   F                        1                        .
   2CDE1F   2                        1                        F
 * ---------------------------------------------------------------------------------
 */
 
/*
 * Example 4.1: A more complex bracket expression
 * [[:digit:]A-Zxyza-c\-] includes all digits, the uppercase letters A through 
 * Z, lowercase x, y, and z, and lowercase a through c, and hyphen (-)
 */

WITH V1 AS
(SELECT 1 ID, '*' text FROM DUAL UNION 
 SELECT 2 ID, '?'text FROM DUAL UNION
 SELECT 3 ID, '-'text FROM DUAL UNION
 SELECT 4 ID, 'a'text FROM DUAL UNION
 SELECT 5 ID, 'b'text FROM DUAL UNION
 SELECT 6 ID, 'c'text FROM DUAL UNION
 SELECT 7 ID, 'd'text FROM DUAL UNION
 SELECT 8 ID, '1A'text FROM DUAL UNION
 SELECT 9 ID, '11'text FROM DUAL 
)
SELECT t.* 
      ,REGEXP_SUBSTR(t.text, '[[:digit:]A-Zxyza-c\-]') pattern_matching_text1
      ,REGEXP_SUBSTR(t.text, '[[:digit:]A-Zxyza-c\-]', 1, 2) pattern_matching_text2
FROM V1 t
WHERE REGEXP_LIKE(t.text, '[[:digit:]A-Zxyza-c\-]')
ORDER BY t.ID
;

/*
 * OUTPUT:
 * -----------------------------------------------------------------------------   
   ID  TEXT    PATTERN_MATCHING_TEXT1    PATTERN_MATCHING_TEXT2
   -----------------------------------------------------------------------------
   3   -       -                         (null)
   4   a       a                         (null)
   5   b       b                         (null)
   6   c       c                         (null)
   8   1A      1                         A
   9   11      1                         1
 * -----------------------------------------------------------------------------
 */
 
/*
 * Example 4.2: A more complex bracket expression
 * Returns texts those having;
 * a subtext composed of 2 or more characters of either a digit or a letter in 
 * range A-Z and followed by a letter in range a-z.
 */
 
WITH V1 AS
(SELECT 'ABC./DEfR1356' text FROM DUAL UNION 
 SELECT 'ABC./DEfR12q456zq'text FROM DUAL UNION
 SELECT '11a'text FROM DUAL UNION
 SELECT '1Aa'text FROM DUAL UNION
 SELECT '11A'text FROM DUAL
)
SELECT t.* 
      ,REGEXP_SUBSTR(t.text, '[[:digit:]A-Z]{2,}[a-z]{1,}') pattern_matching_text1
      ,REGEXP_SUBSTR(t.text, '[[:digit:]A-Z]{2,}[a-z]{1,}', 1, 2) pattern_matching_text2
FROM V1 t
WHERE REGEXP_LIKE(t.text, '[[:digit:]A-Z]{2,}[a-z]{1,}')
;

/*
 * OUTPUT:
 * -----------------------------------------------------------------------------
   TEXT               PATTERN_MATCHING_TEXT1   PATTERN_MATCHING_TEXT2
   -----------------------------------------------------------------------------
   ABC./DEfR1356      DEf	
   ABC./DEfR12q456zq  DEf                      R12q
   11a                11a                      (null)
   1Aa                1Aa                      (null)
 * -----------------------------------------------------------------------------
 */
 
/* 
 * Example 5 (ESCAPE CHARACTER(\)):
 * --------------------------------
 * Any time you want to use one of the regular expression metacharacters as a 
 * regular character, you must precede it with a backslash. If you want to use a 
 * backslash as a regular character, precede it with another backslash, as in \\. 
 * Be aware that the list of metacharacters changes inside square brackets ([]). 
 * Most lose their special meaning, and do not need to be escaped.
 *
 * This example returns rows with description column data having 
 * 3digits+period(.)+4digits pattern. This query will now find only parks with 
 * phone numbers delimited by periods in the description column. 
 * The \. tells the regular expression engine to look for a literal period.
 */

SELECT v1.park_name, REGEXP_SUBSTR(v1.description, '[[:digit:]]{3}\.[[:digit:]]{4}') pattern_matching_text1
      ,REGEXP_SUBSTR(v1.description, '[[:digit:]]{3}\.[[:digit:]]{4}', 1, 2) pattern_matching_text2
FROM SAIMK.park v1
WHERE REGEXP_LIKE(v1.description, '[[:digit:]]{3}\.[[:digit:]]{4}')
ORDER BY v1.park_name
;

/*
 * OUTPUT:
 * --------------------------------------------------------------------------------- 
   PARK_NAME                         PATTERN_MATCHING_TEXT1   PATTERN_MATCHING_TEXT2
   ---------------------------------------------------------------------------------
   Fort Wilkins State Park           289.4215                 (null)
   Tahquamenon Falls State Park      492.3415                 (null)
   ---------------------------------------------------------------------------------
 */