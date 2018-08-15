/* Basics */

CREATE TABLE CUSTOMERS( 
   ID   INT              NOT NULL, 
   NAME VARCHAR (20)     NOT NULL, 
   AGE  INT              NOT NULL, 
   ADDRESS  CHAR (25) , 
   SALARY   DECIMAL (18, 2),        
   PRIMARY KEY (ID));

INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY) 
VALUES (1, 'Ron', 32, 'Washington', 20000.00 );
  
INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY) 
VALUES (2, 'David', 25, 'Washington', 150000.00 );  

INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY) 
VALUES (3, 'Karen', 23, 'Boston', 200000.00 );  

INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY) 
VALUES (4, 'Christopher', 25, 'Dallas', 65000.00 ); 
 
INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY) 
VALUES (5, 'Harry', 27, 'Boston', 85000.00 );  

INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY) 
VALUES (6, 'Krista', 22, 'Washington', 45000.00 );

/* DROP TABLE CUSTOMERS */

SELECT * FROM CUSTOMERS;
SELECT AGE, SALARY from CUSTOMERS WHERE SALARY > 45000;

SELECT * FROM CUSTOMERS ORDER BY SALARY;

SELECT ADDRESS, AVG(SALARY) AS MEAN_SALARY FROM CUSTOMERS GROUP BY ADDRESS;

UPDATE CUSTOMERS 
  SET ADDRESS='Boston' WHERE ID=4;
  
DELETE FROM CUSTOMERS; /* DROP removes entire table, DELETE just removes the data */


/* Using sample data */



select * from CRS1 
	INNER JOIN Donors on CRS1.DONOR=Donors.DONOR
	INNER JOIN Recipients on CRS1.RECIPIENT=Recipients.RECIPIENT
	INNER JOIN Flows on CRS1.FLOW=Flows.FLOW
	WHERE Donors.DDescription='United States' AND Recipients.RDescription='India' AND Flows.FDescription LIKE 'Official%'
	ORDER BY YEAR;
	
	
select * from CRS1 
	INNER JOIN Donors on CRS1.DONOR=Donors.DONOR
	INNER JOIN Recipients on CRS1.RECIPIENT=Recipients.RECIPIENT
	INNER JOIN Flows on CRS1.FLOW=Flows.FLOW
	INNER JOIN Sectors on CRS1.SECTOR=Sectors.SECTOR
	WHERE Donors.DDescription='United States' AND Recipients.RDescription='India' AND Flows.FDescription LIKE 'Official%' AND
	  Sectors.SDescription='Total All Sectors' 
	ORDER BY YEAR;
	
	select Donors.DDescription, Recipients.RDescription, Sectors.SDescription, CRS1.YEAR, CRS1.Value into TMPTBL  from CRS1 
	INNER JOIN Donors on CRS1.DONOR=Donors.DONOR
	INNER JOIN Recipients on CRS1.RECIPIENT=Recipients.RECIPIENT
	INNER JOIN Flows on CRS1.FLOW=Flows.FLOW
	INNER JOIN Sectors on CRS1.SECTOR=Sectors.SECTOR
	WHERE Donors.DDescription='United States' AND Recipients.RDescription='India' AND Flows.FDescription LIKE 'Official%' AND
	  Sectors.SDescription='Total All Sectors' 
	ORDER BY YEAR;
