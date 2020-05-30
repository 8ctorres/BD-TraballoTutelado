-- Traballo Tutelado Bases de Datos
-- Carlos Torres
-- O seguinte script contén as instrucións SQL necesarias para crear todas as táboas da BD deseñada
-- así como introducir valores de proba en todas elas
-- Foi deseñado e probado sobre o SXBD Oracle dispoñible na FIC

-- Drop all tables

drop table hospital cascade constraints purge;
drop table equipo cascade constraints purge;
drop table material cascade constraints purge;
drop table ustock cascade constraints purge;
drop table stockmin cascade constraints purge;
drop table quenda cascade constraints purge;
drop table sanitario cascade constraints purge;
drop table pertence cascade constraints purge;
drop table paciente cascade constraints purge;
drop table ingreso cascade constraints purge;
drop table revision cascade constraints purge;
drop table exploracion cascade constraints purge;
drop table parametros cascade constraints purge;
drop table tratamento cascade constraints purge;
drop table prescricion cascade constraints purge;

commit;

-- Create tables

create table hospital (
    IDHosp number(4) constraint pk_hosp primary key,
    Nome varchar2(25) constraint nn_nomehosp not null,
    Loc varchar2(25) constraint nn_hosploc not null,
    CapTotal number(4),
    CapUCI number(4)
);

create table equipo (
    Hosp number(4),
    IDEquipo number (10),
    constraint pk_equipo primary key (Hosp, IDEquipo)
);

create table material (
    IDMat number(10) constraint pk_material primary key,
    Descricion varchar2(1000) constraint nn_descmaterial not null
);

create table ustock (
    NSerie number(20) constraint pk_ustock primary key,
    Estado varchar2(100),
    Material number(10) constraint nn_ustockmat not null,
    Hospital number(4),
    Zona varchar2(25),
    DataHora date
);

create table stockmin (
    Hospital number(4),
    Material number(10),
    Cantidade number(6) constraint nn_stockmin not null
);

create table quenda (
    DataHoraInicio date,
    Zona varchar2(25),
    Hosp number(4),
    Equipo number(10),
    DataHoraFin date,
    Incidencias clob,
    constraint pk_quenda primary key (DataHoraInicio,Zona, Hosp)
);

create table sanitario (
    NSS number(15) constraint pk_sanitario primary key,
    Nome varchar2(25) constraint nn_nomesanitario not null,
    Ap1 varchar2(25),
    Ap2 varchar2(25),
    Especialidade varchar2(100)
);

create table pertence (
    NSS number(15),
    DataInicio date,
    DataFin date,
    Hospital number(4),
    Equipo number(10),
    constraint pk_pertence primary key (NSS, DataInicio)
);

create table paciente (
    NHC number(15) constraint pk_paciente primary key,
    DNI number(8),
    Nome varchar2(25),
    Ap1 varchar2(25),
    Ap2 varchar2(25),
    DataNac date,
    DataRex date constraint nn_datarex not null,
    MetodoRex varchar2(25)
);

create table ingreso (
    NHC number(15),
    DataHoraIngreso date,
    DataHoraFin date,
    Lugar number(4),
    Motivo varchar2(240),
    Diag clob,
    constraint pk_ingreso primary key (NHC, DataHoraIngreso)
);

create table revision (
    IDRev number(20) constraint pk_revision primary key,
    DataHoraCita date,
    Entrevista clob,
    Lugar number(4),
    Paciente number(15) constraint nn_paciente_pasa_revision not null
);

create table exploracion (
    IDRev number(20),
    Tipo varchar2(50),
    FeitaPor number(15) constraint nn_revision_feitapor not null,
    constraint pk_exploracion primary key (IDRev, Tipo)
);

create table parametros (
    IDRev number(20),
    Tipo varchar2(50),
    Parametro varchar2(25),
    Resultado varchar2(25),
    constraint pk_param primary key (IDRev, Tipo, Parametro)
);

create table tratamento (
    IDTratamento number(20) constraint pk_tratamiento primary key,
    DataInicio date,
    DataFin date,
    Autoriza number(15) constraint nn_autorizatratamento not null,
    Paciente number(15) constraint nn_paciente_toma_tratamento not null
);

create table prescricion (
    IDTratamento number(20),
    Medicamento varchar2(25),
    Dose varchar2(25),
    Posoloxia varchar2(25),
    constraint pk_prescricion primary key (IDTratamento, Medicamento)
);

commit;

-- Add foreign keys

alter table equipo add constraint fk_equipohosp foreign key (Hosp) references hospital (IDHosp);

alter table ustock add constraint fk_ustockmat foreign key (Material) references material (IDMat);
alter table ustock add constraint fk_ustockquenda foreign key (Hospital, Zona, DataHora) references quenda (Hosp, Zona, DataHoraInicio);

alter table stockmin add constraint fk_stockmin_hosp foreign key (Hospital) references hospital (IDHosp);
alter table stockmin add constraint fk_stockmin_mat foreign key (Material) references material (IDMat);

alter table quenda add constraint fk_quendahosp foreign key (Hosp) references hospital (IDHosp);
alter table quenda add constraint fk_quendaequipo foreign key (Hosp, Equipo) references equipo (Hosp, IDEquipo);

alter table pertence add constraint fk_pertenceequipo foreign key (Hospital, Equipo) references equipo (Hosp, IDEquipo);
alter table pertence add constraint fk_pertencesanitario foreign key (NSS) references sanitario (NSS);

alter table ingreso add constraint fk_ingresopaciente foreign key (NHC) references paciente (NHC);
alter table ingreso add constraint fk_ingresohospital foreign key (Lugar) references hospital (IDHosp);

alter table revision add constraint fk_revisionhospital foreign key (Lugar) references hospital (IDHosp);
alter table revision add constraint fk_revisionpaciente foreign key (Paciente) references paciente (NHC);

alter table exploracion add constraint fk_exploracionsanitario foreign key (FeitaPor) references sanitario (NSS);
alter table exploracion add constraint fk_exploracionrevision foreign key (IDRev) references revision (IDRev);

alter table parametros add constraint fk_parametrosexploracion foreign key (IDRev, Tipo) references exploracion (IDRev, Tipo);

alter table tratamento add constraint fk_tratamentosanitario foreign key (Autoriza) references sanitario (NSS);
alter table tratamento add constraint fk_tratamentopaciente foreign key (Paciente) references paciente (NHC);

alter table prescricion add constraint fk_prescriciontratamento foreign key (IDTratamento) references tratamento (IDTratamento);

commit;

-- Insertar hospitales

insert into hospital values (1, 'CHUAC', 'Coruña', 1000, 50);
insert into hospital values (2, 'Teresa Herrera', 'Coruña', 500, 25);
insert into hospital values (3, 'CHUS', 'Santiago', 1500, 150);
insert into hospital values (4, 'Rosaleda', 'Santiago', 400, 25);
insert into hospital values (5, 'Barbanza', 'Ribeira', 100, 5);
insert into hospital values (6, 'Álvaro Cunqueiro', 'Vigo', 800, 80);
insert into hospital values (7, 'Meixoeiro', 'Vigo', 500, 50);

-- Insertar equipos

insert into equipo values (1,1);
insert into equipo values (1,2);
insert into equipo values (1,3);
insert into equipo values (2,1);
insert into equipo values (2,2);
insert into equipo values (2,3);
insert into equipo values (3,1);
insert into equipo values (3,2);
insert into equipo values (4,1);
insert into equipo values (4,2);
insert into equipo values (5,1);
insert into equipo values (6,1);
insert into equipo values (6,2);
insert into equipo values (7,1);

-- Insertar quendas

insert into quenda values (to_date('01/05/2020 07:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 1, 1 , to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 1, 3 , to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'Urxencias', 2, 2 , to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'Quirófano', 3, 1 , to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 4, 1 , to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 4, 2 , to_date('02/05/2020 07:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'Radioloxía', 5, 1 , to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'Quirófano', 7, 1 , to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('02/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 2, 1 , to_date('02/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('02/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), 'Maternidade', 1, 2 , to_date('03/05/2020 07:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('02/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'Quirófano', 1, 3 , to_date('02/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), 'Unha das camillas ten unha pata rota');
insert into quenda values (to_date('03/05/2020 07:00', 'DD/MM/YYYY HH24:MI'), 'Quirófano', 1, 3 , to_date('03/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), 'Traumatoloxía', 4, 1, to_date('02/05/2020 07:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('03/05/2020 07:00', 'DD/MM/YYYY HH24:MI'), 'Radioloxía', 5, 1 , to_date('03/05/2020 15:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), 'Urxencias', 2, 3 , to_date('02/05/2020 07:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 1, 1 , to_date('02/05/2020 07:00', 'DD/MM/YYYY HH24:MI'), 'Un dos respiradores estropeouse');
insert into quenda values (to_date('01/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 2, 3 , to_date('01/04/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 3, 1 , to_date('01/04/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 4, 2 , to_date('01/04/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('03/04/2020 07:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 5, 1, to_date('03/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('03/04/2020 07:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 6, 2, to_date('03/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('03/04/2020 07:00', 'DD/MM/YYYY HH24:MI'), 'UCI', 7, 1, to_date('03/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('10/04/2020 23:00', 'DD/MM/YYYY HH24:MI'), 'Urxencias', 1, 2 , to_date('11/04/2020 07:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('15/04/2020 07:00', 'DD/MM/YYYY HH24:MI'), 'Urxencias', 4, 1 , to_date('15/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'Quedamos sen auga na fonte da entrada');
insert into quenda values (to_date('20/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'Urxencias', 5, 1 , to_date('20/04/2020 23:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('25/04/2020 07:00', 'DD/MM/YYYY HH24:MI'), 'Quirófano', 2, 1 , to_date('25/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), null);
insert into quenda values (to_date('01/03/2020 23:00', 'DD/MM/YYYY HH24:MI'), 'Quirófano', 3, 2 , to_date('02/03/2020 07:00', 'DD/MM/YYYY HH24:MI'), null);

-- Insertar materiales

insert into material values (1, 'Guantes de vinilo');
insert into material values (2, 'Guantes de nitrilo');
insert into material values (3, 'Mascarilla quirúrxica');
insert into material values (4, 'Mascarilla FFP2');
insert into material values (5, 'Mascarilla FFP3');
insert into material values (6, 'Bata de protección');
insert into material values (7, 'Gafas de protección');
insert into material values (8, 'Pantalla de protección');

-- Insertar unidades de stock

insert into ustock values (001, 'Novo', 1, null, null, null);
insert into ustock values (002, 'Novo', 2, null, null, null);
insert into ustock values (003, 'Novo', 5, null, null, null);
insert into ustock values (004, 'Novo', 1, 1, null, null);
insert into ustock values (005, 'Novo', 1, 1, null, null);
insert into ustock values (006, 'Novo', 1, 1, null, null);
insert into ustock values (007, 'Novo', 1, 2, null, null);
insert into ustock values (008, 'Novo', 1, 2, null, null);
insert into ustock values (009, 'Novo', 1, 2, null, null);
insert into ustock values (010, 'Novo', 1, 2, null, null);
insert into ustock values (011, 'Novo', 1, 3, null, null);
insert into ustock values (012, 'Novo', 1, 3, null, null);
insert into ustock values (013, 'Novo', 1, 3, null, null);
insert into ustock values (014, 'Novo', 1, 4, null, null);
insert into ustock values (015, 'Novo', 1, 4, null, null);
insert into ustock values (016, 'Novo', 1, 4, null, null);
insert into ustock values (017, 'Novo', 1, 5, null, null);
insert into ustock values (018, 'Novo', 1, 5, null, null);
insert into ustock values (019, 'Novo', 1, 5, null, null);
insert into ustock values (020, 'Novo', 1, 6, null, null);
insert into ustock values (021, 'Novo', 1, 6, null, null);
insert into ustock values (022, 'Novo', 1, 6, null, null);
insert into ustock values (023, 'Novo', 1, 7, null, null);
insert into ustock values (024, 'Novo', 1, 7, null, null);
insert into ustock values (025, 'Novo', 2, 7, null, null);
insert into ustock values (026, 'Novo', 2, 1, null, null);
insert into ustock values (027, 'Novo', 2, 1, null, null);
insert into ustock values (028, 'Novo', 2, 1, null, null);
insert into ustock values (029, 'Novo', 2, 2, null, null);
insert into ustock values (030, 'Novo', 2, 2, null, null);
insert into ustock values (031, 'Novo', 2, 2, null, null);
insert into ustock values (032, 'Novo', 2, 3, null, null);
insert into ustock values (033, 'Novo', 2, 3, null, null);
insert into ustock values (034, 'Novo', 2, 4, null, null);
insert into ustock values (035, 'Novo', 3, 4, null, null);
insert into ustock values (036, 'Novo', 3, 4, null, null);
insert into ustock values (037, 'Novo', 3, 5, null, null);
insert into ustock values (038, 'Novo', 3, 5, null, null);
insert into ustock values (039, 'Novo', 3, 5, null, null);
insert into ustock values (040, 'Novo', 3, 6, null, null);
insert into ustock values (041, 'Novo', 3, 6, null, null);
insert into ustock values (042, 'Novo', 3, 6, null, null);
insert into ustock values (043, 'Novo', 3, 7, null, null);
insert into ustock values (044, 'Novo', 3, 7, null, null);
insert into ustock values (045, 'Novo', 3, 7, null, null);
insert into ustock values (046, 'Novo', 3, 1, null, null);
insert into ustock values (047, 'Novo', 4, 1, null, null);
insert into ustock values (048, 'Novo', 4, 1, null, null);
insert into ustock values (049, 'Novo', 4, 1, null, null);
insert into ustock values (050, 'Novo', 4, 2, null, null);
insert into ustock values (051, 'Novo', 4, 2, null, null);
insert into ustock values (052, 'Novo', 4, 2, null, null);
insert into ustock values (053, 'Novo', 4, 3, null, null);
insert into ustock values (054, 'Novo', 4, 3, null, null);
insert into ustock values (055, 'Novo', 4, 3, null, null);
insert into ustock values (056, 'Novo', 4, 4, null, null);
insert into ustock values (057, 'Novo', 4, 4, null, null);
insert into ustock values (058, 'Novo', 4, 4, null, null);
insert into ustock values (059, 'Novo', 5, 5, null, null);
insert into ustock values (060, 'Novo', 5, 5, null, null);
insert into ustock values (061, 'Novo', 5, 5, null, null);
insert into ustock values (062, 'Novo', 5, 6, null, null);
insert into ustock values (063, 'Novo', 5, 6, null, null);
insert into ustock values (064, 'Novo', 5, 6, null, null);
insert into ustock values (065, 'Novo', 5, 7, null, null);
insert into ustock values (066, 'Novo', 5, 7, null, null);
insert into ustock values (067, 'Novo', 5, 7, null, null);
insert into ustock values (068, 'Novo', 5, 1, null, null);
insert into ustock values (069, 'Novo', 5, 1, null, null);
insert into ustock values (070, 'Novo', 6, 1, null, null);
insert into ustock values (071, 'Novo', 6, 2, null, null);
insert into ustock values (072, 'Novo', 6, 2, null, null);
insert into ustock values (073, 'Novo', 6, 2, null, null);
insert into ustock values (074, 'Novo', 6, 3, null, null);
insert into ustock values (075, 'Novo', 6, 3, null, null);
insert into ustock values (076, 'Novo', 6, 3, null, null);
insert into ustock values (077, 'Novo', 6, 3, null, null);
insert into ustock values (078, 'Novo', 6, 4, null, null);
insert into ustock values (079, 'Novo', 6, 4, null, null);
insert into ustock values (080, 'Novo', 7, 4, null, null);
insert into ustock values (081, 'Novo', 7, 4, null, null);
insert into ustock values (082, 'Novo', 7, 1, null, null);
insert into ustock values (083, 'Novo', 7, 5, null, null);
insert into ustock values (084, 'Novo', 7, 5, null, null);
insert into ustock values (085, 'Novo', 7, 5, null, null);
insert into ustock values (086, 'Novo', 7, 5, null, null);
insert into ustock values (087, 'Novo', 7, 6, null, null);
insert into ustock values (088, 'Novo', 7, 6, null, null);
insert into ustock values (089, 'Novo', 7, 6, null, null);
insert into ustock values (090, 'Novo', 8, 6, null, null);
insert into ustock values (091, 'Novo', 8, 7, null, null);
insert into ustock values (092, 'Novo', 8, 7, null, null);
insert into ustock values (093, 'Novo', 8, 7, null, null);
insert into ustock values (094, 'Novo', 8, 7, null, null);
insert into ustock values (095, 'Novo', 8, 1, null, null);
insert into ustock values (096, 'Novo', 8, 2, null, null);
insert into ustock values (097, 'Novo', 8, 3, null, null);
insert into ustock values (098, 'Novo', 8, 4, null, null);
insert into ustock values (099, 'Novo', 8, 5, null, null);

-- Unidades de stock xa asignadas a quendas

insert into ustock values (111, 'Novo' , 1, 1, 'UCI',           to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (112, 'Novo' , 2, 1, 'UCI',           to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (113, 'Novo' , 3, 1, 'UCI',           to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (114, 'Novo' , 3, 1, 'UCI',           to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (115, 'Novo' , 5, 1, 'UCI',           to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (222, 'Novo' , 1, 2, 'UCI',           to_date('02/05/2020 15:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (333, 'Novo' , 1, 1, 'Maternidade',   to_date('02/05/2020 23:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (444, 'Novo' , 3, 1, 'Maternidade', null);
insert into ustock values (555, 'Novo' , 3, 1, 'Quirófano',     to_date('02/05/2020 15:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (666, 'Novo' , 3, 1, 'Quirófano',     to_date('03/05/2020 07:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (777, 'Novo' , 4, 4, 'Traumatoloxía', null);
insert into ustock values (888, 'Novo' , 4, 4, 'Traumatoloxía', to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (999, 'Novo' , 4, 4, null, null);
insert into ustock values (100, 'Novo' , 5, 5, 'Radioloxía',    to_date('03/05/2020 07:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (200, 'Novo' , 6, 2, 'Urxencias',     to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (300, 'Novo' , 6, 2, null, null);
insert into ustock values (400, 'Novo' , 7, 3, null, null);
insert into ustock values (500, 'Novo' , 8, 4, 'UCI',           to_date('01/05/2020 23:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (600, 'Usado', 1, 2, 'UCI',           to_date('01/04/2020 15:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (700, 'Usado', 2, 6, 'UCI',           to_date('03/04/2020 07:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (800, 'Usado', 3, 1, 'Urxencias',     to_date('10/04/2020 23:00', 'DD/MM/YYYY HH24:MI'));
insert into ustock values (900, 'Usado', 4, 4, 'Urxencias',     to_date('15/04/2020 07:00' , 'DD/MM/YYYY HH24:MI'));
insert into ustock values (110, 'Usado', 5, 5, 'Urxencias',     to_date('20/04/2020 15:00' , 'DD/MM/YYYY HH24:MI'));
insert into ustock values (220, 'Usado', 6, 2, 'Quirófano',     to_date('25/04/2020 07:00' , 'DD/MM/YYYY HH24:MI'));
insert into ustock values (330, 'Usado', 7, 3, 'Quirófano',     to_date('01/03/2020 23:00' , 'DD/MM/YYYY HH24:MI'));

-- Insertar Stocks Mínimos

insert into stockmin values (1, 1, 10);
insert into stockmin values (2, 1, 15);
insert into stockmin values (3, 1, 5);
insert into stockmin values (4, 1, 6);
insert into stockmin values (5, 1, 8);
insert into stockmin values (6, 1, 12);
insert into stockmin values (7, 1, 15);
insert into stockmin values (7, 2, 5);
insert into stockmin values (1, 2, 2);
insert into stockmin values (2, 2, 3);
insert into stockmin values (3, 2, 6);
insert into stockmin values (4, 2, 10);
insert into stockmin values (4, 3, 8);
insert into stockmin values (5, 3, 12);
insert into stockmin values (6, 3, 14);
insert into stockmin values (7, 3, 2);
insert into stockmin values (1, 3, 2);
insert into stockmin values (1, 4, 5);
insert into stockmin values (2, 4, 3);
insert into stockmin values (3, 4, 4);
insert into stockmin values (4, 4, 7);
insert into stockmin values (5, 5, 8);
insert into stockmin values (6, 5, 6);
insert into stockmin values (7, 5, 2);
insert into stockmin values (1, 5, 3);
insert into stockmin values (1, 6, 6);
insert into stockmin values (2, 6, 10);
insert into stockmin values (3, 6, 12);
insert into stockmin values (4, 6, 13);
insert into stockmin values (4, 7, 11);
insert into stockmin values (1, 7, 6);
insert into stockmin values (5, 7, 3);
insert into stockmin values (6, 2, 3);
insert into stockmin values (6, 7, 4);
insert into stockmin values (6, 8, 7);
insert into stockmin values (7, 8, 2);
insert into stockmin values (1, 8, 1);
insert into stockmin values (2, 8, 8);
insert into stockmin values (3, 8, 6);
insert into stockmin values (4, 8, 4);
insert into stockmin values (5, 8, 8);

-- Insertar personal sanitario

insert into sanitario values (1, 'Benito', 'Perez', 'Galdós', 'Neuroloxía');
insert into sanitario values (2, 'Alfonso', 'Rodríguez', 'Castelao', 'Uroloxía');
insert into sanitario values (3, 'Eduardo', 'Blanco', 'Amor', 'Cardioloxía');
insert into sanitario values (4, 'Almudena', 'Grandes', 'Hernández', 'Xinecoloxía');
insert into sanitario values (5, 'Carlos', 'Ruíz', 'Zafón', 'Psiquiatría');
insert into sanitario values (6, 'Rosa', 'Montero', 'Gayo', 'Enfermaría');
insert into sanitario values (7, 'Xosé Luís', 'Méndez', 'Ferrín', 'Enfermaría');

-- Insertar pertencia a equipos

insert into pertence values (1, to_date('01/01/2011', 'DD/MM/YYYY'), to_date('31/12/2011', 'DD/MM/YYYY'), 1, 1);
insert into pertence values (1, to_date('01/01/2012', 'DD/MM/YYYY'), to_date('31/12/2012', 'DD/MM/YYYY'), 1, 2);
insert into pertence values (1, to_date('01/01/2013', 'DD/MM/YYYY'), to_date('31/12/2013', 'DD/MM/YYYY'), 7, 1);
insert into pertence values (1, to_date('01/01/2014', 'DD/MM/YYYY'), null, 2, 1);
insert into pertence values (2, to_date('01/01/2017', 'DD/MM/YYYY'), to_date('31/12/2017', 'DD/MM/YYYY'), 3, 1);
insert into pertence values (2, to_date('01/01/2018', 'DD/MM/YYYY'), to_date('31/12/2018', 'DD/MM/YYYY'), 4, 2);
insert into pertence values (2, to_date('01/01/2019', 'DD/MM/YYYY'), to_date('31/12/2019', 'DD/MM/YYYY'), 7, 1);
insert into pertence values (2, to_date('01/01/2020', 'DD/MM/YYYY'), null, 3, 1);
insert into pertence values (3, to_date('01/01/2014', 'DD/MM/YYYY'), to_date('31/12/2015', 'DD/MM/YYYY'), 5, 1);
insert into pertence values (3, to_date('01/01/2016', 'DD/MM/YYYY'), to_date('31/12/2017', 'DD/MM/YYYY'), 6, 1);
insert into pertence values (3, to_date('01/01/2018', 'DD/MM/YYYY'), to_date('31/12/2018', 'DD/MM/YYYY'), 2, 2);
insert into pertence values (3, to_date('01/01/2019', 'DD/MM/YYYY'), to_date('31/12/2019', 'DD/MM/YYYY'), 5, 1);
insert into pertence values (3, to_date('01/01/2020', 'DD/MM/YYYY'), to_date('01/04/2020', 'DD/MM/YYYY'), 1, 3);
insert into pertence values (3, to_date('01/04/2020', 'DD/MM/YYYY'), null, 7, 1);
insert into pertence values (4, to_date('01/01/2017', 'DD/MM/YYYY'), null, 7, 1);
insert into pertence values (5, to_date('01/01/2015', 'DD/MM/YYYY'), to_date('31/12/2017', 'DD/MM/YYYY'), 3, 2);
insert into pertence values (5, to_date('01/01/2018', 'DD/MM/YYYY'), to_date('31/12/2019', 'DD/MM/YYYY'), 1, 3);
insert into pertence values (5, to_date('01/01/2019', 'DD/MM/YYYY'), null, 1, 3);
insert into pertence values (6, to_date('01/01/2017', 'DD/MM/YYYY'), to_date('31/01/2018', 'DD/MM/YYYY'), 1, 1);
insert into pertence values (6, to_date('01/02/2018', 'DD/MM/YYYY'), null, 3, 2);

-- Insertar pacientes

insert into paciente values (111, 1, 'Karl', 'Heinrich', 'Marx', to_date('05/05/1988', 'DD/MM/YYYY'), to_date('05/04/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (222, 2, 'Emmanuel', 'Kant', null, to_date('22/04/1984', 'DD/MM/YYYY'), to_date('20/04/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (333, 3, 'John', 'Locke', 'González', to_date('29/08/1932', 'DD/MM/YYYY'), to_date('03/04/2020', 'DD/MM/YYYY'),'Chamada telefónica');
insert into paciente values (444, 4, 'David', 'Hume', 'Fernández', to_date('07/05/2011', 'DD/MM/YYYY'), to_date('04/01/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (555, 5, 'Rene', 'Descartes', null, to_date('31/03/1996', 'DD/MM/YYYY'), to_date('28/04/2020', 'DD/MM/YYYY'),'Chamada telefónica');
insert into paciente values (666, null, 'Aristóteles', 'Sánchez', 'Bermúdez', null, to_date('15/04/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (777, 7, 'Pablo', 'Iglesias', 'Posse', to_date('17/10/1850', 'DD/MM/YYYY'), to_date('28/03/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (888, 8, 'Adam', 'Smith', null, to_date('5/6/1923', 'DD/MM/YYYY'), to_date('15/01/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (999, 9, 'Friedrich', 'Engels', 'Pérez', to_date('28/11/1940', 'DD/MM/YYYY'), to_date('01/02/2020', 'DD/MM/YYYY'),'Chamada telefónica');
insert into paciente values (100, 10, 'Friedrich', 'Wilhelm', 'Nietzsche', to_date('15/10/1984', 'DD/MM/YYYY'), to_date('14/02/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (200, 20, 'Leonardo', 'da Vinci', null, to_date('15/04/2000', 'DD/MM/YYYY'), to_date('28/04/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (300, 30, 'Luis Carlos', 'Rodríguez', 'Rio', to_date('13/10/1970', 'DD/MM/YYYY'), to_date('20/01/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (400, 40, 'Tomás', 'de Aquino', null, to_date('05/02/1954', 'DD/MM/YYYY'), to_date('24/04/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');
insert into paciente values (500, 50, 'Guillermo', 'de Ockham', 'Fernández', to_date('09/06/1943', 'DD/MM/YYYY'), to_date('05/02/2020', 'DD/MM/YYYY'),'Chamada telefónica');
insert into paciente values (123, null, null, null, null, null, to_date('11/04/2020', 'DD/MM/YYYY'),'Ingreso hospitalario');

-- Insertar ingresos

insert into ingreso values (111 , to_date('05/04/2020 16:30', 'DD/MM/YYYY HH24:MI'), to_date('07/04/2020 07:00', 'DD/MM/YYYY HH24:MI'), 1   , 'Dor de cabeza', 'Posibles migrañas');
insert into ingreso values (111 , to_date('07/04/2020 07:00', 'DD/MM/YYYY HH24:MI'), to_date('11/04/2020 12:30', 'DD/MM/YYYY HH24:MI'), null, 'Melloría, hosp. a domicilio', null);
insert into ingreso values (111 , to_date('11/04/2020 12:30', 'DD/MM/YYYY HH24:MI'), to_date('11/04/2020 14:00', 'DD/MM/YYYY HH24:MI'), 3   , 'Recaída, dor de cabeza intenso', 'Posible tumor cerebral');
insert into ingreso values (111 , to_date('11/04/2020 14:00', 'DD/MM/YYYY HH24:MI'), null                       , 5   , 'Principio de infarto cerebral', 'Vai para UCI');

insert into ingreso values (222 , to_date('20/04/2020 06:30', 'DD/MM/YYYY HH24:MI'), to_date('25/04/2020 10:00', 'DD/MM/YYYY HH24:MI'), 3   , 'Accidente de tráfico', 'Fractura nas dúas pernas');
insert into ingreso values (222 , to_date('25/04/2020 10:00', 'DD/MM/YYYY HH24:MI'), to_date('29/04/2020 18:30', 'DD/MM/YYYY HH24:MI'), 2   , 'Cambio de centro', 'Infección na perna dereita, peligro de gangrena');
insert into ingreso values (222 , to_date('29/04/2020 18:30', 'DD/MM/YYYY HH24:MI'), null                                  , 3   , 'Melloría, volve a planta', null);

insert into ingreso values (333 , to_date('15/04/2020', 'DD/MM/YYYY HH24:MI'), null                                  , 5   , 'Dificultade respiratoria', 'Posible caso de COVID. Aislamento');

insert into ingreso values (444 , to_date('4/01/2020 16:30', 'DD/MM/YYYY HH24:MI'), to_date('06/01/2020 21:00', 'DD/MM/YYYY HH24:MI'), 7   , 'Dor abdominal', 'Apendicitis. Operación de urxencia');

insert into ingreso values (555 , to_date('28/03/2020 08:35', 'DD/MM/YYYY HH24:MI'), to_date('03/04/2020 08:35', 'DD/MM/YYYY HH24:MI') , null   , 'Dificultade respiratoria', 'Pendente de diagnóstico');
insert into ingreso values (555 , to_date('03/04/2020 08:35', 'DD/MM/YYYY HH24:MI'), to_date('15/04/2020 16:30', 'DD/MM/YYYY HH24:MI') , 3   , 'Dificultade respiratoria', 'Ingresado por coronavirus');
insert into ingreso values (555 , to_date('15/04/2020 16:30', 'DD/MM/YYYY HH24:MI'), null , null, 'Melloría na enfermedade', 'Confinamento domiciliario');

insert into ingreso values (666 , to_date('15/04/2020 12:15', 'DD/MM/YYYY HH24:MI'), to_date('15/04/2020 22:30', 'DD/MM/YYYY HH24:MI'), 1   , 'Dificultade respiratoria', 'Posible caso de COVID. Aislamento');
insert into ingreso values (666 , to_date('15/04/2020 22:30', 'DD/MM/YYYY HH24:MI'), to_date('29/04/2020 11:00', 'DD/MM/YYYY HH24:MI'), 2   , 'Cambio de centro', 'Descartado COVID, confírmase caso de neumonía');

insert into ingreso values (777 , to_date('28/03/2020 03:35', 'DD/MM/YYYY HH24:MI'), to_date('04/04/2020 11:00', 'DD/MM/YYYY HH24:MI'), 1   , 'Accidente de tráfico. Dor na espalda', 'Posible latigazo cervical');
insert into ingreso values (777 , to_date('04/04/2020 11:00', 'DD/MM/YYYY HH24:MI'), to_date('19/04/2020 11:00', 'DD/MM/YYYY HH24:MI'), 1 , 'Melloría do paciente', 'Observación durante 15 días');
insert into ingreso values (777 , to_date('09/04/2020 15:30', 'DD/MM/YYYY HH24:MI'), to_date('10/04/2020 18:30', 'DD/MM/YYYY HH24:MI'), 1   , 'Corte no antebrazo esquerdo', 'Corte profundo no antebrazo esquerdo por accidente doméstico. Non afecta á musculatura');

insert into ingreso values (888 , to_date('15/01/2020 13:15', 'DD/MM/YYYY HH24:MI'), to_date('20/02/2020 11:00', 'DD/MM/YYYY HH24:MI'), 3   , 'Malestar xeral, dor abdominal', 'Diagnosticado cancro de páncreas');
insert into ingreso values (888 , to_date('20/02/2020 11:00', 'DD/MM/YYYY HH24:MI'), null                                        , null, 'Hospitalización a domicilio', 'Paciente con coidados paliativos');

insert into ingreso values (100 , to_date('14/02/2020 20:00', 'DD/MM/YYYY HH24:MI'), to_date('15/02/2020 12:00', 'DD/MM/YYYY HH24:MI'), 4   , 'Dor no tobillo dereito', 'Esguince segundo grao. Vendaxe e repouso');

insert into ingreso values (200 , to_date('28/04/2020 12:00', 'DD/MM/YYYY HH24:MI'), to_date('28/04/2020 19:15', 'DD/MM/YYYY HH24:MI'), 5   , 'Reacción alérxica', 'Paciente en shock anafiláctico, ingreso de urxencia');
insert into ingreso values (200 , to_date('28/04/2020 19:15', 'DD/MM/YYYY HH24:MI'), null                                  , 4   , 'Shock controlado', 'O paciente permanece en observación');

insert into ingreso values (300 , to_date('20/01/2020 18:00', 'DD/MM/YYYY HH24:MI'), to_date('22/01/2020 12:25', 'DD/MM/YYYY HH24:MI'), 3   , 'Queimadura na man dereita', 'Queimadura de segundo grao na man dereita por accidente doméstico');
insert into ingreso values (300 , to_date('15/04/2020 16:00', 'DD/MM/YYYY HH24:MI'), to_date('17/04/2020 12:45', 'DD/MM/YYYY HH24:MI'), 7   , 'Queimadura no brazo esquerdo', 'Queimadura de primeiro grao no brazo esquerdo por accidente doméstico');

insert into ingreso values (400 , to_date('24/04/2020 10:25', 'DD/MM/YYYY HH24:MI'), to_date('24/04/2020 19:30', 'DD/MM/YYYY HH24:MI'), 1   , 'Ataque de ansiedade', 'Paciente con mareos e dificultades respiratorias con cuadro de ansiedade');
insert into ingreso values (400 , to_date('24/04/2020 19:30', 'DD/MM/YYYY HH24:MI'), null                                  , null, 'Vai para casa baixo observación', 'Continúa o tratamento en pastillas. Cita en 15 días para comprobar progresos.');

insert into ingreso values (123 , to_date('11/04/2020 07:15', 'DD/MM/YYYY HH24:MI'), to_date('13/04/2020 08:30', 'DD/MM/YYYY HH24:MI'), 1   , 'Accidente de tráfico', 'Paciente non identificado, ingresa en coma moi grave tras accidente de tráfico');
insert into ingreso values (123 , to_date('13/04/2020 08:30', 'DD/MM/YYYY HH24:MI'), to_date('15/04/2020 18:30', 'DD/MM/YYYY HH24:MI'), 2   , 'Traslado do paciente', 'Traslado para operación de reconstrucción de cadera');
insert into ingreso values (123 , to_date('15/04/2020 18:30', 'DD/MM/YYYY HH24:MI'), to_date('29/04/2020 12:30', 'DD/MM/YYYY HH24:MI'), 1   , 'Tralado', 'O paciente recupera a consciencia, mantense en observación');

-- Insertar revisións

insert into revision values (01, to_date('01/04/2020 10:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 1, 111);
insert into revision values (02, to_date('05/04/2020 11:15', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 2, 111);
insert into revision values (03, to_date('11/04/2020 15:45', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 4, 111);
insert into revision values (04, to_date('13/04/2020 09:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 5, 222);
insert into revision values (05, to_date('15/04/2020 18:10', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 6, 222);
insert into revision values (06, to_date('16/04/2020 16:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 7, 222);
insert into revision values (37, to_date('13/05/2020 09:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 5, 222);
insert into revision values (38, to_date('15/05/2020 18:10', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 6, 222);
insert into revision values (39, to_date('16/05/2020 16:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 7, 222);
insert into revision values (07, to_date('18/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 1, 333);
insert into revision values (08, to_date('19/04/2020 16:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 2, 333);
insert into revision values (09, to_date('21/04/2020 12:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 3, 333);
insert into revision values (10, to_date('23/04/2020 10:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 5, 444);
insert into revision values (11, to_date('25/04/2020 12:15', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 6, 444);
insert into revision values (12, to_date('26/04/2020 13:00', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 7, 444);
insert into revision values (13, to_date('27/04/2020 16:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', null, 555);
insert into revision values (14, to_date('28/04/2020 17:15', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', null, 555);
insert into revision values (15, to_date('29/04/2020 16:00', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 4, 555);
insert into revision values (16, to_date('30/04/2020 11:00', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 5, 666);
insert into revision values (17, to_date('01/05/2020 17:15', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 6, 666);
insert into revision values (18, to_date('02/05/2020 12:15', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 7, 777);
insert into revision values (19, to_date('03/05/2020 14:15', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 1, 777);
insert into revision values (20, to_date('04/05/2020 16:10', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 2, 999);
insert into revision values (21, to_date('05/05/2020 09:25', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 4, 999);
insert into revision values (22, to_date('11/05/2020 11:45', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 5, 100);
insert into revision values (23, to_date('13/05/2020 13:40', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 6, 100);
insert into revision values (24, to_date('15/05/2020 11:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 7, 200);
insert into revision values (25, to_date('18/05/2020 12:25', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 1, 300);
insert into revision values (26, to_date('21/04/2020 17:05', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 5, 500);
insert into revision values (27, to_date('21/04/2020 15:00', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 6, 500);
insert into revision values (28, to_date('25/04/2020 16:15', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 7, 500);
insert into revision values (29, to_date('25/04/2020 14:25', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 1, 500);
insert into revision values (30, to_date('25/04/2020 15:30', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', 1, 500);
insert into revision values (31, to_date('18/03/2020 15:35', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', null, 400);
insert into revision values (32, to_date('19/03/2020 16:50', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', null, 400);
insert into revision values (33, to_date('18/04/2020 15:35', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', null, 400);
insert into revision values (34, to_date('19/04/2020 16:50', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', null, 400);
insert into revision values (35, to_date('18/05/2020 15:35', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', null, 400);
insert into revision values (36, to_date('19/05/2020 16:50', 'DD/MM/YYYY HH24:MI'), 'Lorem ipsum', null, 400);

-- Insertar exploracións

insert into exploracion values (01, 'Análise de sangue', 1);
insert into exploracion values (02, 'Análise de sangue', 1);
insert into exploracion values (03, 'Análise de sangue', 1);
insert into exploracion values (04, 'Análise de sangue', 2);
insert into exploracion values (04, 'Medición de temperatura', 2);
insert into exploracion values (04, 'Medición de presión arterial', 2);
insert into exploracion values (05, 'Medición de temperatura', 3);
insert into exploracion values (05, 'Medición de presión arterial', 3);
insert into exploracion values (05, 'Análise de sangue', 3);
insert into exploracion values (06, 'Medición de temperatura', 3);
insert into exploracion values (06, 'Medición de presión arterial', 3);
insert into exploracion values (06, 'TAC', 5);
insert into exploracion values (06, 'Radiografía', 4);
insert into exploracion values (07, 'Radiografía', 4);
insert into exploracion values (08, 'Radiografía', 4);
insert into exploracion values (09, 'Radiografía', 5);
insert into exploracion values (10, 'TAC', 5);
insert into exploracion values (11, 'Análise de sangue', 5);
insert into exploracion values (11, 'TAC', 5);
insert into exploracion values (11, 'Ecografía', 6);
insert into exploracion values (12, 'TAC', 6);
insert into exploracion values (13, 'Ecografía', 6);
insert into exploracion values (14, 'Ecografía', 1);
insert into exploracion values (15, 'Ecografía', 1);
insert into exploracion values (16, 'Ecografía', 2);
insert into exploracion values (16, 'Análise de sangue', 2);
insert into exploracion values (22, 'Análise de sangue', 2);
insert into exploracion values (22, 'Resonancia magnética', 3);
insert into exploracion values (23, 'Resonancia magnética', 3);
insert into exploracion values (24, 'Resonancia magnética', 3);
insert into exploracion values (25, 'Resonancia magnética', 4);
insert into exploracion values (26, 'Análise de sangue', 5);
insert into exploracion values (26, 'TAC', 6);
insert into exploracion values (26, 'Resonancia magnética', 1);
insert into exploracion values (27, 'Análise de sangue', 1);
insert into exploracion values (28, 'Análise de sangue', 1);
insert into exploracion values (29, 'Radiografía', 2);
insert into exploracion values (30, 'Radiografía', 3);
insert into exploracion values (31, 'Radiografía', 4);
insert into exploracion values (31, 'Medición de temperatura', 4);
insert into exploracion values (31, 'Medición de presión arterial', 4);
insert into exploracion values (32, 'Radiografía', 5);
insert into exploracion values (32, 'Medición de temperatura', 5);
insert into exploracion values (32, 'Medición de presión arterial', 5);
insert into exploracion values (33, 'Radiografía', 5);
insert into exploracion values (33, 'Medición de temperatura', 5);
insert into exploracion values (34, 'Medición de temperatura', 5);
insert into exploracion values (34, 'Medición de presión arterial', 5);
insert into exploracion values (34, 'Radiografía', 5);
insert into exploracion values (35, 'Medición de temperatura', 5);
insert into exploracion values (36, 'Medición de temperatura', 5);
insert into exploracion values (36, 'Medición de presión arterial', 5);

-- Insertar parámetros

insert into parametros values (01, 'Análise de sangue', 'Glóbulos vermellos', '10');
insert into parametros values (01, 'Análise de sangue', 'Glóbulos blancos', '3.5');
insert into parametros values (02, 'Análise de sangue', 'Glóbulos vermellos', '11');
insert into parametros values (02, 'Análise de sangue', 'Glóbulos blancos', '3.7');
insert into parametros values (03, 'Análise de sangue', 'Glóbulos vermellos', '9');
insert into parametros values (03, 'Análise de sangue', 'Glóbulos blancos', '3.4');
insert into parametros values (04, 'Análise de sangue', 'Glóbulos vermellos', '13');
insert into parametros values (04, 'Análise de sangue', 'Glóbulos blancos', '3.9');
insert into parametros values (05, 'Análise de sangue', 'Glóbulos vermellos', '8');
insert into parametros values (05, 'Análise de sangue', 'Glóbulos blancos', '3.1');
insert into parametros values (04, 'Medición de temperatura', 'Temperatura', '38');
insert into parametros values (04, 'Medición de presión arterial', 'Sistólica', '13');
insert into parametros values (04, 'Medición de presión arterial', 'Diastólica', '8');
insert into parametros values (05, 'Medición de temperatura', 'Temperatura', '38');
insert into parametros values (05, 'Medición de presión arterial', 'Sistólica', '11');
insert into parametros values (05, 'Medición de presión arterial', 'Diastólica', '8');
insert into parametros values (06, 'Medición de temperatura', 'Temperatura', '38');
insert into parametros values (06, 'Medición de presión arterial', 'Sistólica', '14');
insert into parametros values (06, 'Medición de presión arterial', 'Diastólica', '9');
insert into parametros values (06, 'TAC', 'Resultado', 'Enlace ao resultado');
insert into parametros values (06, 'Radiografía', 'Fotografía 1', 'Enlace');
insert into parametros values (06, 'Radiografía', 'Fotografía 2', 'Enlace');
insert into parametros values (07, 'Radiografía', 'Fotografía 1', 'Enlace');
insert into parametros values (07, 'Radiografía', 'Fotografía 2', 'Enlace');
insert into parametros values (07, 'Radiografía', 'Fotografía 3', 'Enlace');
insert into parametros values (08, 'Radiografía', 'Fotografía 1', 'Enlace');
insert into parametros values (09, 'Radiografía', 'Fotografía 1', 'Enlace');
insert into parametros values (09, 'Radiografía', 'Fotografía 2', 'Enlace');
insert into parametros values (10, 'TAC', 'Resultado', 'Enlace ao resultado');
insert into parametros values (11, 'Análise de sangue', 'Glóbulos vermellos', '14');
insert into parametros values (11, 'Análise de sangue', 'Glóbulos blancos', '2.9');
insert into parametros values (11, 'TAC', 'Resultado', 'Enlace ao resultado');
insert into parametros values (11, 'Ecografía', 'Fotografía 1', 'Enlace');
insert into parametros values (11, 'Ecografía', 'Fotografía 2', 'Enlace');
insert into parametros values (11, 'Ecografía', 'Fotografía 3', 'Enlace');
insert into parametros values (12, 'TAC', 'Resultado', 'Enlace ao resultado');
insert into parametros values (13, 'Ecografía', 'Fotografía 1', 'Enlace');
insert into parametros values (13, 'Ecografía', 'Fotografía 2', 'Enlace');
insert into parametros values (14, 'Ecografía', 'Fotografía 1', 'Enlace');
insert into parametros values (14, 'Ecografía', 'Fotografía 2', 'Enlace');
insert into parametros values (15, 'Ecografía', 'Fotografía 1', 'Enlace');
insert into parametros values (15, 'Ecografía', 'Fotografía 2', 'Enlace');
insert into parametros values (16, 'Ecografía', 'Fotografía 1', 'Enlace');
insert into parametros values (16, 'Ecografía', 'Fotografía 2', 'Enlace');
insert into parametros values (16, 'Análise de sangue', 'Glóbulos vermellos', '13');
insert into parametros values (16, 'Análise de sangue', 'Glóbulos blancos', '3.2');
insert into parametros values (22, 'Análise de sangue', 'Glóbulos vermellos', '11');
insert into parametros values (22, 'Análise de sangue', 'Glóbulos blancos', '3.6');
insert into parametros values (22, 'Resonancia magnética', 'Resultado', 'Enlace ao resultado');
insert into parametros values (23, 'Resonancia magnética', 'Resultado', 'Enlace ao resultado');
insert into parametros values (24, 'Resonancia magnética', 'Resultado', 'Enlace ao resultado');
insert into parametros values (25, 'Resonancia magnética', 'Resultado', 'Enlace ao resultado');
insert into parametros values (26, 'Análise de sangue', 'Glóbulos vermellos', '14');
insert into parametros values (26, 'Análise de sangue', 'Glóbulos blancos', '2.9');
insert into parametros values (27, 'Análise de sangue', 'Glóbulos vermellos', '13');
insert into parametros values (27, 'Análise de sangue', 'Glóbulos blancos', '3.2');
insert into parametros values (28, 'Análise de sangue', 'Glóbulos vermellos', '11');
insert into parametros values (28, 'Análise de sangue', 'Glóbulos blancos', '3.6');
insert into parametros values (29, 'Radiografía', 'Fotografía 1', 'Enlace');
insert into parametros values (29, 'Radiografía', 'Fotografía 2', 'Enlace');
insert into parametros values (29, 'Radiografía', 'Fotografía 3', 'Enlace');
insert into parametros values (30, 'Radiografía', 'Fotografía 1', 'Enlace');
insert into parametros values (30, 'Radiografía', 'Fotografía 2', 'Enlace');
insert into parametros values (31, 'Medición de temperatura', 'Temperatura', '37');
insert into parametros values (31, 'Medición de presión arterial', 'Sistólica', '13');
insert into parametros values (31, 'Medición de presión arterial', 'Diastólica', '8');
insert into parametros values (32, 'Radiografía', 'Fotografía 1', 'Enlace');
insert into parametros values (32, 'Medición de temperatura', 'Temperatura', '38');
insert into parametros values (32, 'Medición de presión arterial', 'Sistólica', '11');
insert into parametros values (32, 'Medición de presión arterial', 'Diastólica', '7');
insert into parametros values (33, 'Radiografía', 'Fotografía 1', 'Enlace');
insert into parametros values (33, 'Medición de temperatura', 'Temperatura', '39');
insert into parametros values (34, 'Medición de presión arterial', 'Sistólica', '14');
insert into parametros values (34, 'Medición de presión arterial', 'Diastólica', '9');
insert into parametros values (34, 'Radiografía', 'Fotografía 1', 'Enlace');
insert into parametros values (35, 'Medición de temperatura', 'Temperatura', '39');
insert into parametros values (36, 'Medición de temperatura', 'Temperatura', '39');
insert into parametros values (36, 'Medición de presión arterial', 'Sistólica', '13');
insert into parametros values (36, 'Medición de presión arterial', 'Distólica', '8');

-- Insertar tratamentos

insert into tratamento values (01, to_date('01/03/2020', 'DD/MM/YYYY'), to_date('01/04/2020', 'DD/MM/YYYY'), 1, 111);
insert into tratamento values (02, to_date('03/03/2020', 'DD/MM/YYYY'), to_date('03/04/2020', 'DD/MM/YYYY'), 3, 222);
insert into tratamento values (03, to_date('04/03/2020', 'DD/MM/YYYY'), to_date('04/04/2020', 'DD/MM/YYYY'), 4, 222);
insert into tratamento values (04, to_date('07/03/2020', 'DD/MM/YYYY'), to_date('07/04/2020', 'DD/MM/YYYY'), 5, 222);
insert into tratamento values (05, to_date('10/03/2020', 'DD/MM/YYYY'), to_date('10/04/2020', 'DD/MM/YYYY'), 6, 333);
insert into tratamento values (06, to_date('13/03/2020', 'DD/MM/YYYY'), to_date('13/04/2020', 'DD/MM/YYYY'), 7, 333);
insert into tratamento values (07, to_date('15/03/2020', 'DD/MM/YYYY'), to_date('15/05/2020', 'DD/MM/YYYY'), 1, 333);
insert into tratamento values (08, to_date('17/03/2020', 'DD/MM/YYYY'), to_date('17/05/2020', 'DD/MM/YYYY'), 1, 444);
insert into tratamento values (09, to_date('19/03/2020', 'DD/MM/YYYY'), to_date('19/05/2020', 'DD/MM/YYYY'), 1, 444);
insert into tratamento values (10, to_date('20/04/2020', 'DD/MM/YYYY'), to_date('20/05/2020', 'DD/MM/YYYY'), 3, 666);
insert into tratamento values (11, to_date('21/04/2020', 'DD/MM/YYYY'), to_date('04/05/2020', 'DD/MM/YYYY'), 4, 777);
insert into tratamento values (12, to_date('22/04/2020', 'DD/MM/YYYY'), to_date('05/05/2020', 'DD/MM/YYYY'), 4, 888);
insert into tratamento values (13, to_date('23/04/2020', 'DD/MM/YYYY'), to_date('06/05/2020', 'DD/MM/YYYY'), 5, 999);
insert into tratamento values (14, to_date('23/04/2020', 'DD/MM/YYYY'), to_date('23/05/2020', 'DD/MM/YYYY'), 6, 100);
insert into tratamento values (15, to_date('23/04/2020', 'DD/MM/YYYY'), to_date('23/05/2020', 'DD/MM/YYYY'), 6, 200);
insert into tratamento values (16, to_date('24/04/2020', 'DD/MM/YYYY'), to_date('14/05/2020', 'DD/MM/YYYY'), 7, 300);
insert into tratamento values (17, to_date('25/04/2020', 'DD/MM/YYYY'), to_date('10/05/2020', 'DD/MM/YYYY'), 1, 400);
insert into tratamento values (18, to_date('26/04/2020', 'DD/MM/YYYY'), to_date('11/05/2020', 'DD/MM/YYYY'), 1, 400);
insert into tratamento values (19, to_date('28/04/2020', 'DD/MM/YYYY'), to_date('13/05/2020', 'DD/MM/YYYY'), 3, 111);
insert into tratamento values (20, to_date('28/04/2020', 'DD/MM/YYYY'), to_date('08/05/2020', 'DD/MM/YYYY'), 3, 123);
insert into tratamento values (21, to_date('29/04/2020', 'DD/MM/YYYY'), to_date('09/05/2020', 'DD/MM/YYYY'), 4, 123);
insert into tratamento values (22, to_date('30/04/2020', 'DD/MM/YYYY'), to_date('13/05/2020', 'DD/MM/YYYY'), 5, 111);
insert into tratamento values (23, to_date('30/04/2020', 'DD/MM/YYYY'), to_date('16/05/2020', 'DD/MM/YYYY'), 6, 222);
insert into tratamento values (24, to_date('30/04/2020', 'DD/MM/YYYY'), to_date('19/05/2020', 'DD/MM/YYYY'), 7, 333);

-- Insertar prescricións

insert into prescricion values (01, 'Ibuprofeno', '400 mg', '1 pastilla cada 8 horas');
insert into prescricion values (01, 'Paracetamol', '1000 mg', '1 pastilla cada 6 horas');
insert into prescricion values (01, 'Alprazolam', '0.25 mg', '3 veces');
insert into prescricion values (01, 'Sibellium', '10 mg', '3 sobres ao día');
insert into prescricion values (01, 'Diazepam', '5 mg', '2 veces ao día');
insert into prescricion values (02, 'Ibuprofeno', '400 mg', '1 pastilla cada 8 horas');
insert into prescricion values (02, 'Paracetamol', '1000 mg', '1 pastilla cada 6 horas');
insert into prescricion values (02, 'Alprazolam', '0.25 mg', '3 veces');
insert into prescricion values (02, 'Sibellium', '10 mg', '3 sobres ao día');
insert into prescricion values (03, 'Ibuprofeno', '400 mg', '1 pastilla cada 8 horas');
insert into prescricion values (03, 'Paracetamol', '1000 mg', '1 pastilla cada 6 horas');
insert into prescricion values (03, 'Alprazolam', '0.25 mg', '3 veces');
insert into prescricion values (04, 'Ibuprofeno', '400 mg', '1 pastilla cada 12 horas');
insert into prescricion values (04, 'Paracetamol', '1000 mg', '1 pastilla cada 8 horas');
insert into prescricion values (05, 'Ibuprofeno', '400 mg', '1 pastilla cada 12 horas');
insert into prescricion values (05, 'Paracetamol', '1000 mg', '1 pastilla cada 8 horas');
insert into prescricion values (05, 'Diazepam', '5 mg', '2 veces ao día');
insert into prescricion values (06, 'Ibuprofeno', '600 mg', '1 pastilla cada 12 horas');
insert into prescricion values (06, 'Paracetamol', '1600 mg', '1 pastilla cada 8 horas');
insert into prescricion values (07, 'Ibuprofeno', '600 mg', '1 pastilla cada 12 horas');
insert into prescricion values (07, 'Paracetamol', '1600 mg', '1 pastilla cada 8 horas');
insert into prescricion values (08, 'Ibuprofeno', '600 mg', '1 pastilla cada 12 horas');
insert into prescricion values (08, 'Paracetamol', '1600 mg', '1 pastilla cada 8 horas');
insert into prescricion values (09, 'Paracetamol', '1600 mg', '1 pastilla cada 12 horas');
insert into prescricion values (09, 'Ibuprofeno', '600 mg', '1 pastilla cada 8 horas');
insert into prescricion values (10, 'Paracetamol', '1600 mg', '1 pastilla cada 12 horas');
insert into prescricion values (10, 'Sibellium', '10 mg', '3 sobres ao día');
insert into prescricion values (11, 'Paracetamol', '1600 mg', '1 pastilla cada 12 horas');
insert into prescricion values (11, 'Diazepam', '5 mg', '2 veces ao día');
insert into prescricion values (12, 'Paracetamol', '1600 mg', '1 pastilla cada 12 horas');
insert into prescricion values (12, 'Topiramato', '100 mg', '3 veces ao día');
insert into prescricion values (12, 'Sibellium', '10 mg', '3 sobres ao día');
insert into prescricion values (13, 'Paracetamol', '1600 mg', '1 pastilla cada 12 horas');
insert into prescricion values (13, 'Alprazolam', '0.5 mg', '2 veces ao día');
insert into prescricion values (13, 'Topiramato', '100 mg', '3 veces ao día');
insert into prescricion values (13, 'Sibellium', '10 mg', '3 sobres ao día');
insert into prescricion values (13, 'Sibilla', '0.3 mg', 'Unha vez ao día');
insert into prescricion values (14, 'Alprazolam', '0.5 mg', '2 veces ao día');
insert into prescricion values (15, 'Alprazolam', '0.5 mg', '2 veces ao día');
insert into prescricion values (15, 'Topiramato', '100 mg', '3 veces ao día');
insert into prescricion values (15, 'Diazepam', '5 mg', '3 veces ao día');
insert into prescricion values (16, 'Topiramato', '250 mg', '3 veces ao día');
insert into prescricion values (16, 'Sibilla', '0.3 mg', 'Unha vez ao día');
insert into prescricion values (17, 'Topiramato', '250 mg', '3 veces ao día');
insert into prescricion values (18, 'Topiramato', '250 mg', '3 veces ao día');
insert into prescricion values (18, 'Sibilla', '0.3 mg', 'Unha vez ao día');
insert into prescricion values (19, 'Topiramato', '250 mg', '3 veces ao día');
insert into prescricion values (19, 'Paracetamol', '1000 mg', '1 pastilla cada 12 horas');
insert into prescricion values (20, 'Sibilla', '0.5 mg', 'Unha vez ao día');
insert into prescricion values (21, 'Sibilla', '0.5 mg', 'Unha vez ao día');
insert into prescricion values (21, 'Diazepam', '5 mg', '3 veces ao día');
insert into prescricion values (22, 'Diazepam', '5 mg', '3 veces ao día');

commit;
