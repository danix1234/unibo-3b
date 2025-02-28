--Test velocità cursori
DECLARE
  l_loops  NUMBER := 10000;
  l_dummy  dual.dummy%TYPE;
  l_start  NUMBER;
  CURSOR c_dual IS SELECT dummy FROM   dual;
BEGIN
  l_start := DBMS_UTILITY.get_time;
  FOR i IN 1 .. l_loops LOOP
    OPEN  c_dual;
    FETCH c_dual INTO  l_dummy;
    CLOSE c_dual;
  END LOOP;
  DBMS_OUTPUT.put_line('Explicit Fetch: ' ||   (DBMS_UTILITY.get_time - l_start) || ' hsecs');
                       
  l_start := DBMS_UTILITY.get_time;
  FOR i IN 1 .. l_loops LOOP
    FOR v_dummy IN c_dual LOOP
        null;
    end loop;    
  END LOOP;
  DBMS_OUTPUT.put_line('Explicit ForLoop: ' || (DBMS_UTILITY.get_time - l_start) || ' hsecs');

  l_start := DBMS_UTILITY.get_time;
  FOR i IN 1 .. l_loops LOOP
    SELECT dummy INTO l_dummy FROM dual;
  END LOOP;
  DBMS_OUTPUT.put_line('Implicit: ' ||  (DBMS_UTILITY.get_time - l_start) || ' hsecs');
END;



--Test velocità cursori 2 (https://oracle-base.com/articles/misc/implicit-vs-explicit-cursors-in-oracle-plsql)
--con più righe

SET SERVEROUTPUT ON
DECLARE
  l_obj    all_objects%ROWTYPE;
  l_start  NUMBER;

  CURSOR c_obj IS
    SELECT *
    FROM   all_objects;
BEGIN
  l_start := DBMS_UTILITY.get_time;

  OPEN  c_obj;
  LOOP
    FETCH c_obj 
    INTO  l_obj;

    EXIT WHEN c_obj%NOTFOUND;

    -- Do something.
    NULL;
  END LOOP;
  CLOSE c_obj;

  DBMS_OUTPUT.put_line('Explicit Fetch Loop: ' || 
                       (DBMS_UTILITY.get_time - l_start) || ' hsecs');

  l_start := DBMS_UTILITY.get_time;

  FOR cur_rec IN c_obj LOOP
    -- Do something.
    NULL;
  END LOOP;

  DBMS_OUTPUT.put_line('Explicit For Loop  : ' || 
                       (DBMS_UTILITY.get_time - l_start) || ' hsecs');

  l_start := DBMS_UTILITY.get_time;

  FOR cur_rec IN (SELECT * FROM all_objects) LOOP
    -- Do something.
    NULL;
  END LOOP;

  DBMS_OUTPUT.put_line('Implicit For Loop  : ' || 
                       (DBMS_UTILITY.get_time - l_start) || ' hsecs');
END;



-- Esercizio 1. Scuola di sci DiscesaLibera 
create table TIPICORSI (
T_IDCorso int,
T_Nome varchar2(100),
T_Livello int,
T_EtaMin int,
T_EtaMax int,
T_MinPartecipanti int,
primary key (T_IDCorso));

create table ALLIEVI( 
A_IDAllievo int,
A_Nome varchar2(100),
A_Eta int,
A_Livello int,
A_SettimanaRichiesta int,
primary key (A_IDAllievo)
);

create table ASSEGNAMENTI(
AS_Corso int, 
AS_Allievo int,
primary key (AS_Corso, AS_Allievo),
foreign key (AS_Corso) references TIPICORSI(T_IDCorso),
foreign key (AS_Allievo) references ALLIEVI(A_IDAllievo));


--Soluzione
create or replace procedure Assegna(vSettimana int) IS
--cursori
cursor cCorsi is
select * from TIPICORSI
order by T_Livello,T_EtaMin;
 
cursor cAllievi(iLivello int,iEtaMin int,iEtaMax int) is
select * from ALLIEVI
where A_SettimanaRichiesta=vSettimana and A_Eta>=iEtaMin and A_Eta<=iEtaMax 
and A_Livello=iLivello;
 
vNumAllievi int;
 
begin 
--primo cursore
FOR vCorsi IN cCorsi
 LOOP
   select count(*) into vNumAllievi from ALLIEVI
   where A_SettimanaRichiesta=vSettimana and A_Eta>=vCorsi.T_EtaMin and A_Eta<=vCorsi.T_EtaMax and A_Livello=vCorsi.T_Livello;
 
   if (vNumAllievi>vCorsi.T_MinPartecipanti) then 
     --secondo cursore 
     FOR vAllievi IN cAllievi(vCorsi.T_Livello, vCorsi.T_EtaMin,vCorsi.T_EtaMax)
	LOOP
       INSERT INTO ASSEGNAMENTI VALUES (vCorsi.T_IDCorso,vAllievi.A_IDAllievo);
	END LOOP;
   end if; 	
 END LOOP;
end;

-- Esercizio 2. Calcetto
create table GIOCATORI (
G_ID int,
G_Nome varchar2(20),
G_Cognome varchar2(20),
G_LivelloTecnico int,
G_LivelloAtletico int,
G_Ruolo varchar2(10),
primary key (G_ID));


create table PARTITE ( 
P_IDPartita int,
P_Data date,
primary key (P_IDPartita)
);

create table DISPONIBILITA ( 
D_IDPartita int,
D_IDGiocatore int,
primary key (D_IDPartita,D_IDGiocatore),
foreign key (D_IDPartita) references PARTITE(P_IDPArtita),
foreign key (D_IDGiocatore) references GIOCATORI(G_ID)
);

create table FORMAZIONI ( 
F_IDPartita int,
F_IDGiocatore int,
F_IDSquadra int, 
primary key (F_IDPartita,F_IDGiocatore),
foreign key (F_IDPartita) references PARTITE(P_IDPArtita),
foreign key (F_IDGiocatore) references GIOCATORI(G_ID)
);


--Soluzione 
create or replace procedure GeneraSquadra(IDPartita int) IS
cursor cDisp is --cursore
select G_ID, G_Ruolo, (G_LivelloTecnico * 1.2 + G_LivelloAtletico) AS Valore from DISPONIBILITA, GIOCATORI where D_IDPartita=IDPartita and D_IDGiocatore=G_ID order by 2, 3 DESC;
vSquadra int; vPrimaSquadra int; nGioc int; --variabili
vRuolo varchar2(10); notEnoughPlayers exception;
begin 
select count(*) into nGioc from DISPONIBILITA where D_IDPartita = IDPartita; 
if nGioc<10 then –check condizione
   raise notEnoughPlayers;
else 
   vPrimaSquadra:=1; --inizializza
   vSquadra:=vPrimaSquadra;
   vRuolo:='Attaccante';
   FOR vDisp IN cDisp  --cicla su cursore
    LOOP
      if (vDisp.G_Ruolo != vRuolo) then 
	vPrimaSquadra:=mod(vPrimaSquadra,2)+1; --cambio di ruolo
	vSquadra:=vPrimaSquadra;
         vRuolo:=vDisp.G_Ruolo; 
      end if;
      INSERT into FORMAZIONI values (IDPartita,vDisp.G_ID,vSquadra);
      vSquadra:=mod(vSquadra,2)+1; --squadra successiva
    END LOOP;
end if; 	
EXCEPTION 
WHEN notEnoughPlayers THEN
      DBMS_OUTPUT.PUT_LINE('Non ci sono abbastanza giocatori disponibili ');
end;

-- Esercizio 3. I compiti
create table DOMANDE (
D_ID int,
D_Testo varchar2(100),
D_RispostaCorretta int,
D_LivelloComplessità int,
D_AreaDomanda int,
primary key (D_ID));

create table RISPOSTE ( 
R_IDDomanda int,
R_IDRisposta int,
R_TestoRisposta varchar2(100),
primary key (R_IDDomanda,R_IDRisposta),
foreign key (R_IDDomanda) references DOMANDE(D_ID)
);

create table RISPOSTESTUDENTE(
RS_IDStudente int, 
RS_IDCompito int,
RS_IDDomanda int,
RS_Risposta int,
primary key (RS_IDStudente, RS_IDCompito, RS_IDDomanda),
foreign key (RS_IDDomanda) references DOMANDE(D_ID));

--Soluzione
create or replace 
procedure CorreggiCompito(IDStudente int, IDCompito int) IS
--cursore
cursor cDom is
select * from RISPOSTESTUDENTE, DOMANDE
where RS_IDDomanda=D_ID and RS_IDStudente=IDStudente AND RS_IDCompito=IDCompito
order by D_AreaDomanda;

vParzArea float;
vArea int;
vNum int;
vTot float;

begin 
vArea:=1;
vParzArea:=0;
vTot:=0;
vNum:=0;
FOR vDom IN cDom
 LOOP
   if ((vDom.D_AreaDomanda>vArea) and (vNum>0)) then 
    DBMS_OUTPUT.PUT_LINE('Area: ' || vArea ||  'Parziale:' || vParzArea/vNum);
    vTot := vTot + vArea*vParzArea/vNum;
    vParzArea:=0;	
  	vArea:=vDom.D_AreaDomanda;
    vNum:=0;
  end if; 	
  
  --aggiorna conteggi parziali
  vNum:=vNum+1;
  if (vDom.D_RispostaCorretta=vDom.RS_Risposta) then
    vParzArea:=vParzArea+vDom.D_LivelloComplessità;
  else
    vParzArea:=vParzArea-0.5;
  end if;
 END LOOP;
 --stampe finali
 	DBMS_OUTPUT.PUT_LINE('Area: ' || vArea || 'Parziale:' || vParzArea/vNum);
 vTot := vTot + vArea*vParzArea/vNum;
 
DBMS_OUTPUT.PUT_LINE('Totale: ' || vTot); 

end;

--4. Beach Volley
CREATE TABLE PLAYERS
   (P_PlayerName VARCHAR2(20 BYTE),
    P_FirstName VARCHAR2(20 BYTE), 
	P_LastName VARCHAR2(20 BYTE), 
	P_Gender VARCHAR2(1 BYTE), 
	P_BirthDate DATE, 
	P_Country VARCHAR2(3 BYTE), 
	PRIMARY KEY (P_PlayerName)
  );
  
  CREATE TABLE EVENTS
   (E_IDEvent NUMBER(5,0), 
    E_Season VARCHAR2(5 BYTE),
	E_Type VARCHAR2(5 BYTE), 
	E_Tournament VARCHAR2(20 BYTE), 
	E_Country VARCHAR2(3 BYTE), 
	E_Gender VARCHAR2(1 BYTE), 
	E_StartDate DATE,
    PRIMARY KEY (E_IDEvent)
  );

  CREATE TABLE ENTRYLIST
   (L_Event NUMBER(5,0),
    L_Player1 VARCHAR2(20 BYTE),
	L_Player2 VARCHAR2(20 BYTE),
    L_Country VARCHAR2(20 BYTE), 
	L_EntryPoints NUMBER(5,0), 
	PRIMARY KEY (L_Event, L_Player1),
	FOREIGN KEY (L_Player1)
	REFERENCES PLAYERS (P_PlayerName),
	FOREIGN KEY (L_Player2)
	REFERENCES PLAYERS (P_PlayerName),
	FOREIGN KEY (L_Event)
	REFERENCES EVENTS (E_IDEvent) 	
  );
  
  
  CREATE TABLE RESULTS
   (R_PlayerName VARCHAR2(20 BYTE),
    R_Event NUMBER(5,0),
    R_TeamMate VARCHAR2(20 BYTE), 
	R_Rank NUMBER(5,0), 
	R_Prize NUMBER(5,0), 
	R_Points NUMBER(5,0),
    PRIMARY KEY (R_PlayerName, R_Event),
	FOREIGN KEY (R_PlayerName)
	REFERENCES PLAYERS (P_PlayerName),
	FOREIGN KEY (R_TeamMate)
	REFERENCES PLAYERS (P_PlayerName),
	FOREIGN KEY (R_Event)
	REFERENCES EVENTS (E_IDEvent) 	
  );
 