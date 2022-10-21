/*
 * -----------------------------------------------------------------------------
 * Resource:
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html
 * -----------------------------------------------------------------------------
 */
/*
 * -----------------------------------------------------------------------------
 * Prerequisite SQL
 * -----------------------------------------------------------------------------
 */

DROP TABLE saimk.bricks;

CREATE TABLE saimk.bricks (
  colour   VARCHAR2(10),
  shape    VARCHAR2(10)
);

DROP TABLE saimk.colours;

CREATE TABLE saimk.colours (
  colour        VARCHAR2(10),
  rgb_hex_value VARCHAR2(6)
);

DROP TABLE saimk.cuddly_toys;

CREATE TABLE saimk.cuddly_toys (
  toy_name VARCHAR2(20),
  colour   VARCHAR2(10)
);

DROP TABLE saimk.pens;

CREATE TABLE saimk.pens (
  colour   VARCHAR2(10),
  pen_type VARCHAR2(10)
);

COMMENT ON TABLE saimk.bricks IS 
'Created for How to Get and Read Execution Plans tutorial on https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html'
;

COMMENT ON TABLE saimk.colours IS 
'Created for How to Get and Read Execution Plans tutorial on https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html'
;

COMMENT ON TABLE saimk.cuddly_toys IS 
'Created for How to Get and Read Execution Plans tutorial on https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html'
;

COMMENT ON TABLE saimk.pens IS 
'Created for How to Get and Read Execution Plans tutorial on https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html'
;

INSERT INTO saimk.cuddly_toys VALUES ( 'Miss Snuggles', 'pink' );
INSERT INTO saimk.cuddly_toys VALUES ( 'Cuteasaurus', 'blue' );
INSERT INTO saimk.cuddly_toys VALUES ( 'Baby Turtle', 'green' );
INSERT INTO saimk.cuddly_toys VALUES ( 'Green Rabbit', 'green' );
INSERT INTO saimk.cuddly_toys VALUES ( 'White Rabbit', 'white' );

INSERT INTO saimk.colours VALUES ( 'red' , 'FF0000' ); 
INSERT INTO saimk.colours VALUES ( 'blue' , '0000FF' ); 
INSERT INTO saimk.colours VALUES ( 'green' , '00FF00' ); 

INSERT INTO saimk.bricks VALUES ( 'red', 'cylinder' );
INSERT INTO saimk.bricks VALUES ( 'blue', 'cube' );
INSERT INTO saimk.bricks VALUES ( 'green', 'cube' );

INSERT INTO saimk.bricks
  SELECT * FROM saimk.bricks;
  
INSERT INTO saimk.bricks
  SELECT * FROM saimk.bricks;
  
INSERT INTO saimk.bricks
  SELECT * FROM saimk.bricks;

INSERT INTO saimk.pens VALUES ( 'black', 'ball point' );
INSERT INTO saimk.pens VALUES ( 'black', 'permanent' );
INSERT INTO saimk.pens VALUES ( 'blue', 'ball point' );
INSERT INTO saimk.pens VALUES ( 'green', 'permanent' );
INSERT INTO saimk.pens VALUES ( 'green', 'dry-wipe' );
INSERT INTO saimk.pens VALUES ( 'red', 'permanent' );
INSERT INTO saimk.pens VALUES ( 'red', 'dry-wipe' );
INSERT INTO saimk.pens VALUES ( 'blue', 'permanent' );
INSERT INTO saimk.pens VALUES ( 'blue', 'dry-wipe' );

COMMIT;

EXEC dbms_stats.gather_table_stats ( null, 'pens' ) ;
EXEC dbms_stats.gather_table_stats ( null, 'colours' ) ;
EXEC dbms_stats.gather_table_stats ( null, 'bricks' ) ;
EXEC dbms_stats.gather_table_stats ( null, 'cuddly_toys' ) ;
/*----------------------------------------------------------------------------*/