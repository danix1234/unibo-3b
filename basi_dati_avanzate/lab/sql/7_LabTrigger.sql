--esempi
--1. A fronte dell’inserimento di un nuovo ordine, se il campo data è NULL assegna la data di oggi
create or replace TRIGGER trg_before_ord_insr_data
BEFORE INSERT
  ON nw_orders
  FOR EACH ROW
BEGIN
  if :NEW.ORDERDATE is NULL then
    :NEW.ORDERDATE := sysdate;
  end if;
END;

--Testing
ALTER TRIGGER trg_before_ord_insr_data ENABLE; 

INSERT INTO nw_orders VALUES ('20000','BONAP','9','20852',null,null,null,'2','38,28','Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');

SELECT * from nw_orders WHERE orderid=20000

--2. Data tracking: log dei cambiamenti di prezzo dei prodotti
CREATE SEQUENCE nw_track_id
  START WITH 1
  INCREMENT BY 1;

CREATE TABLE nw_data_tracking (
IDtracking INT PRIMARY KEY ,
IDprod INT NOT NULL ,
old_value INT NOT NULL ,
new_value INT NOT NULL ,
dateModified DATE NOT NULL,
userModified varchar2(20)
); 


create or replace TRIGGER trg_price
AFTER UPDATE OF unitprice 
  ON nw_products
  FOR EACH ROW
  
BEGIN
IF (:NEW.unitprice != :OLD.unitprice) THEN
        INSERT INTO nw_data_tracking 
        values(nw_track_id.nextval, :OLD.productid,:OLD.unitprice, :NEW.unitprice, sysdate,user);
    END IF;
END

--Testing
ALTER TRIGGER trg_price ENABLE; 

UPDATE nw_products 
SET unitprice=unitprice+1
WHERE productid=1;

SELECT * FROM nw_data_tracking;


--3. Calcola alcune statistiche sugli ordini a fronte di variazioni nella tabella ordini
-- Data la tabella riassuntiva order_stats : 

CREATE TABLE order_stats as
SELECT
   EXTRACT (year FROM orderdate) as year,
   count (Distinct customerid) as numCust,
   count (*) as numOrd
   FROM
    nw_orders
    GROUP BY EXTRACT (year FROM orderdate)
    ORDER BY 1
	
--	Aggiorna la tabella a fronte di variazioni nella tabella ordini
CREATE OR REPLACE TRIGGER trg_stat_orders AFTER INSERT OR DELETE OR UPDATE ON nw_orders 
DECLARE CURSOR c_statistics IS
SELECT EXTRACT(year FROM orderdate) as year, count (Distinct customerid) as numCust,
        count (*) as numOrd FROM nw_orders
       GROUP BY EXTRACT (year FROM orderdate)
BEGIN
    FOR v_statsRecord IN c_statistics LOOP
         UPDATE order_stats
             SET numCust = v_statsRecord.numCust,numOrd = v_statsRecord.numOrd
             WHERE year = v_statsRecord.year;
         IF SQL%NOTFOUND THEN
             INSERT INTO order_stats(year, numCust, numOrd)
             VALUES (v_statsRecord.year,v_statsRecord.numCust, v_statsRecord.numOrd);
        END IF;
    END LOOP;
END trg_stat_orders;

--Testing
ALTER TRIGGER trg_stat_orders ENABLE; 

INSERT INTO nw_orders VALUES ('20001','BONAP','9','20852',null,null,null,'2','38,28','Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');

SELECT * from order_stats;

	
-------------------------------------------------------------------------------------------------
--Esercizi
--preparazione
create table NW_Products as select *  from NW.Products;
create table NW_Orders as select *  from NW.Orders;
create table NW_OrderDetails as select *  from NW.OrderDetails;


--test
SELECT * FROM NW_EMPLOYEERANK ;
Insert into NW_ORDERS values ('11078','BONAP','9','20852',to_date('07-MAG-98','DD-MON-RR'),to_date('04-GIU-98','DD-MON-RR'),null,'2','38,28','Bon app''','12, rue des Bouchers','Marseille',null,'13008','France');
Insert into NW_ORDERS values ('11079','RATTC','1','19713',to_date('07-MAG-98','DD-MON-RR'),to_date('04-GIU-98','DD-MON-RR'),null,'2','8,53','Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque','NM','87110','USA');
SELECT * FROM NW_EMPLOYEERANK ;

Insert into NW_orderdetails (ORDERID,PRODUCTID,UNITPRICE,QUANTITY,DISCOUNT) values ('11078','8','40','2','0,1');
Insert into NW_orderdetails (ORDERID,PRODUCTID,UNITPRICE,QUANTITY,DISCOUNT) values ('11078','10','31','1','0');
Insert into NW_orderdetails (ORDERID,PRODUCTID,UNITPRICE,QUANTITY,DISCOUNT) values ('11078','11','21','30','0,05');
Insert into NW_orderdetails (ORDERID,PRODUCTID,UNITPRICE,QUANTITY,DISCOUNT) values ('11078','20','81','100','0,04');


delete from NW_orders where orderid=11078;
delete from NW_orders where orderid=11079;
SELECT * FROM NW_EMPLOYEERANK ;



