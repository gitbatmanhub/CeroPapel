create table material
(
    idMaterial   int(5) not null primary key auto_increment,
    nameMaterial varchar(100)
);

create table maquinaria_Material
(
    idMaquinaria_Material int(7) not null primary key auto_increment,
    idMaterial            int(5) not null,
    idOrdenFabricacion    int(7) not null
);

create table maquinaria
(
    idMaquinaria   int(4)      not null primary key auto_increment,
    nameMaquinaria varchar(50) not null
);

create table turno
(
    idTurno    int(2)      not null primary key auto_increment,
    nameTurno  varchar(50) not null,
    horasTurno int(2)      not null
);

create table tipoPara
(
    idTipoPara   int(3) not null primary key auto_increment,
    nameTipoPara varchar(20)

);

create table horas_Para
(
    idHoras_Para       int(7)       not null primary key auto_increment,
    create_at          timestamp default current_timestamp,
    idTipoPara         int(3)       not null,
    comentario         varchar(500) not null,
    inicioPara         datetime     not null,
    finPara            datetime     not null,
    idOrdenFabricacion int(7)
);


create table kg_material
(
    idKg_Material         int(7) not null primary key auto_increment,
    idMaquinaria_Material int(7),
    pesoKg                int(6),
    create_at             timestamp default current_timestamp,
    horasTrabajadas       int(2)
);


create table operador
(
    idOperador     int(5) not null primary key auto_increment,
    idtipoOperador int(5) not null,
    idUsuario      int(6) not null
);

alter table operador
    add constraint fk_idOperadorusuario foreign key (idUsuario) references usuario (iduser);
alter table operador
    add constraint fk_operadorTipo foreign key (idtipoOperador) references operador (idOperador);

create table ordenFabricacion
(
    idOrdenFabricacion int(7) not null primary key auto_increment,
    create_at          timestamp default current_timestamp,
    fecha              datetime,
    idMaquinaria       int(4) not null,
    idTurno            int(2) not null,
    idOperador         int(5) not null,
    idCreador          int(6) not null

);

/*
 create table horastrabajoOF
(
    idHorasTrabajo int(7) not null primary key auto_increment,
    idOperador int(5) not null,
    idOrdenFabricacion int(7) not null,
    create_at timestamp default current_timestamp

);

 */

select *
from ordenFabricacion;
select *
from operador;


alter table ordenFabricacion
    add constraint fk_idCreador foreign key (idCreador) references usuario (iduser);


alter table ordenFabricacion
    add constraint fk_idMaquinaria foreign key (idMaquinaria) references maquinaria (idMaquinaria);

alter table ordenFabricacion
    add constraint fk_idOperador foreign key (idOperador) references operador (idOperador);

alter table operador
    add constraint fk_idUsuarioOperador foreign key (idUsuario) references usuario (iduser);


alter table maquinaria_Material
    add constraint fk_idMaterial foreign key (idMaterial) references material (idMaterial);

alter table maquinaria_Material
    add constraint fk_OrdenFabricacion foreign key (idOrdenFabricacion) references ordenFabricacion (idOrdenFabricacion);

alter table horas_Para
    add constraint fk_idTipoPara foreign key (idTipoPara) references tipoPara (idTipoPara);


alter table horas_Para
    add constraint fk_idOrdenFabricacion foreign key (idOrdenFabricacion) references ordenFabricacion (idOrdenFabricacion);


alter table kg_material
    add column idOrdenFabricacion int(7) not null;

alter table kg_material
    add constraint fk_idOrdenFabricacionKg_material foreign key (idOrdenFabricacion) references ordenFabricacion (idOrdenFabricacion);

alter table kg_material
    add constraint fk_idMaquinaria_Material foreign key (idMaquinaria_Material) references maquinaria_Material (idMaquinaria_Material);

drop table velocidadNominal;
create table velocidadNominal
(
    idVelocidadNominal int(5) not null primary key auto_increment,
    velocidad          double not null,
    idMaquinaria       int(4) not null
);



alter table velocidadNominal
    add constraint fk_idMaquinariaVelocidad foreign key (idMaquinaria) references maquinaria (idMaquinaria);

describe horas_Para;


select *
from ordenFabricacion;
describe ordenFabricacion;
insert into maquinaria(nameMaquinaria)
values ("COMPACTADORA"),
       ("MOLINO HOGAR"),
       ("MOLINO ZUNCHO"),
       ("LAVADORA PET"),
       ("LAVADORA HOGAR"),
       ("PELLETIZADORA 1"),
       ("PELLETIZADORA 2"),
       ("PELLETIZADORA 3"),
       ("LAVADORA FILM"),
       ("AGLOMERADORA"),
       ("MAQUILA TAIRI"),
       ("SEPARADORA DE COLORES"),
       ("ELECTROIMAN"),
       ("PTAR"),
       ("LOGISTICA"),
       ("OPERACIONES"),
       ("PROYECTOS"),
       ("MONTACARGAS");


alter table ordenFabricacion
    add constraint fk_idTurnoOf foreign key (idTurno) references turno (idTurno);


insert into turno(nameTurno, horasTurno)
VALUES ("Diurno", 12),
       ("Nocturno", 12);




create table tipoOperador
(
    idTipoOperador   int(3) primary key not null auto_increment,
    nameTipoOperador varchar(20)        not null
);




alter table operador
    add constraint fk_tipoOperador foreign key (idOperador) references tipoOperador (idTipoOperador);


insert into tipoOperador (nameTipoOperador)
values ("Principal");

insert into tipoOperador (nameTipoOperador)
values ("Ayudante");



/*
insert into operador (idtipoOperador, idUsuario)
values (1, 11);

 */


update operador
set idtipoOperador=2
where idUsuario = 11;

select *
from operador;




create table statusOF
(
    idStatus   int(2)      not null auto_increment primary key,
    nameStatus varchar(20) not null
);

alter table ordenFabricacion
    add column idstatus int(2) not null;
alter table ordenFabricacion
    add constraint fk_idOrdenfabricacionStatus foreign key (idstatus) references statusOF (idStatus);

insert into statusOF(nameStatus)
values ("Abierta"),
       ("Cerrada");



#drop view ordenFabricacionTodosDatos;


create view ordenFabricacionTodosDatos as
select o2.idOrdenFabricacion,
       o2.create_at,
       iduser,
       m.nameMaquinaria,
       t.nameTurno,
       t2.nameTipoOperador,
       u.fullname                     as operador,
       o2.idOperador,
       o2.idstatus,
       DATE_FORMAT(fecha, "%d/%m/%Y") as fecha,
       sF.nameStatus
from ordenFabricacion o2
         inner join maquinaria m on o2.idMaquinaria = m.idMaquinaria
         inner join turno t on o2.idTurno = t.idTurno
         inner join operador o on o2.idOperador = o.idOperador
         inner join tipooperador t2 on o.idtipoOperador = t2.idTipoOperador
         inner join usuario u on o.idUsuario = u.iduser
         inner join statusOF sF on o2.idstatus = sF.idStatus;

select *
from ordenFabricacionTodosDatos;

select *
from ordenFabricacionTodosDatos
where iduser = 11;



select DATE_FORMAT(fecha, "%y/%m/%d") as fecha
from ordenFabricacion;

select *
from ordenFabricacion;

select *
from tipooperador;
select *
from operador;

DELETE
FROM ordenFabricacion;

select *
from usuario;

select *
from ordenFabricacion;
use bddnova;
select *
from usuario;
select *
from rolusuario;

select *
from tipopara;

insert into tipopara (nameTipoPara)
values ("MANT. PREVENTIVO"),
       ("LIMPIEZA"),
       ("DAÑO"),
       ("LOGISTICA"),
       ("OPERACION"),
       ("OTROS"),
       ("ADMINISTRATIVA"),
       ("ALIMENTACION");


select *
from horas_Para;
delete
from horas_Para;
describe horas_Para;

alter table horas_Para
    modify column inicioPara time not null;
alter table horas_Para
    modify column finPara time not null;
alter table horas_Para
    modify column idOrdenFabricacion int(7) not null;


select hP.inicioPara, hP.finPara, hP.comentario, t.nameTipoPara
from horas_Para hP
         inner join tipopara t on hP.idTipoPara = t.idTipoPara
where idOrdenFabricacion = 5;


select *
from material;
insert into material(nameMaterial)
values ("PEAD"),
       ("PP"),
       ("PPAI"),
       ("PP SOPLADO"),
       ("JUGUETE"),
       ("SILLA"),
       ("SACOS"),
       ("TARRINA"),
       ("LAMINA"),
       ("CELOFAN"),
       ("ZUNCHO PP"),
       ("ZUNCHO PET"),
       ("ZUNCHO MEZCLADO"),
       ("PET"),
       ("PVC"),
       ("TORTA PP"),
       ("TORTA PEAD"),
       ("TORTA ZUNCHO PP"),
       ("TORTA FILM"),
       ("TORTA TAIRI"),
       ("TORTA ALFAJIAS"),
       ("MAQ. PP"),
       ("MAQ. PP SOPLADO"),
       ("MAQ. PEAD"),
       ("MAQ. SILLA"),
       ("MAQ. LAMINA"),
       ("MAQ. TARRINA"),
       ("MAQ. SACOS"),
       ("MAQ. CINTA"),
       ("MAQ. PVC"),
       ("MAQ. ZUNCHO PET"),
       ("MAQ. ZUNCHO PP"),
       ("MAQ. ZUNCHO MEZCLADO"),
       ("FILM ALTA"),
       ("FILM BAJA"),
       ("FILM CHICLE"),
       ("ALFAJIAS"),
       ("ESQUINEROS"),
       ("ESTACAS"),
       ("TUTORES"),
       ("SEPARADORES"),
       ("PT SILLA FARISA"),
       ("PT SILLA CON BRAZOS"),
       ("PT TABLERO"),
       ("PT TAPAS"),
       ("PT PATAS"),
       ("PT GAVETA CALADA"),
       ("PT GAVETA CONICA"),
       ("CHATARRA"),
       ("PTAR"),
       ("n/a");
select *
from material;
select *
from maquinaria;
select m.nameMaterial, m.idMaterial, mM.idMaquinaria_Material
from maquinaria_Material mM
         inner join material m on mM.idMaterial = m.idMaterial;
SELECT *
FROM kg_material;


alter table kg_material
    drop constraint fk_idMaquinaria_Material;
alter table kg_material
    drop column idMaquinaria_Material;

select *
from ordenFabricacion;

select m.nameMaterial, kgM.pesoKg, kgM.horasTrabajadas
from kg_material kgM
         inner join ordenFabricacion o on kgM.idOrdenFabricacion = o.idOrdenFabricacion
         inner join maquinaria_Material mM on mM.idOrdenFabricacion = o.idOrdenFabricacion
         inner join material m on mM.idMaterial = m.idMaterial
where o.idOrdenFabricacion = 5;

select *
from maquinaria_Material;

select *
from ordenFabricacion;

select *
from statusOF;
select *
from tipooperador;



select *
from ordenFabricacionTodosDatos;
select *
from ordenFabricacion;

select *
from kg_material;

select kgM.idKg_Material, m.nameMaterial, kgM.pesoKg, kgM.horasTrabajadas
from kg_material kgM
         inner join ordenFabricacion o on kgM.idOrdenFabricacion = o.idOrdenFabricacion
         inner join maquinaria_Material mM on mM.idOrdenFabricacion = o.idOrdenFabricacion
         inner join material m on mM.idMaterial = m.idMaterial
where o.idOrdenFabricacion = 7
group by horasTrabajadas;


select *
from kg_material
where kg_material.idOrdenFabricacion = 7;
delete
from kg_material;
delete
from maquinaria_material;
delete
from horas_Para;

describe kg_material;
alter table kg_material
    add column idMaterial int(7) not null;
alter table kg_material
    add constraint idMaterialKg foreign key (idMaterial) references material (idMaterial);



select kgM.idKg_Material, m.nameMaterial, kgM.pesoKg, kgM.horasTrabajadas
from kg_material kgM
         inner join ordenFabricacion o on kgM.idOrdenFabricacion = o.idOrdenFabricacion
         inner join maquinaria_Material mM on mM.idOrdenFabricacion = o.idOrdenFabricacion
         inner join material m on mM.idMaterial = m.idMaterial
where o.idOrdenFabricacion = 7
group by horasTrabajadas;

select *
from maquinaria_material;
select *
from kg_material;
select kg.pesoKg, kg.horasTrabajadas, m.nameMaterial
from kg_material kg
         inner join material m on m.idMaterial = kg.idMaterial
where kg.idOrdenFabricacion = 5;

select *
from ordenFabricacionTodosDatos;

select *
from turno;
insert into tipopara(nameTipoPara)
values ("FUERA HORARIO");

select *
from ordenFabricacion
where idOrdenFabricacion = 7;

update ordenFabricacion
set ordenFabricacion.idstatus=1;

select *
from statusOF;
select *
from ordenFabricacionTodosDatos;
select *
from ordenFabricacion;


select *
from operador;
select *
from tipoOperador;



select u.fullname, t.nameTipoOperador, o.idOperador
from operador o
         inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador
         inner join usuario u on o.idUsuario = u.iduser;



select *
from ordenFabricacion;

delete
from ordenFabricacion;

delete
from horas_Para;

select *
from kg_material;
alter table kg_material
    drop column horasTrabajadas;
alter table kg_material
    add column hInicioTM time not null;
alter table kg_material
    add column hFinTM time not null;
select *
from kg_material;


select km.idOrdenFabricacion, m.nameMaterial, km.pesoKg, km.hInicioTM, km.hFinTM
from kg_material km
         inner join material m on m.idMaterial = km.idMaterial
where idOrdenFabricacion = ?;

#drop view horasMaterial;
create view horasMaterial as;
SELECT IF(
                   kg.hInicioTM <= kg.hFinTM,
                   TIMEDIFF(kg.hFinTM, kg.hInicioTM),
                   ADDTIME(TIMEDIFF('24:00:00', kg.hInicioTM), kg.hFinTM)
           ) AS horasMaterial,
       idOrdenFabricacion
from kg_material kg;


drop view horasMaterial;
drop view horasPara;
drop view ordenFabricacionTodosDatos;

create view horasPara as
SELECT IF(
                   hp.inicioPara <= hp.finPara,
                   timediff(hp.finPara, hp.inicioPara),
                   addtime(timediff('24:00:00', hp.inicioPara), hp.finPara)
           ) as horasPara,
       idOrdenFabricacion
from horas_Para hp;

select addtime(hp.finPara, -hp.inicioPara) as horasPara, idOrdenFabricacion
from horas_Para hp;



SELECT IF(
                   kg.hInicioTM <= kg.hFinTM,
                   TIMEDIFF(kg.hFinTM, kg.hInicioTM),
                   ADDTIME(TIMEDIFF('24:00:00', kg.hInicioTM), kg.hFinTM)
           ) AS horas_diferencia
from kg_material kg
where idOrdenFabricacion = 11;


delete
from horas_Para;
delete
from kg_material;

use bddnova;
alter table ordenFabricacion
    drop column fecha;
alter table ordenFabricacion
    drop column idTurno;
drop table ordenFabricacion;
drop table kg_material;
drop table horas_Para;


#drop view totalHorasPara;
#Fail
create view totalHorasMaterial as
select sec_to_time(sum(time_to_sec(horas))) as horasMaterial, idOrdenFabricacion
from horasMaterial;

drop view totalHorasPara;
create view totalHorasPara as
select sec_to_time(sum(time_to_sec(horasPara))) as horasPara, idOrdenFabricacion
from horasPara;



select *
from horasMaterial
where idOrdenFabricacion = 11;
select *
from horasPara
where idOrdenFabricacion = 11;
select sec_to_time(sum(time_to_sec(horas))) as horasMaterial, idOrdenFabricacion
from horasMaterial
where idOrdenFabricacion = 11;
select sec_to_time(sum(time_to_sec(horasPara))) as horasPara, idOrdenFabricacion
from horasPara
where idOrdenFabricacion = 11;



select timediff(tHP.horasPara, tHM.horasMaterial) as Diferencia
from totalHorasMaterial tHM
         inner join totalHorasPara tHP on tHM.idOrdenFabricacion = tHP.idOrdenFabricacion;



SELECT IF(
                   '21:00:00' <= '03:00:00',
                   TIMEDIFF('03:00:00', '21:00:00'),
                   ADDTIME(TIMEDIFF('24:00:00', '21:00:00'), '03:00:00')
           ) AS horas_diferencia
from kg_material;

select idKg_Material, pesoKg, hInicioTM, hFinTM
from kg_material
where kg_material.idOrdenFabricacion = 11;

select *
from horasMaterial
where idOrdenFabricacion = 11;


create table ordenFabricacion
(
    idOrdenFabricacion int(7) not null primary key auto_increment,
    idMaquinaria       int(5) not null,
    idMaterial         int(5) not null,
    create_at          timestamp default current_timestamp
);
create table horasParas
(
    idHorasPara int(7)       not null primary key auto_increment,
    horaInicio  time         not null,
    horaFinal   time         not null,
    motivo      int(3)       not null,
    comentario  varchar(500) not null
);
alter table horasParas
    add column idOrdeFabricacion int(7) not null;
alter table horasParas
    add constraint fk_idOrdenfabricacionHorasPara foreign key (idOrdeFabricacion) references ordenFabricacion (idOrdenFabricacion);



create table kgMaterial
(
    idkgMaterial      int(7) not null primary key auto_increment,
    kg                int(5) not null,
    idOrdeFabricacion int(7) not null
);
alter table kgMaterial rename column idOrdeFabricacion to idOrdenFabricacion;

alter table kgMaterial
    add constraint fk_idOrdenFabricacionkgMaterial foreign key (idOrdenFabricacion) references ordenFabricacion (idOrdenFabricacion);

create table horasOrdenFabricacion
(
    idhorasOrdenFabricacion int(6) not null primary key auto_increment,
    horaInicio              time   not null,
    horaFinal               time   not null,
    idOrdeFabricacion       int(7) not null
);
alter table horasOrdenFabricacion rename column idOrdeFabricacion to idOrdenFabricacion;
alter table horasOrdenFabricacion
    add constraint fk_idOrdenFabricacionHorasOrden foreign key (idOrdenFabricacion) references ordenFabricacion (idOrdenFabricacion);
alter table ordenFabricacion
    add column idUser int(5) not null;
alter table ordenFabricacion
    add constraint kf_idUserOrdenFabricacio foreign key (idUser) references usuario (iduser);
select *
from usuario;
select *
from maquinaria;
select *
from material;
select *
from ordenFabricacion;
alter table ordenFabricacion
    add constraint kf_idMaquinariaof foreign key (idMaquinaria) references maquinaria (idMaquinaria);
alter table ordenFabricacion
    add constraint kf_idMaterialof foreign key (idMaterial) references material (idMaterial);
select *
from ordenFabricacion;

select idOrdenFabricacion, m.nameMaquinaria, m2.nameMaterial, t.nameTurno
from ordenFabricacion
         inner join maquinaria m on ordenFabricacion.idMaquinaria = m.idMaquinaria
         inner join material m2 on ordenFabricacion.idMaterial = m2.idMaterial
         inner join turno t on ordenFabricacion.idTurno = t.idTurno;

select *
from ordenFabricacion;
alter table ordenFabricacion
    add column idTurno int(1) not null;
alter table ordenFabricacion
    modify column idTurno int(1) not null default 1;
alter table ordenFabricacion
    add constraint fk_idTurnoOrdenf foreign key (idTurno) references turno (idTurno);
alter table ordenFabricacion
    modify column idTurno int(1) not null;
alter table ordenFabricacion
    add column idStatus int(1) not null;
alter table ordenFabricacion
    add constraint fk_idStatusof foreign key (idstatus) references statusOF (idStatus);
alter table ordenFabricacion
    modify column idStatus int(1) not null default 1;
select *
from ordenFabricacion;
update ordenFabricacion
set idStatus=1;
select *
from turno;

#drop view datosof;
create view datosof as
select o.idOrdenFabricacion,
       date_format(o.create_at, "%d/%m/%Y") as Fecha,
       o.create_at as fechaCompleta,
       o.iduser,
       o.idTurno,
       o.idstatus,
       o.idMaterial,
       u.fullname,
       m.nameMaquinaria,
       m2.nameMaterial,
       t.nameTurno,
       sF.nameStatus
from ordenFabricacion o
         inner join maquinaria m on o.idMaquinaria = m.idMaquinaria
         inner join material m2 on o.idMaterial = m2.idMaterial
         inner join turno t on o.idTurno = t.idTurno
         inner join statusOF sF on o.idStatus = sF.idStatus
         inner join usuario u on o.idUser = u.iduser;
select *
from ordenFabricacion;


alter table horasParas rename column motivo to idtipoPara;
describe horasParas;
alter table horasParas
    add constraint fk_idtipoParahoraspara foreign key (idtipoPara) references horasParas (idHorasPara);
alter table horasParas rename column idOrdeFabricacion to idOrdenFabricacion;
alter table horasParas
    add column create_at timestamp default current_timestamp;
select *
from horasParas;
select *
from datosof;
drop view datosPara;
create view datosPara as
select hP.idHorasPara,
       hP.horaInicio,
       hP.horaFinal,
       TIMEDIFF(hP.horaFinal, hP.horaInicio) as TotalPara,
       hP.comentario,
       tP.nameTipoPara,
       hP.idOrdenFabricacion
from horasParas hP
         inner join tipoPara tP on hP.idtipoPara = tP.idTipoPara;



create view horasPara as
SELECT IF(
                   hP.horaInicio <= hP.horaFinal,
                   TIMEDIFF(hP.horaFinal, hP.horaInicio),
                   ADDTIME(TIMEDIFF('24:00:00', hP.horaInicio), hP.horaFinal)
           ) AS horasPara,
       idOrdenFabricacion
from horasParas hP;



create view horasOf as
SELECT IF(
                   hF.horaInicio <= hF.horaFinal,
                   TIMEDIFF(hF.horaFinal, hF.horaInicio),
                   ADDTIME(TIMEDIFF('24:00:00', hF.horaInicio), hF.horaFinal)
           ) AS horasOf,
       idOrdenFabricacion
from horasordenfabricacion hF;
select *
from horasOf;


select sec_to_time(sum(time_to_sec(horasOf))) as horasPara, idOrdenFabricacion
from horasOf
where idOrdenFabricacion = 1;



alter table operador
    add column idOrdenFabricación int(7) not null;
alter table operador rename column idOrdenFabricación to idOrdenFabricacion;
alter table operador
    add constraint fk_idOrdenFabricacion foreign key (idOrdenFabricacion) references ordenFabricacion (idOrdenFabricacion) on update cascade;


/*Query para sacar los datos de creacion de orden fabricacion*/
select o.idOrdenFabricacion, o.create_at, t.nameTurno, u.fullname as creador, m.nameMaquinaria, ma.nameMaterial
from ordenFabricacion o
         inner join turno t on o.idTurno = t.idTurno
         inner join usuario u on o.idUser = u.iduser
         inner join maquinaria m on o.idMaquinaria = m.idMaquinaria
         inner join material ma on ma.idMaterial = o.idMaterial;

select *
from operador;
alter table operador
    add column create_at timestamp default current_timestamp;
/*Query para sacar los datos de los operadores para la orden*/
select o.idOperador/*, o.idtipoOperador, o.idUsuario, o.idOrdenFabricacion,*/,
       o.create_at,
       u.fullname,
       tm.nameTipoMarca,
       t.nameTipoOperador
from operador o
         inner join usuario u on o.idUsuario = u.iduser
         inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador
         inner join tipoMarca tm on o.idTipoMarca = tm.idTipoMarca
where idOrdenFabricacion = 39;

create table tipoMarca
(
    idTipoMarca   int(2)      not null primary key auto_increment,
    nameTipoMarca varchar(50) not null

);
insert into tipoMarca(nameTipoMarca)
values ('Entrada'),
       ('Salida');

alter table operador
    add column idTipoMarca int(2) not null;
select *
from operador;
alter table operador
    add constraint fk_idTipoMarca foreign key (idTipoMarca) references tipoMarca (idTipoMarca);


select *
from operador
where idOrdenFabricacion = 39
  and idTipoMarca = 2/*and idTipoMarca=1*/;
select *
from operador
where idOrdenFabricacion = 39
  and idTipoMarca = 1/*and idTipoMarca=1*/;

select *
from operador
where idOrdenFabricacion = 39;

select *
from operador
where idtipoOperador != 1
  and idOrdenFabricacion = 39;
select *
from operador
where idOrdenFabricacion = 39;
select idOperador
from operador
where idOrdenFabricacion = 39
  and idTipoMarca = 2
  and 1;

select *, max(idTipoMarca)
from operador
where idOrdenFabricacion = 39
  and idUsuario = 10;

select idUsuario, idtipoOperador, max(idTipoMarca) as idTipoMarca, u.fullname
from operador
         inner join usuario u on operador.idUsuario = u.iduser
where idOrdenFabricacion = 39;

select *
from operador
where idOrdenFabricacion = 39;
select idUsuario, idOrdenFabricacion, max(idTipoOperador)
from operador
where idOrdenFabricacion = 39
  and idUsuario = 10;
select *
from operador;
select *
from operador
order by idtipoOperador;

select *, if(idTipoMarca = 2, "1", "0") as tipoMarca
from operador
where idOrdenFabricacion = 39;
drop view operadorTipoMarca;

create view operadorTipoMarca as
select *, if(idTipoMarca = 2, "2", "1") as tipoMarca
from operador;
select *
from operadorTipoMarca
where tipoMarca = 0
  and idOrdenFabricacion = 39;
select *
from usuario;
select *
from operador
where idOrdenFabricacion = 39;
select *
from operadorTipoMarca
where idTipoMarca = 2
  and tipoMarca != 1;
create view NOHanSalido as
select *
from operadorTipoMarca
where idTipoMarca = 1
  and tipoMarca = 0;

select *
from NOHanSalido
where idOrdenFabricacion = 39
group by idUsuario;

select *
from operador
where idOrdenFabricacion = 39;
select *
from operadorTipoMarca
where idOrdenFabricacion = 39;


select *
from operador
where idTipoMarca != 2
  and idOrdenFabricacion = 39;

select max(operador.idTipoMarca) as Esteban
from operador;

select idUsuario, idTipoMarca
from operador
where idTipoMarca = (select max(idTipoMarca) from operador)
  and idOrdenFabricacion = 39;


select idUsuario, idtipoOperador, idTipoMarca, u.fullname
from operador
         inner join usuario u on operador.idUsuario = u.iduser
where idTipoMarca = (select max(idTipoMarca) from operador)
  and idOrdenFabricacion = 39;


select *
from operador
where idOrdenFabricacion = 39;
select *
from operador
where idOrdenFabricacion = 39 and idTipoMarca = 1
   or idTipoMarca = 2;

select idUsuario, idTipoMarca
from operador
where (idOrdenFabricacion = 39 and idTipoMarca = 2)
  and idUsuario = 12;
select *
from operador
where idUsuario = 11;
select *
from operador
where idUsuario = 12
  and idOrdenFabricacion = 39;
select idUsuario, idTipoMarca
from operador
where idOrdenFabricacion = 39
group by idUsuario;
select idUsuario, idOrdenFabricacion, idTipoMarca
from operador
where idUsuario = 10
  and idOrdenFabricacion = 39;


select *
from operador
where idOrdenFabricacion = 39;

select idUsuario, idOrdenFabricacion, idTipoMarca, u.fullname
from operador
         inner join usuario u on operador.idUsuario = u.iduser
where idUsuario = ?
  and idOrdenFabricacion = 39;

SET GLOBAL FOREIGN_KEY_CHECKS = 0;
select *
from ordenFabricacion;
delete
from ordenFabricacion;
insert into operador
set `idOrdenFabricacion` = '44',
    `idUsuario`          = 12,
    `idtipoOperador`     = '2',
    `idTipoMarca`        = '1';
select *
from usuario;
select *
from tipoOperador;
describe tipoOperador;
describe operador;
insert into operador
set `idOrdenFabricacion` = '44',
    `idUsuario`          = 10,
    `idtipoOperador`     = '2',
    `idTipoMarca`        = '1';

select *
from operador
where idOrdenFabricacion = 44;
select *
from ordenFabricacion
where idOrdenFabricacion = 44;
select *
from datosof
where idOrdenFabricacion = 44;
select idtipoOperador, idUsuario, idTipoMarca
from operador
where idOrdenFabricacion = 44
  and idUsuario = 11
  and idTipoMarca = 1;


drop table operador;
delete
from ordenFabricacion
where idOrdenFabricacion = 47;
select *
from tipoOperador;
select *
from operador;
select *
from ordenFabricacion;


select *
from ordenFabricacion
where idOrdenFabricacion = 54;
select *
from operador
where idOrdenFabricacion = 57;
select idtipoOperador, idUsuario, idTipoMarca
from operador
where idOrdenFabricacion = 58
  and idUsuario = 12
ORDER BY idTipoMarca DESC
LIMIT 1;
SELECT *
FROM operador
WHERE idOrdenFabricacion = 58;

SELECT *
FROM usuario;
SELECT *
FROM ordenFabricacion
WHERE idOrdenFabricacion = 58;
SELECT *
FROM operador
WHERE idOrdenFabricacion = 58;

select *
from maquinaria;
select *
from material;


select *
from ordenFabricacion;


select idOrdenFabricacion,
       ordenFabricacion.iduser,
       ordenFabricacion.idTurno,
       ordenFabricacion.idstatus,
       ordenFabricacion.idMaterial,
       u.fullname,
       m.nameMaquinaria,
       m2.nameMaterial,
       t.nameTurno,
       sF.nameStatus
from ordenFabricacion
         inner join maquinaria m on ordenFabricacion.idMaquinaria = m.idMaquinaria
         inner join material m2 on ordenFabricacion.idMaterial = m2.idMaterial
         inner join turno t on ordenFabricacion.idTurno = t.idTurno
         inner join statusOF sF on ordenFabricacion.idStatus = sF.idStatus
         inner join usuario u on ordenFabricacion.idUser = u.iduser
         inner join operador o on ordenFabricacion.idOperador = o.idOperador
where idOrdenFabricacion = 59;



select *
from operador o
         inner join ordenFabricacion F on o.idOrdenFabricacion = F.idOrdenFabricacion
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material ma on F.idMaterial = ma.idMaterial
         inner join turno t on F.idTurno = t.idTurno
         inner join operador o2 on o.idOperador = o2.idOperador
         inner join horasParas hP on F.idOrdenFabricacion = hP.idOrdenFabricacion
         inner join usuario u on o2.idUsuario = u.iduser
         inner join tipooperador t2 on o.idtipoOperador = t2.idTipoOperador
where F.idOrdenFabricacion = 60;

select *
from operador;
select *
from ordenFabricacion;
select *
from maquinaria;

select *
from horasParas;

select *
from operador
where idOrdenFabricacion = 61
group by idUsuario;
select idUsuario, idtipoOperador, idTipoMarca, u.fullname, idOrdenFabricacion
from operador
         inner join usuario u on operador.idUsuario = u.iduser
where idOrdenFabricacion = 61
  and idTipoMarca = 1;



select *
from operador;
drop view dataOperadores;
create view dataOperadores as
select date_format(o.create_at, "%d/%m/%Y") as Fecha,
       o.create_at                            as FechaCompleta,
       F.idOrdenFabricacion                 as IdOrden,
       o.idUsuario                          as IDUsuario,
       u.fullname                           as NombreOperador,
       t.nameTipoOperador                   as TipoOperador,
       h.horaInicio                         as HoraIncioOrden,
       h.horaFinal                          as HoraFinalOrden,
       hO.horasOf                           as HorasTrabajadas,
       kM.kg                                as KgProcesados,
       t2.nameTurno                         as Turno,
       o.idtipoOperador                     as IdTipoOperador,
       m.nameMaquinaria                     as Maquinaria,
       m2.nameMaterial                      as Material
from operador o
         inner join usuario u on o.idUsuario = u.iduser
         inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador
         inner join horasordenfabricacion h on h.idOrdenFabricacion = o.idOrdenFabricacion
         inner join ordenFabricacion F on o.idOrdenFabricacion = f.idOrdenFabricacion
         inner join kgMaterial kM on F.idOrdenFabricacion = kM.idOrdenFabricacion
         inner join turno t2 on F.idTurno = t2.idTurno
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material m2 on F.idMaterial = m2.idMaterial
         inner join tipomarca tm on o.idTipoMarca = tm.idTipoMarca
         inner join horasOf hO on F.idOrdenFabricacion = hO.idOrdenFabricacion;
select date_format(create_at, "%d/%m/%Y")
from operador
where idOrdenFabricacion = 48;
select *
from operador;

select *
from dataOperadores
where IdOrden = 62
  and IdTipoOperador = 1
group by IDUsuario;
select *
from dataOperadores
where IdOrden = 62
  and IdTipoOperador = 2
group by IDUsuario;

select sec_to_time(sum(time_to_sec(horasPara))) as horasPara, idOrdenFabricacion
from horasPara
where idOrdenFabricacion = 62;
create view horasOf as
SELECT IF(
                   hF.horaInicio <= hF.horaFinal,
                   TIMEDIFF(hF.horaFinal, hF.horaInicio),
                   ADDTIME(TIMEDIFF('24:00:00', hF.horaInicio), hF.horaFinal)
           ) AS horasOf,
       idOrdenFabricacion
from horasordenfabricacion hF;
select *
from horasOf;



select *
from dataOperadores
where IdOrden = 62;


select sec_to_time(sum(time_to_sec(horasOf))) as horasOrdenT, idOrdenFabricacion
from horasOf
where idOrdenFabricacion = ?;

select *
from horasOf;

#drop view HorasOperadores;
create view HorasOperadores as
select u.iduser,
       o.idTipoMarca,
       u.fullname,
       t2.nameTurno,
       m.nameMaquinaria,
       m2.nameMaterial,
       tM.nameTipoMarca,
       t.nameTipoOperador,
       o.idOrdenFabricacion,
       date_format(o.create_at, "%H:%i:%s") as hora,
       o.idtipoOperador
from operador o
         inner join usuario u on o.idUsuario = u.iduser
         inner join tipoMarca tM on tM.idTipoMarca = o.idTipoMarca
         inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador
         inner join ordenFabricacion F on o.idOrdenFabricacion = F.idOrdenFabricacion
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material m2 on F.idMaterial = m2.idMaterial
         inner join turno t2 on F.idTurno = t2.idTurno;


select *
from HorasOperadores;
select *
from operador
where idTipoMarca = 1
  and idOrdenFabricacion = 62;
select *
from operador
where idTipoMarca = 2
  and idOrdenFabricacion = 62;

select date_format(create_at, "%H:%i")
from operador;
select create_at
from operador;


select *
from HorasOperadores
where idOrdenFabricacion = 65;
select *
from HorasOperadores
where idTipoMarca = 2
  and idOrdenFabricacion = 62;


#drop view HorasOperadoresEntrada;
select *
from HorasOperadores;
create view HorasOperadoresEntrada as
select iduser,
       idTipoMarca,
       nameTurno,
       nameMaterial,
       nameMaquinaria,
       nameTipoOperador,
       fullname,
       nameTipoMarca,
       idtipoOperador,
       idOrdenFabricacion,
       hora as HoraEntrada
from HorasOperadores
where idTipoMarca = 1;
select *
from HorasOperadores;

select *
from HorasOperadoresEntrada
where idOrdenFabricacion = 62;

#drop view HorasOperadoresSalida;
create view HorasOperadoresSalida as
select iduser,
       idTipoMarca,
       nameMaterial,
       nameTurno,
       nameMaquinaria,
       nameTipoOperador,
       idtipoOperador,
       fullname,
       nameTipoMarca,
       idOrdenFabricacion,
       hora as HoraSalida
from HorasOperadores
where idTipoMarca = 2;
select *
from HorasOperadoresSalida
where idOrdenFabricacion = 62;
drop view horapre;
create view horapre as;
select o.idOrdenFabricacion, HOE.HoraEntrada, HOS.HoraSalida
from operador o
         inner join HorasOperadoresEntrada HOE on HOE.idOrdenFabricacion = o.idOrdenFabricacion
         inner join HorasOperadoresSalida HOS on HOE.idOrdenFabricacion = HOS.idOrdenFabricacion;
select *
from horapre
where idOrdenFabricacion = 61;

#create view TotalHorasOperadores as
select *
from HorasOperadoresEntrada
where idOrdenFabricacion = 62;
select *
from HorasOperadoresSalida
where idOrdenFabricacion = 62;



drop view horasss;
create view horasss as
select HoraSalida, HoraEntrada, HOS.idOrdenFabricacion, HOS.iduser
from HorasOperadoresEntrada
         inner join HorasOperadoresSalida HOS on HorasOperadoresEntrada.idOrdenFabricacion = HOS.idOrdenFabricacion;

select *
from horasss
where idOrdenFabricacion = 62;
select distinctrow *
from horasss
where idOrdenFabricacion = 61;



SELECT IF(
                   THO.HoraEntrada <= THO.HoraSalida,
                   TIMEDIFF(THO.HoraSalida, THO.HoraEntrada),
                   ADDTIME(TIMEDIFF('24:00:00', THO.HoraEntrada), THO.HoraSalida)
           ) AS horasOf,
       idOrdenFabricacion,
       iduser
from TotalHorasOperadores THO
where THO.idOrdenFabricacion = 62;
select *
from horasOf;
select *
from dataOperadores
where IdOrden = 62;
select *
from operador;
select *
from dataOperadores
order by IdOrden;

select *
from operador;

select F.idOrdenFabricacion as IdOrden,
       o.idUsuario          as IDUsuario,
       u.fullname           as NombreOperador,
       t.nameTipoOperador   as TipoOperador,
       h.horaInicio         as HoraIncioOrden,
       h.horaFinal          as HoraFinalOrden,
       hO.horasOf           as HorasTrabajadas,
       kM.kg                as KgProcesados,
       t2.nameTurno         as Turno,
       o.idtipoOperador     as IdTipoOperador,
       m.nameMaquinaria     as Maquinaria,
       m2.nameMaterial      as Material,
       o.create_at          as HoraMarcacion

from operador o
         inner join usuario u on o.idUsuario = u.iduser
         inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador
         inner join horasordenfabricacion h on h.idOrdenFabricacion = o.idOrdenFabricacion
         inner join ordenFabricacion F on o.idOrdenFabricacion = f.idOrdenFabricacion
         inner join kgMaterial kM on F.idOrdenFabricacion = kM.idOrdenFabricacion
         inner join turno t2 on F.idTurno = t2.idTurno
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material m2 on F.idMaterial = m2.idMaterial
         inner join horasOf hO on F.idOrdenFabricacion = hO.idOrdenFabricacion
         inner join horasPara h2 on F.idOrdenFabricacion = h2.idOrdenFabricacion;



select F.idOrdenFabricacion,
       u.fullname,
       h.horaInicio,
       h.horaFinal,
       hO.horasOf,
       kM.kg,
       t2.nameTurno,
       m.nameMaquinaria,
       m2.nameMaterial,
       o.idtipoOperador
from operador o
         inner join usuario u on o.idUsuario = u.iduser
         inner join horasordenfabricacion h on h.idOrdenFabricacion = o.idOrdenFabricacion
         inner join ordenFabricacion F on o.idOrdenFabricacion = f.idOrdenFabricacion
         inner join kgMaterial kM on F.idOrdenFabricacion = kM.idOrdenFabricacion
         inner join turno t2 on F.idTurno = t2.idTurno
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material m2 on F.idMaterial = m2.idMaterial
         inner join horasOf hO on F.idOrdenFabricacion = hO.idOrdenFabricacion
         inner join horasPara h2 on F.idOrdenFabricacion = h2.idOrdenFabricacion;

select *
from dataOperadores
where IdOrden = 62
  and IdTipoOperador = 1
group by IDUsuario;

use bddnova;
drop view operadoresData;
create view operadoresData as;
select operador.idUsuario,
       operador.idOrdenFabricacion,
       operador.idtipoOperador,
       nameTipoOperador,
       operador.idTipoMarca,
       u.fullname,
       hoe.HoraEntrada,
       hos.HoraSalida
from operador
         inner join usuario u on operador.idUsuario = u.iduser
         inner join tipoOperador t on operador.idtipoOperador = t.idTipoOperador


select *
from operadoresData
where idOrdenFabricacion = 61;



select *
from horasordenfabricacion
where idOrdenFabricacion = 62;
select *
from HorasOperadoresEntrada
where idOrdenFabricacion = 65;
select *
from HorasOperadoresSalida
where idOrdenFabricacion = 65;
drop view operadores;

#drop view operadores;
create view operadores as
select HOE.iduser,
       HOE.idOrdenFabricacion,
       HOE.nameMaterial,
       HOE.nameTurno,
       HOE.nameMaquinaria,
       HOE.idtipoOperador,
       HOE.fullname,
       HOE.HoraEntrada,
       HOS.HoraSalida,
       HOE.nameTipoOperador
from HorasOperadoresEntrada HOE
         inner join HorasOperadoresSalida HOS on HOE.idOrdenFabricacion = HOS.idOrdenFabricacion;

select *
from HorasOperadores
where idOrdenFabricacion = 59;
select *
from HorasOperadoresEntrada
where idOrdenFabricacion = 66
order by idtipoOperador;


select *
from operador
where idOrdenFabricacion = 67;
select *
from HorasOperadoresEntrada
where idOrdenFabricacion = 67
order by idtipoOperador;
select *
from HorasOperadoresSalida
where idOrdenFabricacion = 67
order by idtipoOperador;


select *
from (select * from operadores where idOrdenFabricacion = 67) as esto
group by iduser, HoraSalida, HoraEntrada;


select distinct *
from operadores
where idOrdenFabricacion = 67
  and idtipoOperador = 2
group by iduser;
select distinct *
from operadores
where idOrdenFabricacion = 67
  and idtipoOperador = 2
group by HoraSalida;
drop view previs;

#drop view previs;
create view previs as
SELECT HoraEntrada,
       HoraSalida,
       HorasOperadoresSalida.idOrdenFabricacion,
       HorasOperadoresSalida.idTipoMarca,
       HorasOperadoresSalida.iduser,
       HorasOperadoresSalida.idtipoOperador
FROM HorasOperadoresSalida,
     HorasOperadoresEntrada
WHERE HorasOperadoresEntrada.idOrdenFabricacion = HorasOperadoresSalida.idOrdenFabricacion;

select *
from HorasOperadoresEntrada
where iduser = 12
  and idOrdenFabricacion = 67;
select *
from HorasOperadoresSalida
where iduser = 12
  and idOrdenFabricacion = 67;
select *
from HorasOperadores
where iduser = 10
  and idOrdenFabricacion = 67
order by idTipoMarca;
select *
from HorasOperadores;


select *
from previs
where idOrdenFabricacion = 67
  and idtipoOperador = 2
group by iduser;

select *
from where HOS.idOrdenFabricacion=62 and HOS.idtipoOperador=2
group by HOE.iduser
drop view previs;
create view previs as;
select HOE.iduser, HOE.HoraEntrada, H.HoraSalida
from HorasOperadoresEntrada HOE
         inner join HorasOperadoresSalida H on HOE.iduser = H.iduser
where HOE.idOrdenFabricacion in
      (select h2.idOrdenFabricacion from HorasOperadoresSalida h2 where HOE.idOrdenFabricacion = 67)
group by H.fullname;

select *
from operador;
select *
from HorasOperadores;
#Query que si vale
drop view dataOperadoresHoras;
create view dataOperadoresHoras as
select distinct HOE.idOrdenFabricacion as IdOrden,
                HOE.fullname           as NombreOperador,
                HOE.nameTipoOperador   as TipoOperador,
                HOE.HoraEntrada        as HoraEntrada,
                HOS.HoraSalida         as HoraSalida,
                HOE.nameTurno          as Turno,
                HOE.nameMaquinaria     as Maquinaria,
                HOE.nameMaterial       as Material
from HorasOperadoresEntrada HOE,
     HorasOperadoresSalida HOS
where HOE.iduser = HOS.iduser
  and HOE.idOrdenFabricacion = HOS.idOrdenFabricacion
  and HOE.idtipoOperador = 2;

select *, time_format(TIMEDIFF(HoraSalida, HoraEntrada), '%H:%i') as TiempoTrabajado
from dataOperadoresHoras
where IdOrden = 70;

select *
from HorasOperadoresEntrada
where idOrdenFabricacion = 67;
select *
from HorasOperadoresSalida
where idOrdenFabricacion = 67;

select distinct *
from previs
where idOrdenFabricacion = 67
group by iduser;
select *
from operador;
SELECT TIME_FORMAT(ADDTIME(HoraSalida, -HoraEntrada), '%H:%i') AS new_time
FROM dataOperadoresHoras
where IdOrden = 67;

SELECT TIMEDIFF(HoraEntrada, HoraSalida) as TiempoTrabajado,
       IdOrden,
       NombreOperador,
       TipoOperador,
       HoraEntrada,
       HoraSalida,
       Turno,
       Maquinaria,
       Material
from dataOperadoresHoras
where IdOrden = 67;


se

select *
from dataOperadoresHoras
where IdOrden = 70;


select hp.idHorasPara,
       hp.idOrdenFabricacion,
       hp.horaInicio,
       hp.horaFinal,
       TIMEDIFF(hp.horaFinal, hp.horaInicio) as TotalPara,
       tP.nameTipoPara,
       hp.comentario
from horasParas hp
         inner join tipoPara tP on hp.idtipoPara = tP.idTipoPara
where idOrdenFabricacion = 68;


select *
from datosPara;

select *
from horasParas;

select *
from rolusuario;

select u.iduser, u.fullname, r.nameRol, r.idRol
from usuario u
         inner join rolusuario r on u.rolusuario = r.idRol;


select *
from datosof
where iduser = 10
  and idStatus = 1
  and idOrdenFabricacion = 74;
select *
from datosof
where idOrdenFabricacion = 74;

select *
from rolusuario;
select *
from dataOperadores
where IdOrden = 54
  and IdTipoOperador = 1
group by IDUsuario;
select *
from dataOperadores;

select *
from horasParas
where idOrdenFabricacion = 73;
select *
from datosof
where idstatus = 1;



select count(distinct idOrdenFabricacion)
from datosof
where idstatus = 1;
select count(distinct idOrdenFabricacion)
from datosof
where iduser = ?
  and idStatus = 2;
select count(distinct idOrdenFabricacion) as NrOrdenA
from datosof
where idstatus = 1;
select count(distinct idOrdenFabricacion) as NrOrdenAs
from datosof
where iduser = 10
  and idStatus = 1;
select *
from ordenFabricacion;
select *
from operador o
         inner join ordenFabricacion on o.idOrdenFabricacion = ordenFabricacion.idOrdenFabricacion;
select *
from operador;


select *
from dataOperadores;

select *
from datosof
where iduser = 10
  and idstatus = 2;
select *
from dataOperadores
where IDUsuario = 10
group by idOrden;
select *
from dataOperadores
where IDUsuario = 10 and TipoOperador = "Ayudante"
   or TipoOperador = "Principal";
select count(idOrden)
from dataOperadores
where IDUsuario = 10
group by idOrden;
select count(idOrden) as contador
from dataOperadores
where IDUsuario = 10
group by IdOrden;
select count(distinct (IdOrden)) as constador
from dataOperadores
where IDUsuario = 10;
select *
from dataoperadores;
select *
from dataOperadores;
select count(distinct (IdOrden)) as NrOrdenCe
from dataoperadores
where IDUsuario = 10;
select *
from ordenFabricacion
where idUser = 10
  and idstatus = 1;
select *
from ordenFabricacion
where idUser = 10;


select *
from ordenFabricacion
where idUser = 10;
select *
from datosof
where iduser = 10
  and idStatus = 1;
SELECT *
FROM datosof;
SELECT *
FROM ordenFabricacion;
SELECT *
FROM dataOperadoresHoras
group by IdOrden;
select *
from operadores
where iduser = 10;
select *
from operadorTipoMarca
where idUsuario = 10;
select *
from operadores;
select *
from tipooperador;



select *
from operador
where idUsuario = 10 and idTipoMarca = 1
   or idTipoMarca = 2;
drop view previs;
select fullname, nameMaterial, nameTurno, o.idtipoOperador, datosof.idOrdenFabricacion
from datosof
         inner join operador o on datosof.idOrdenFabricacion = o.idOrdenFabricacion;
select *
from previs
where idOrdenFabricacion = 49;
select *
from HorasOperadores
where iduser = 10
  and idOrdenFabricacion = 63;
select *
from dataOperadoresHoras
where IdOrden = 63;
select *
from HorasOperadoresEntrada
where iduser = 10;
select *
from HorasOperadoresSalida
where iduser = 10;
select *
from HorasOperadores;
select *
from HorasOperadores
         inner join ordenFabricacion o on HorasOperadores.idOrdenFabricacion = o.idOrdenFabricacion;
select *
from horasss
where iduser = 10
  and idOrdenFabricacion = 63;

select *
from dataOperadoresHoras;
select *
from horasss;

drop view previs;
create view previs as
select HO.*, o.idstatus
from HorasOperadoresEntrada HO
         inner join ordenFabricacion o on HO.idOrdenFabricacion = o.idOrdenFabricacion;


select *
from operador;
select *
from dataOperadoresHoras;
select *
from datosof;


select count(idOrdenFabricacion)
from previs
where iduser = 11
  and idstatus = 1;
select *
from previs
where iduser = 10
  and idstatus = 1;
select *
from previs
where iduser = 11
  and idstatus = 1
group by idOrdenFabricacion;
select *
from ordenFabricacion;
select *
from datosof;
select *
from dataOperadores;
select *
from dataOperadores
where IdOrden = 55
group by IDUsuario;
select *
from dataOperadores;



select DATE_FORMAT(fecha, "%e/%m/%y") as Fecha,
       idorden,
       idusuario,
       nombreoperador,
       tipooperador,
       horaincioorden,
       horafinalorden,
       horastrabajadas,
       kgprocesados,
       turno,
       idtipooperador,
       maquinaria,
       material
from dataOperadores do;

select *, DATE_FORMAT(dO.Fecha, "%e/%m/%y") as Hoy, DATE_FORMAT(curdate() - 1, "%e/%m/%y") as Ayer
from dataOperadores dO;


select *
from dataOperadores;
select *
from datosof;



select *
from dataOperadores
where Fecha between DATE_FORMAT(NOW(), "%e/%m/%y") and DATE_FORMAT(curdate() - 1, "%e/%m/%y");
SELECT DATE_FORMAT(NOW(), "%e/%m/%y") AS fecha;
SELECT DATE_FORMAT(curdate() - 1, "%e/%m/%y") AS fecha;

select *
from dataOperadores
where Fecha = curdate() - 1;
select sysdate(fechaCompleta) as Fecha from datosof;

select FechaCompleta from dataOperadores;
select Fecha from dataOperadores;
select date(NOW());
select * from dataOperadores where FechaCompleta=date(NOW());

select * from previs;
drop view dataAsignadas;
create view dataAsignadas as
select ho.iduser             AS iduser,
       ho.idTipoMarca        AS idTipoMarca,
       ho.nameTurno          AS nameTurno,
       ho.nameMaterial       AS nameMaterial,
       ho.nameMaquinaria     AS nameMaquinaria,
       ho.nameTipoOperador   AS nameTipoOperador,
       ho.fullname           AS fullname,
       ho.nameTipoMarca      AS nameTipoMarca,
       ho.idtipoOperador     AS idtipoOperador,
       ho.idOrdenFabricacion AS idOrdenFabricacion,
       ho.HoraEntrada        AS HoraEntrada,
       o.idStatus                     AS idstatus,
       sF.nameStatus

from (`bddnova`.`horasoperadoresentrada` `ho` join `bddnova`.`ordenfabricacion` `o`
      on ((ho.idOrdenFabricacion = o.idOrdenFabricacion)))
inner join statusof sF on o.idstatus=sF.idStatus ;
select * from statusof;

 SELECT @@global.time_zone;
SELECT @@global.time_zone, @@session.time_zone;
select * from usuario;

select * from dataAsignadas where iduser=10 and idstatus=1;

select * from dataOperadores;
select * from HorasOperadoresEntrada where idOrdenFabricacion=57;
select * from HorasOperadoresSalida where idOrdenFabricacion=57;
select * from dataOperadores where IdOrden=57 and IdTipoOperador=2 group by IDUsuario;




select *,
       TIME_FORMAT(TIMEDIFF(HoraSalida, HoraEntrada), "%H:%i") as TiempoTrabajado
from dataOperadoresHoras where IdOrden=77;



SELECT IF(
         dOH.HoraEntrada <= dOH.HoraSalida,
         TIMEDIFF(dOH.HoraSalida, dOH.HoraEntrada),
         ADDTIME(TIMEDIFF('24:00:00', dOH.HoraEntrada), dOH.HoraSalida)
        ) AS TiempoTrabajado,
       dOH.*
from dataOperadoresHoras dOH where IdOrden=77;
/*
 10,alex.barros@novared.com.ec
11,usuario@gmail.com
12,usuario2@gmail.com

 11:09:01	11:10:27	00:01:26
 */

select * from dataOperadoresHoras;
select * from HorasOperadores;
select * from operador;
select * from operador where idOrdenFabricacion=77 and idUsuario=10 and idTipoMarca=1;
update operador set create_at="2023-04-17 23:09:01" where idOrdenFabricacion=77 and idUsuario=10 and idTipoMarca=1;
update operador set create_at="2023-04-17 03:09:01" where idOrdenFabricacion=77 and idUsuario=10 and idTipoMarca=2;
update operador set create_at="" where idOrdenFabricacion=77;
SELECT IF(dOH.HoraEntrada <= dOH.HoraSalida, TIMEDIFF(dOH.HoraSalida, dOH.HoraEntrada), ADDTIME(TIMEDIFF('24:00:00', dOH.HoraEntrada), dOH.HoraSalida)) AS TiempoTrabajado, dOH.* from dataOperadoresHoras dOH where IdOrden=77;
SELECT IF(dOH.HoraEntrada <= dOH.HoraSalida, TIME_FORMAT(TIMEDIFF(dOH.HoraSalida, dOH.HoraEntrada), "%H:%i:%s" ), ADDTIME(time_format(TIMEDIFF('24:00:00', dOH.HoraEntrada), dOH.HoraSalida), '"%H:%i:%s"')) AS TiempoTrabajado, dOH.* from dataOperadoresHoras dOH where IdOrden=77;
SELECT IF(dOH.HoraEntrada <= dOH.HoraSalida, TIME_FORMAT(TIMEDIFF(dOH.HoraSalida, dOH.HoraEntrada), "%H:%i:%s" ), ADDTIME(TIMEDIFF('24:00:00', dOH.HoraEntrada), dOH.HoraSalida)) AS TiempoTrabajado , dOH.* from dataOperadoresHoras dOH where IdOrden=77;
SELECT IF(dOH.HoraEntrada <= dOH.HoraSalida, TIME_FORMAT(TIMEDIFF(dOH.HoraSalida, dOH.HoraEntrada), '%H:%i:%s'), TIME_FORMAT(ADDTIME(TIMEDIFF('24:00:00', dOH.HoraEntrada), dOH.HoraSalida), '%H:%i:%s')) AS TiempoTrabajado, dOH.* FROM dataOperadoresHoras dOH WHERE IdOrden = 77;

11:07:30 - 05:00:00 = 06:07:30
11:11:18 - 05:00:00 = 06:11:18

SELECT IF(dOH.HoraEntrada <= dOH.HoraSalida, TIME_FORMAT(TIMEDIFF(dOH.HoraSalida, dOH.HoraEntrada), '%H:%i:%s'), TIME_FORMAT(ADDTIME(TIMEDIFF('24:00:00', dOH.HoraEntrada), dOH.HoraSalida), '%H:%i:%s')) AS TiempoTrabajado, time_format(dOH.HoraEntrada, '%H:%i:%s') as HoraEntradaF, TIME_FORMAT(dOH.HoraSalida ,'%H:%i:%s' )as HoraSalidaF, dOH.* FROM dataOperadoresHoras dOH WHERE IdOrden = 77;



