-- Traballo Tutelado Bases de Datos
-- Carlos Torres
-- Este script SQL contén todas as consultas necesarias para responder ás preguntas
-- da opción 1 do enunciado do TT

-- Punto 1
-- 1.Mostra todos os pacientes rexistrados na BD. Indica, para cada un: DNI; nome completo; data na que foi rexistrado/a por primeira vez no sistema; método de rexistro (chamada/ingreso centro hospitalario)

select dni, nome, ap1, ap2, to_char(datarex, 'DD/MM/YYYY') as "Data Rexistro", metodorex as "Método Rexistro"
from paciente;

-- Punto 2

-- 2.Mostra o identificador e nome completo de todos os pacientes que permanecían confinados na súa casa o dia 1 de maio de 2020 ás 00:00:00h.

select p.nhc, p.nome, p.ap1, p.ap2
from paciente p join ingreso i
on p.nhc = i.nhc
where i.datahorafin is null and i.lugar is null;

-- 3.Mostra o identificador e nome completo de todos os pacientes estaban ingresados nun centro hospitalario o día 1 de maio de 2020 ás 00:00:00h.

select p.nhc, p.nome, p.ap1, p.ap2
from paciente p join ingreso i
on p.nhc = i.nhc
where i.datahorafin is null and i.lugar is not null;

-- 4.Mostra o identificador e nome completo de todos os pacientes que estiveron ingresados en polo menos dous hospitais diferentes. Indica tamén cantos hospitais foron. 

select p.nhc, p.nome, p.ap1, p.ap2, count(distinct i.lugar) as "Num hospitales"
from paciente p join ingreso i
on p.nhc = i.nhc and i.lugar is not null
group by (p.nhc, p.nome, p.ap1, p.ap2)
having count (distinct i.lugar) >= 2;

-- 5.Mostra o identificador e nome completo de todos os pacientes que estiveron confinados no seu domicilio en dous ou mais períodos diferentes. Indica tamén cantas veces foron en total. 

select p.nhc, p.nome, p.ap1, p.ap2, count(distinct i.datahoraingreso) as "Num veces"
from paciente p join ingreso i
on p.nhc = i.nhc and i.lugar is null
group by (p.nhc, p.nome, p.ap1, p.ap2)
having count (distinct i.datahoraingreso) >= 2;

-- 6.Lista o identificador e nome completo de todos aqueles pacientes que xa foron dados de alta. Mostra tamén a data de alta.

select p.nhc, p.nome, p.ap1, p.ap2, to_date(max(i.datahorafin), 'DD/MM/YYYY') as "Data de alta"
from paciente p join ingreso i
on p.nhc = i.nhc
where p.nhc not in (
    select pp.nhc
    from paciente pp join ingreso ii
    on pp.nhc = ii.nhc
    where ii.datahorafin is null
)
group by (p.nhc, p.nome, p.ap1, p.ap2);

-- Punto 3

-- 7.Elixe un dos pacientes do resultado da consulta 2. Mostra a data e hora das próximas chamadas telefónicas programadas de control que lle hai que facer.

-- Elíxese o paciente con NHC = 400

select p.nhc, to_date (r.datahoracita, 'DD/MM/YYYY HH24:MI') as "DATAHORACITA"
from paciente p join revision r
on p.nhc = r.paciente
where p.nhc = 400
and r.lugar is null
and r.datahoracita >= to_date('01/05/2020', 'DD/MM/YYYY');

-- 8.Mostra, para o mesmo paciente, o número de chamadas realizadas ata agora nas que superou os 37º de temperatura e rexistrou unha tensión sistólica superior a 12.

select count(*) as "Num chamadas"
from parametros p1 join parametros p2
on p1.idrev = p2.idrev
where p1.idrev in (
    select r.idrev
    from revision r
    where r.paciente = 400 and r.lugar is null
)
and p1.tipo = 'Medición de temperatura' and p1.parametro = 'Temperatura' and p1.resultado > '37'
and p2.tipo = 'Medición de presión arterial' and p2.parametro = 'Sistólica' and p2.resultado > '12'
;

-- 9.Elixe un dos pacientes do resultado da consulta 3. Mostra a data e hora das próximas revisións periódicas programadas que lle hai que facer.

-- Elíxese o paciente con NHC = 222

select p.nhc, to_date(r.datahoracita, 'DD/MM/YYYY HH24:MI') as "DATAHORACITA"
from paciente p join revision r
on p.nhc = r.paciente
where p.nhc = 222
and r.lugar is not null
and r.datahoracita >= to_date('01/05/2020', 'DD/MM/YYYY');

-- 10.Mostra, para o mesmo paciente, o número de revisións realizadas ata agora nas que superou os 37º de temperatura e rexistrou unha tensión sistólica superior a 12.

select count(*) as "Num chamadas"
from parametros p1 join parametros p2
on p1.idrev = p2.idrev
where p1.idrev in (
    select r.idrev
    from revision r
    where r.paciente = 222 and r.lugar is not null
)
and p1.tipo = 'Medición de temperatura' and p1.parametro = 'Temperatura' and p1.resultado > '37'
and p2.tipo = 'Medición de presión arterial' and p2.parametro = 'Sistólica' and p2.resultado > '12'
;

-- 11.Mostra, para o mesmo paciente: tipo de exploracións realizadas na última revisión; nome do sanitario/a que realizou cada exploración; resultado de cada exploración. Podes utilizar directamente na consulta a data da revisión.

-- Para o paciente 222, a última revisión realizada foi o 16/04/2020

select r.idrev, e.tipo, p.parametro, p.resultado, s.nome
from revision r join exploracion e on
r.idrev = e.idrev
join sanitario s on
e.feitapor = s.nss
join parametros p
on e.idrev = p.idrev and e.tipo = p.tipo
where r.paciente = 222 and (to_char(r.datahoracita, 'DD/MM/YYYY') = '16/04/2020');

-- Punto 4

-- 12.Mostra, para cada equipo de sanitarios rexistrado na BD: identificador do equipo; nome do centro hospitalario no que traballa; número ACTUAL de integrantes; e data do último cambio na composición do equipo.

select e.idequipo, h.nome, (
    select count(pe.nss)
    from pertence pe
    where pe.datafin is null
    and pe.hospital = e.hosp
    and pe.equipo = e.idequipo
) as "Num integrantes",
(
    select max(datainicio)
    from pertence pe2
    where pe2.datafin is null
    and pe2.hospital = e.hosp
    and pe2.equipo = e.idequipo
) as "Data último cambio"
from equipo e join hospital h
on e.hosp = h.idhosp;

-- 13.Elixe un dos equipos do resultado da consulta 12. Mostra a lista (identificador; nome completo; posto; centro hospitalario) dos seus membros nunha data concreta (por exemplo, o día 01 de maio de 2020 ás 00:00:00 horas).

-- Elíxese o equipo 1 do hospital 7 (Meixoeiro)

select s.nss, s.nome, s.ap1, s.ap2, s.especialidade, h.nome as "HOSPITAL", pe.equipo
from pertence pe join sanitario s
on pe.nss = s.nss
join hospital h on pe.hospital = h.idhosp
where pe.hospital = 7 and pe.equipo = 1
and pe.datainicio <= to_date('01/05/2020', 'DD/MM/YYYY')
and ((pe.datafin is null) or (pe.datafin > to_date('01/05/2020', 'DD/MM/YYYY')));

-- 14.Indica, para cada centro hospitalario rexistrado na BD, que equipo (ou equipos) estará de garda o 01 de maio de 2020 ás 22:00:00. Mostra o identificador do equipo, o nome do centro hospitalario, e a data de inicio e fin da quenda que está cubrindo o equipo no centro hospitalario. 

select h.idhosp, h.nome, q.zona, q.equipo
from hospital h left join quenda q
on h.idhosp = q.hosp
and q.datahorainicio < to_date('01/05/2020 22:00', 'DD/MM/YYYY HH24:MI')
and q.datahorafin > to_date('01/05/2020 22:00', 'DD/MM/YYYY HH24:MI')
;

-- Punto 5

-- 15.Elixe a un dos pacientes do resultado da consulta 3. Mostra o tratamento que tiña establecido o día 01 de maio de 2020, ás 00:00:00h: nome do medicamento, dose establecida, e identificador e nome completo do sanitario que autorizou ese medicamento.

-- Elíxese o paciente con NHC = 111

select t.idtratamento, p.medicamento, p.dose, p.posoloxia, t.autoriza, s.nome, s.ap1, s.ap2
from tratamento t join prescricion p
on t.idtratamento = p.idtratamento
join sanitario s
on t.autoriza = s.nss
where t.paciente = 111
and t.datainicio < to_date('01/05/2020', 'DD/MM/YYYY')
and t.datafin > to_date('01/05/2020', 'DD/MM/YYYY')
;

-- Punto 6 

-- 16.Para cada tipo de material rexistrado na BD, indica o stock dispoñible en cada centro hospitalario. Mostra: nome do material; nome do centro hospitalario; unidades dispoñibles no centro; limiar mínimo de stock no centro; e diferencia entre eles.

select m.descricion as "Material", h.nome as "Hospital", (
    select count(us.nserie)
    from ustock us
    where us.material = m.idmat
    and us.hospital = h.idhosp
) as "Num unidades", sm.cantidade as "Stock min" , (
    select count(us.nserie)
    from ustock us
    where us.material = m.idmat
    and us.hospital = h.idhosp
) - sm.cantidade as "Diferencia"
from material m cross join hospital h left join stockmin sm
on m.idmat = sm.material and h.idhosp = sm.hospital
;

-- Punto 7

-- 17.Elixe a un dos equipos da consulta 14. Queremos saber as unidades concretas de material que foron usadas durante a quenda cuberta na dita consulta 14 polo equipo en cuestión. Mostra a referencia do material, e o tipo/nome de material.

-- Escollo o Equipo 3 do Hospital 1 (CHUAC). Cubre a quenda das 15:00 do 01/05 ás 23:00 do 02/05 na UCI do CHUAC

select us.nserie, m.descricion
from ustock us join material m
on us.material = m.idmat
where us.hospital = 1 and us.zona = 'UCI' and us.datahora = to_date('01/05/2020 15:00', 'DD/MM/YYYY HH24:MI');

-- Consultas libres

-- 18. Consulta cun join exterior de tres táboas ou máis
-- Consulta: Mostra, para cada sanitario da BD (nss, nome e especialidade), o nome do hospital no que traballaba (e a cidade) a día 2 de xaneiro do 2018
-- Mostrar TODOS os sanitarios, tamén os que non estaban traballando en ningún hospital nesa data

select s.nss, s.nome, s.ap1, s.ap2, s.especialidade, h.nome as Hospital, h.loc as Cidade
from sanitario s LEFT join pertence p
on s.nss = p.nss
and p.datainicio < to_date('02/01/2018', 'DD/MM/YYYY')
and ((p.datafin is null) or (p.datafin > to_date('02/01/2018', 'DD/MM/YYYY')))
left join hospital h
on p.hospital = h.idhosp;

-- 19. Consulta con expresión de consulta
-- Consulta: Mostra para cada paciente, o número de sanitarios cos que tivo trato algunha vez (sexa por unha exploración ou por recetarlle un tratamento)

select p.nhc, p.nome, p.ap1, p.ap2, (
    select count(distinct ee.feitapor)
    from exploracion ee join revision rr on ee.idrev = rr.idrev
    where rr.paciente = p.nhc
) + (
    select count(distinct tt.autoriza)
    from tratamento tt
    where tt.paciente = p.nhc
) as "Num sanitarios"
from paciente p;

-- 20. Consulta con subconsulta de fila
-- Consulta: Mostra o identificador e nome completo de todos os sanitarios que traballaron algunha vez nunha UCI
-- Nota: Téñense en conta só as quendas anteriores ao 01/05/2020 porque se asume que a consulta está sendo executada nese momento.
-- Realmente a consulta debería ser con "where q.datahorainicio < CURRENT_DATE"

select distinct s.nss, s.nome, s.ap1, s.ap2
from sanitario s join pertence p
on s.nss = p.nss
where (p.hospital, p.equipo) in (
    select q.hosp, q.equipo
    from quenda q
    where q.datahorainicio < to_date('01/05/2020', 'DD/MM/YYYY')
    and q.datahorainicio > p.datainicio
    and ((p.datafin is null) or (q.datahorainicio < p.datafin))
    and q.zona = 'UCI'
);
