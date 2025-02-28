--1 Selezionare tutti i prodotti di categoria ‘Beverages’

SELECT P.PRODUCTNAME
FROM NW.CATEGORIES C, NW.PRODUCTS P
WHERE C.CATEGORYID=P.CATEGORYID 
AND C.CATEGORYNAME='Beverages';

SELECT P.PRODUCTNAME
FROM NW.CATEGORIES C INNER JOIN NW.PRODUCTS P ON C.CATEGORYID=P.CATEGORYID
WHERE C.CATEGORYNAME='Beverages';

--2 Contare i prodotti di categoria ‘Beverages’
SELECT count(*)
FROM NW.CATEGORIES C, NW.PRODUCTS P
WHERE C.CATEGORYID=P.CATEGORYID 
AND C.CATEGORYNAME='Beverages';

--3 Contare i prodotti di ogni categoria 
SELECT C.CATEGORYNAME, count(*)
FROM NW.CATEGORIES C, NW.PRODUCTS P
WHERE C.CATEGORYID=P.CATEGORYID 
group by C.CATEGORYNAME
order by 1;

--4 Selezionare tutti i prodotti presenti in almeno un ordine
SELECT PRODUCTNAME 
FROM NW.PRODUCTS 
where PRODUCTID in (SELECT PRODUCTID FROM NW.ORDERDETAILS);
  
SELECT DISTINCT PRODUCTNAME 
FROM NW.PRODUCTS P, NW.ORDERDETAILS O
where O.PRODUCTID = O.PRODUCTID;

--5 Selezionare tutti i prodotti che non sono presenti in nessun ordine spedito negli Stati Uniti

SELECT PRODUCTNAME 
FROM NW.PRODUCTS 
where PRODUCTID not in (SELECT PRODUCTID FROM NW.ORDERDETAILS OD join NW.ORDERS O on (OD.ORDERID=O.ORDERID) WHERE SHIPCOUNTRY='USA' );

--errata  
SELECT DISTINCT PRODUCTNAME 
FROM NW.PRODUCTS P, NW.ORDERDETAILS OD, NW.ORDERS O 
where OD.PRODUCTID = P.PRODUCTID and OD.ORDERID=O.ORDERID and
SHIPCOUNTRY<>'USA';  


--6 Selezionare gli impiegati che hanno gestito più di 50 ordini
SELECT A.LASTNAME, A.FIRSTNAME, count(*) as NumeroOrdini
FROM NW.ORDERS B, NW.EMPLOYEES A
WHERE A.EMPLOYEEID = B.EMPLOYEEID
group by A.EMPLOYEEID, A.LASTNAME, A.FIRSTNAME
having count(*)> 50
order by 3 desc;

--7 Selezionare gli impiegati che hanno gestito ordini da tutti i paesi

--non ci sono paesi in cui non sia stato spedito un ordine gestito da quell'impiegato
SELECT A.LASTNAME, A.FIRSTNAME 
FROM NW.EMPLOYEES A
WHERE NOT EXISTS 
  (SELECT * FROM NW.ORDERS O WHERE NOT EXISTS 
   (SELECT * FROM NW.ORDERS O1 WHERE A.EMPLOYEEID = O1.EMPLOYEEID AND 
O.SHIPCOUNTRY=O1.SHIPCOUNTRY));

--numero paesi serviti= numero paesi presenti nel db
SELECT A.LASTNAME, A.FIRSTNAME, count(distinct SHIPCOUNTRY) as PaesiDistinti
FROM NW.ORDERS B, NW.EMPLOYEES A
WHERE A.EMPLOYEEID = B.EMPLOYEEID
group by A.EMPLOYEEID, A.LASTNAME, A.FIRSTNAME
having count(distinct SHIPCOUNTRY)= (SELECT count(distinct SHIPCOUNTRY) FROM NW.ORDERS O);



-- 8 Selezionare le coppie di impiegati della stessa città (senza duplicati)

SELECT e1.EMPLOYEEID,e2.EMPLOYEEID,e1.CITY
FROM NW.EMPLOYEES e1,NW.EMPLOYEES e2 
where e1.EMPLOYEEID<e2.EMPLOYEEID and e1.CITY=e2.CITY;

--9 Selezionare gli impiegati che hanno un superiore che abita nella stessa città
  
SELECT e1.EMPLOYEEID as Impiegato ,e2.EMPLOYEEID as Superiore ,e1.CITY
FROM NW.EMPLOYEES e1,NW.EMPLOYEES e2 
where e1.REPORTSTO =e2.EMPLOYEEID and e1.CITY=e2.CITY;
  
--10 Selezionare gli impiegati e il relativo superiore, inclusi qli impiegati che non hanno superiore
SELECT e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME, e.REPORTSTO as Sup, s.LASTNAME as cognomeSup, s.FIRSTNAME as nomeSup
FROM NW.EMPLOYEES e left outer join NW.EMPLOYEES s on ( e.REPORTSTO=s.EMPLOYEEID); 


--11 Selezionare l’impiegato che ha gestito il maggior numero di ordini

SELECT e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME, count(ORDERID) as NumOrdini 
FROM NW.EMPLOYEES E join  NW.ORDERS o on (e.EMPLOYEEID=o.EMPLOYEEID)
group by e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME
having count(ORDERID)>=ALL (SELECT  count(ORDERID) as NumOrdini 
FROM  NW.ORDERS 
group by EMPLOYEEID);   



