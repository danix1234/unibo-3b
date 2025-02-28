--1. Procedura per stampare a video la stringa «Hello world»
CREATE OR REPLACE PROCEDURE HelloWorld AS 
v1 varchar2(12) :='Hello World!';
BEGIN
  DBMS_OUTPUT.PUT_LINE (v1);
END;

--2. Procedura per stampare a video il numero di prodotti
CREATE OR REPLACE PROCEDURE NumProdotti AS
nProd NUMBER(5,0);
BEGIN
  SELECT count(*) into nProd
  FROM NW.PRODUCTS ;
  DBMS_OUTPUT.PUT_LINE ('Numero di Prodotti:' || nProd);
END ;

--3. Procedura per stampare il numero di ordini N gestiti da un impiegato (in input). 
-- Se N>100 stampa «high», se minore di 50 stampa «low» altrimenti «medium» 

create or replace PROCEDURE ProdImp(idImp number) AS 
nOrd NUMBER(5,0); 
BEGIN
  SELECT count(*) into nOrd FROM NW.ORDERS
  WHERE EmployeeID=idImp ;
  IF (nOrd) > 100 THEN  
  DBMS_OUTPUT.PUT_LINE ('High:' || nOrd);
  ELSIF (nOrd) < 50 THEN  
	DBMS_OUTPUT.PUT_LINE ('Low:' || nOrd); 
  ELSE
	DBMS_OUTPUT.PUT_LINE ('Medium:' || nOrd);  
  END IF;
END;

--4. Stampa dei dati di un cliente dato il nome. Gestire l’assenza del cliente o la presenza di più di un record
create or replace PROCEDURE PrintCliente(Nome VARCHAR2) AS  
vCliente nw.CUSTOMERS%ROWTYPE;
BEGIN
  SELECT * into vCliente FROM nw.CUSTOMERS WHERE COMPANYNAME LIKE Nome;
  DBMS_OUTPUT.PUT_LINE ('Cliente: ' || vCliente.COMPANYNAME || ' ID: ' || vCliente.CUSTOMERID || ' contatto: ' || vCliente.CONTACTNAME);
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('Cliente non trovato');     						         
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE ('Nome cliente non univoco');    
END;

--5. Stampa N date a partire da una data iniziale
CREATE OR REPLACE PROCEDURE PrintDates(initDate DATE, numPrint NUMBER) IS
    v_counter    NUMBER(2) := 0;
BEGIN
  LOOP
    EXIT WHEN v_counter >= numPrint;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(initDate+v_counter,'DD FMMonth YYYY'));
    v_counter := v_counter + 1;
  END LOOP;
END;

CREATE OR REPLACE PROCEDURE PrintDates1(initDate DATE, numPrint NUMBER) IS
BEGIN
  for v_counter in 1 .. numPrint
  LOOP
    
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(initDate+v_counter,'DD FMMonth YYYY'));
   
  END LOOP;
END;

--6. Definire un cursore per visualizzare le categorie
CREATE PROCEDURE PrintCategories IS
   CURSOR cCat IS
      SELECT CATEGORYID, CATEGORYNAME, DESCRIPTION FROM nw.CATEGORIES ;
BEGIN
  FOR vCat IN cCat LOOP  -- implicit open/fetch
     DBMS_OUTPUT.PUT_LINE(vCat.CATEGORYNAME || ':  '  || vCat.DESCRIPTION);
  END LOOP; -- Chiusura implicita
END;


CREATE PROCEDURE PrintCategories IS
   CURSOR cCat IS
      SELECT CATEGORYID, CATEGORYNAME, DESCRIPTION FROM nw.CATEGORIES ;
	  
vCat cCat%ROWTYPE;	  
BEGIN
OPEN cCat;
   LOOP
      FETCH cCat INTO vCat;
      EXIT WHEN cCat%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(vCat.CATEGORYNAME || ':  '  || vCat.DESCRIPTION);
   END LOOP;
   CLOSE cCat;
END;

--7.Stampa di tutti i prodotti di una categoria (in input)
CREATE PROCEDURE PrintProd (vIDCat number) IS
   CURSOR cProd (pCat IN nw.CATEGORIES.CATEGORYID%TYPE) IS
   SELECT *  FROM nw.PRODUCTS WHERE  CATEGORYID=pCat;	  
BEGIN
FOR vProd IN cProd(vIDcat) LOOP
     DBMS_OUTPUT.PUT_LINE(vProd.PRODUCTID || ':  '  || vProd.PRODUCTNAME);
  END LOOP; 
END;


--8.Aumenta del 10% il prezzo dei prodotti
create table NW1_Products as
select *  from NW.Products;

CREATE PROCEDURE IncPrice  IS
   CURSOR cProd  IS
   SELECT *  FROM NW1_PRODUCTS FOR UPDATE OF UNITPRICE;	  
BEGIN
FOR vProd IN cProd LOOP
     UPDATE NW1_PRODUCTS SET UNITPRICE=1.1*UNITPRICE WHERE CURRENT OF cProd;
END LOOP; 
END;

CREATE PROCEDURE IncPrice1  IS
BEGIN
  UPDATE NW1_PRODUCTS SET UNITPRICE=1.1*UNITPRICE; 
END;