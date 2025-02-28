--Esame 1
create table PAZIENTI (
P_CF varchar2(16),
P_NOME varchar2(20),
P_COGNOME varchar2(20),
P_SESSO int,
P_DATAN date,
primary key (P_CF));

create table PRESTAZIONI(
S_COD int,
S_NOME varchar2(50),
S_COSTO float,
primary key (S_COD));

create table RICOVERI (
R_PAZIENTE  varchar2(16),
R_DATAI date,
R_DATAF date,
primary key (R_PAZIENTE,R_DATAI),
foreign key (R_PAZIENTE) references PAZIENTI (P_CF));

create table EROGAZIONI (
E_PAZIENTE  varchar2(16),
E_DATARIC date,
E_PRESTAZIONE int,
primary key (E_PAZIENTE,E_DATARIC,E_PRESTAZIONE),
foreign key (E_PAZIENTE,E_DATARIC) references RICOVERI(R_PAZIENTE,R_DATAI),
foreign key (E_PRESTAZIONE) references PRESTAZIONI (S_COD));


--Esame2
create table CLIENTE (
C_ID int,
C_NOME varchar2(20),
C_COGNOME varchar2(20),
C_DATAN date,
C_TELEFONO varchar2(50),
C_TIPOCONTR varchar2(20),
primary key (C_ID));

create table OPERATORI (
O_ID int,
O_NOME varchar2(20),
O_COGNOME varchar2(20),
O_DATAN date,
O_LIVELLO int,
primary key (O_ID));

create table PROBLEMI (
P_COD varchar2(16),
P_DESCRIZIONE varchar2(50),
P_CLASSE varchar2(20),
P_DIFF float,
primary key (P_COD));

create table CHIAMATE(
C_ID int,
C_CLIENTE int,
C_OPERATORE int,
C_PROBLEMA varchar2(16),
C_APERTURA date,
C_RISULTATO int,
primary key (C_ID),
foreign key (C_CLIENTE) references CLIENTE(C_ID),
foreign key (C_OPERATORE) references OPERATORI(O_ID),
foreign key (C_PROBLEMA) references PROBLEMI(P_COD));

create table OPERAZIONI(
R_CHIAMATA int,
R_DATAORA date,
R_DURATA int,
R_DESCRIZIONE varchar2(50),
primary key (R_CHIAMATA,R_DATAORA),
foreign key (R_CHIAMATA) references CHIAMATE(C_ID));

--Esame3
create table REGIONI (
R_NOME varchar2(20),
R_NUMABITANTI int,
primary key (R_NOME));

create table DISTRETTI (
D_NOME varchar2(20),
D_DESCRIZIONE varchar2(50),
primary key (D_NOME));

create table CITTA (
C_NOME varchar2(20),
C_REGIONE varchar2(20),
C_NUMABITANTI int,
C_DISTRETTO varchar2(20),
primary key (C_NOME, C_REGIONE),
foreign key (C_REGIONE) references REGIONI(R_NOME),
foreign key (C_DISTRETTO) references DISTRETTI(D_NOME));

create table PARAMETRI (
P_CITTA varchar2(20),
P_REGIONE  varchar2(20),
P_PARAMETRO  varchar2(20),
P_TIPOPARAMETRO  varchar2(20),
P_DESCRIZIONE  varchar2(50), 
P_VALORE int,
primary key (P_CITTA, P_REGIONE, P_PARAMETRO),
foreign key (P_CITTA, P_REGIONE) references CITTA(C_NOME, C_REGIONE));

create table OUTPUT (
O_CITTA varchar2(20),
O_REGIONE  varchar2(20),
O_VALORE int,
primary key (O_CITTA, O_REGIONE),
foreign key (O_CITTA,O_REGIONE) references CITTA(C_NOME, C_REGIONE));

--Esame4
create table FUMETTI (
F_Nome varchar2(20),
F_Disegnatore varchar2(20),
F_Editore varchar2(20),
F_Prezzo number(8,2),
primary key (F_Nome));

create table NUMERI (
N_Fumetto varchar2(20),
N_Numero int,
N_Anno int,
N_NumPagine int,
primary key (N_Fumetto, N_Numero),
foreign key (N_Fumetto) References FUMETTI(F_Nome));

create table AVVENTURE (
A_Fumetto varchar2(20),
A_Numero int,
A_Titolo varchar2(20),
A_Descrizione varchar2(50),
A_NumPagine int,
primary key (A_Fumetto, A_Numero, A_Titolo),
foreign key (A_Fumetto, A_Numero) references NUMERI(N_Fumetto, N_Numero));

create table PERSONAGGI (
P_Nome varchar2(20),
P_Descrizione varchar2(50),
primary key (P_Nome));

create table COMPARE_IN (
C_Pers varchar2(20),
C_Fumetto varchar2(20),
C_Numero int,
C_Titolo varchar2(20),
C_NumVignette int,
primary key (C_Pers, C_Fumetto, C_Numero, C_Titolo),
foreign key (C_Fumetto, C_Numero, C_Titolo) references AVVENTURE(A_Fumetto, A_Numero, A_Titolo),
foreign key (C_Pers) references PERSONAGGI(P_Nome));

--Esame5
create table PROTEINE(
P_CodP int,
P_Nome varchar2(20),
P_Funzione varchar2(20),
P_Classe varchar2(20),
primary key (P_CodP));

create table AMINOACIDI(
AA_CodAm int,
AA_Nome varchar2(20),
AA_Funzione varchar2(20),
primary key(AA_CodAm)); 

create table ATOMI(
A_CodAt int, 
A_Nome varchar2(20), 
A_Potenziale int,
primary key (A_CodAt));


create table REGIONIP(
R_CodR int,
R_CodP int,
R_Posizione int,
R_Potenziale int,
primary key(R_CodR),
foreign key (R_CodP) references PROTEINE(P_CodP));

create table AT_IN_AM(
I_CodAm int,
I_CodAt int, 
I_Posizione int,
primary key(I_CodAm,I_CodAt),
foreign key(I_CodAm) references AMINOACIDI(AA_CodAm),
foreign key (I_CodAT) references ATOMI(A_CodAt));


create table AM_IN_R(
N_CodR int,
N_CodAm int,
Posizione int,
primary key (N_CodR, N_CodAm),
foreign key (N_CodR) references REGIONIP(R_CodR),
foreign key (N_CodAm) references AMINOACIDI(AA_CodAm));

--Esame6
create table LIBRI (
L_IDLibro varchar2(10),
L_Titolo varchar2(16),
L_Autore varchar2(20),
primary key (L_IDLibro));

create table SCAGLIONI(
S_IDLibro varchar2(10),
S_CumulativoDa int,
S_CumulativoA int,
S_Percentuale number(6,2),
primary key(S_IDLibro, S_CumulativoDa),
foreign key (S_IDLibro) references LIBRI(L_IDLibro));

create  table VENDITE(
V_IDLibro varchar2(10), 
V_Data date,
V_Nazione varchar2(20),
V_Quantita int,
V_Importo number(6,2),
primary key (V_IDLibro,V_Data, V_Nazione),
foreign key (V_IDLibro) references LIBRI(L_IDLibro));
