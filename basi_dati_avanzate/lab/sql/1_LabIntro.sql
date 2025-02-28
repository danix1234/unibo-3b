--1. Selezionare gli impiegati che hanno gestito più di 50 ordini

SELECT A.LASTNAME, A.FIRSTNAME, count(*) as NumeroOrdini
FROM NW.ORDERS B, NW.EMPLOYEES A
WHERE A.EMPLOYEEID = B.EMPLOYEEID
group by A.EMPLOYEEID, A.LASTNAME, A.FIRSTNAME
having count(*)> 50
order by 3 desc;


-- 2 Selezionare gli ordini dal 1/1/1998 al 1/2/1998
SELECT ORDERID,ORDERDATE
FROM NW.ORDERS 
WHERE ORDERDATE
BETWEEN TO_DATE ('01/01/1998', 'dd/mm/yyyy')
AND TO_DATE ('1998/02/01', 'yyyy/mm/dd');


--3 Ordinare gli impiegati per anno di nascita (dal più giovane)
   
  SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, to_char(BIRTHDATE, 'YYYY') 
  FROM NW.EMPLOYEES 
  ORDER BY 4 DESC;
  
  SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, EXTRACT( YEAR FROM BIRTHDATE)
  FROM NW.EMPLOYEES 
  ORDER BY 4 DESC;
  
--4 Selezionare l’impiegato che ha gestito il maggior numero di ordini

--con table expression  
WITH imp1 AS (SELECT LASTNAME, FIRSTNAME, count(ORDERID) as NumOrdini 
FROM NW.EMPLOYEES E join  NW.ORDERS o on (e.EMPLOYEEID=o.EMPLOYEEID)
group by e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME
order by 3 desc)

SELECT LASTNAME, FIRSTNAME, NumOrdini 
FROM imp1
where NumOrdini>=ALL(SELECT NumOrdini FROM imp1);

--nella clausola from
SELECT LASTNAME, FIRSTNAME, NumOrdini 
FROM (SELECT LASTNAME, FIRSTNAME, count(ORDERID) as NumOrdini 
FROM NW.EMPLOYEES E join  NW.ORDERS o on (e.EMPLOYEEID=o.EMPLOYEEID)
group by e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME
order by 3 desc)
where NumOrdini>=ALL(SELECT NumOrdini FROM (SELECT LASTNAME, FIRSTNAME, count(ORDERID) as NumOrdini 
FROM NW.EMPLOYEES E join  NW.ORDERS o on (e.EMPLOYEEID=o.EMPLOYEEID)
group by e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME
order by 3 desc));

--con uso di rownum
SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, NumOrdini 
FROM (SELECT e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME, count(ORDERID) as NumOrdini 
FROM NW.EMPLOYEES E join  NW.ORDERS o on (e.EMPLOYEEID=o.EMPLOYEEID)
group by e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME
order by 4 desc) 
where rownum<=1;

WITH imp1 AS (SELECT e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME, count(ORDERID) as NumOrdini 
FROM NW.EMPLOYEES E join  NW.ORDERS o on (e.EMPLOYEEID=o.EMPLOYEEID)
group by e.EMPLOYEEID, e.LASTNAME, e.FIRSTNAME
order by 4 desc)
SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, NumOrdini 
FROM imp1
where rownum<=1;


--5 Selezionare i 10 ordini con valore più alto

select ORDERID,  Totale from 
(select ORDERID, sum (UNITPRICE*QUANTITY*(1-DISCOUNT)) as Totale
from NW.ORDERDETAILS 
group by ORDERID
order by 2 desc)
where rownum<=10;

--6 Raggruppare i prodotti in fasce in base alle quantità venduta: fascia alta (>1000), fascia bassa (<500), fascia media

with PView as (SELECT PRODUCTID, sum (o.quantity) as QtaVenduta 
FROM NW.ORDERDETAILS O
group by PRODUCTID)
select PRODUCTID, case  
                    when QtaVenduta>1000 then 'fascia alta'
                    when QtaVenduta<500 then 'fascia bassa'
                    else 'fascia media'
                    end  fascia, QtaVenduta 
                    from PView;

					


