use bddnova;

create table usuario
(
    iduser      int(6)      not null primary key auto_increment,
    username    varchar(50) not null,
    password    varchar(60) not null,
    fullname    varchar(50) not null,
    sobreMi     varchar(200),
    empresa     varchar(50) not null default 'Novared',
    pais        varchar(50),
    direccion   varchar(100),
    telefono    int(10),
    igLink      varchar(30),
    twitterLink varchar(30),
    inkedInLink varchar(30),
    rolusuario  int(4)
);

alter table usuario
    modify column rolusuario int(4) not null default 3;

alter table usuario
    modify column telefono varchar(15);
alter table usuario
    modify column igLink varchar(100);
alter table usuario
    modify column twitterLink varchar(100);
alter table usuario
    modify column inkedInLink varchar(100);

create table rolUsuario
(
    idRol   int(4) not null primary key auto_increment,
    nameRol varchar(50)
);

alter table rolUsuario
    auto_increment = 1;



create table ordenTrabajo
(
    idOrdenTrabajo int(7)        not null primary key auto_increment,
    descripcion    varchar(1000) not null,
    create_at      timestamp default current_timestamp,
    estadoMaquina  int(4)        not null,
    idUsuario      int(6)        not null,
    idPrioridad    int(3)        not null,
    idArea         int(3)        not null,
    idMaquina      int(3)        not null,
    idStatus       int(3)        not null
);


alter table ordenTrabajo
    auto_increment = 1;


create table prioridad
(
    idPrioridad   int(3)      not null auto_increment primary key,
    namePrioridad varchar(50) not null
);

alter table prioridad
    auto_increment = 1;

create table area
(
    idArea   int(3)      not null primary key auto_increment,
    nameArea varchar(50) not null
);

alter table area
    auto_increment = 1;

create table maquina
(
    idMaquina   int(3)      not null primary key auto_increment,
    nameMaquina varchar(30) not null,
    idArea      int(3)      not null
);



alter table maquina
    auto_increment = 1;



create table estadoMaquina
(
    idEstadoMaquina int(3)      not null primary key auto_increment,
    nameEstado      varchar(50) not null
);

alter table estadoMaquina
    auto_increment = 1;



create table tecnico
(
    idTecnico      int(6) not null auto_increment primary key,
    idUser         int(6) not null,
    idEspecialidad int(6) not null
);

alter table tecnico
    auto_increment = 1;


create table especialidadtecnico
(
    idEspecialidad   int(3)      not null primary key auto_increment,
    nameEspecialidad varchar(30) not null

);

alter table especialidadtecnico
    auto_increment = 1;

create table orden_Trabajador
(
    idOrdenTrabajador int(7) not null primary key auto_increment,
    idOrden           int(7) not null,
    idTecnico         int(6) not null,
    create_at         timestamp default current_timestamp
);

alter table orden_Trabajador
    auto_increment = 1;

create table orden_Producto
(
    idOrdenProducto int(7) not null auto_increment primary key,
    idOrden         int(7) not null,
    idProducto      int(7) not null,
    create_at       timestamp default current_timestamp
);
alter table orden_Producto
    auto_increment = 1;


create table orden_Status
(
    idOrdenStatus       int(7) not null auto_increment primary key,
    idStatus            int(3) not null,
    idOrden             int(7) not null,
    idTipoMantenimiento int(3) not null,
    create_at           timestamp default current_timestamp

);


alter table orden_Status
    auto_increment = 1;


create table tipoMantenimiento
(
    idTipoMantenimiento   int(3)      not null auto_increment primary key,
    nameTipoMantenimiento varchar(50) not null
);

create table status
(
    idStatus     int(3)      not null auto_increment primary key,
    nameStatus   varchar(50) not null,
    avanceStatus int(2)      not null
);

create table maquina_Area
(
    idMaquinaArea int(3) primary key auto_increment not null,
    idArea        int(3)                            not null,
    idMaquina     int(3)                            not null
);

alter table maquina_Area
    auto_increment = 1;


create table producto
(
    idProducto       int(6)      not null primary key auto_increment,
    nameProducto     varchar(50) not null,
    cantidadProducto int(6)      not null,
    datosAdicionales varchar(200)
);

alter table producto
    auto_increment = 1;

/*
DROP TABLE area;
DROP TABLE especialidadtecnico;
DROP TABLE estadoMaquina;
DROP TABLE maquina;
DROP TABLE orden_Producto;
DROP TABLE orden_status;
DROP TABLE orden_Trabajador;
DROP TABLE ordentrabajo;
DROP TABLE prioridad;
DROP TABLE rolusuario;
DROP TABLE status;
drop table tecnicos;
drop table tipomantenimiento;

*/

show tables;


alter table usuario
    add constraint fk_RolUsuario foreign key (rolusuario) references rolusuario (idRol);

alter table ordentrabajo
    add constraint fk_idUsuario foreign key (idUsuario) references usuario (iduser);

alter table ordentrabajo
    add constraint fk_idPrioridad foreign key (idPrioridad) references prioridad (idPrioridad);

alter table ordentrabajo
    add constraint fk_estadoMaquina foreign key (estadoMaquina) references estadoMaquina (idEstadoMaquina);

alter table ordenTrabajo
    add constraint fk_idstatusOT foreign key (idStatus) references status (idStatus);

alter table ordenTrabajo
    add constraint fk_idMaquina foreign key (idMaquina) references maquina (idMaquina);

alter table ordenTrabajo
    add constraint fk_idArea foreign key (idArea) references area (idArea);

alter table orden_status
    add constraint fk_idOrden foreign key (idOrden) references ordentrabajo (idOrdenTrabajo) on delete cascade;



alter table orden_status
    add constraint fk_idTipoMantenimiento foreign key (idTipoMantenimiento) references tipomantenimiento (idTipoMantenimiento);

alter table orden_Status
    add constraint fk_idStatusOs foreign key (idStatus) references status (idStatus);

alter table orden_producto
    add constraint fk_idProducto foreign key (idProducto) references producto (idProducto);

alter table orden_producto
    add constraint fk_id_Orden foreign key (idOrden) references ordenTrabajo (idOrdenTrabajo);

alter table orden_Trabajador
    add constraint fk_idOrdenT foreign key (idOrden) references ordenTrabajo (idOrdenTrabajo) on delete cascade;


alter table orden_Trabajador
    add constraint fk_idTecnico foreign key (idTecnico) references tecnico (idTecnico) on update cascade;

alter table tecnico
    add constraint fk_idUserT foreign key (idUser) references usuario (iduser);

alter table tecnico
    add constraint fk_idespecialidad foreign key (idEspecialidad) references especialidadtecnico (idEspecialidad);

show tables;


select *
from usuario;

select *
from rolusuario;

insert into rolusuario(nameRol)
values ('Administrador'),
       ('Lider Mantenimiento'),
       ('Usuario'),
       ('Tecnico');


update usuario
set rolusuario=2
where iduser = 2;
update usuario
set rolusuario=4
where iduser = 1;


select fullname, r.nameRol
from usuario
         join bddnova.rolusuario r on usuario.rolusuario = r.idRol
where idRol = 2;

select *
from status;

insert into status(nameStatus, avanceStatus)
VALUES ('Abierta', 20),
       ('Aprobada', 40),
       ('Atendida', 60),
       ('En Progreso', 70),
       ('Espera Revisión', 90),
       ('Terminada', 100);


select *
from status;


select *
from area;

insert into area(nameArea)
values ('Edificio'),
       ('Equipos Auxiliares'),
       ('Maquinas'),
       ('PTAR'),
       ('Garita'),
       ('Molinos'),
       ('Subestación'),
       ('Montacargas'),
       ('Compactadora');



insert into maquina(nameMaquina, idArea)
values ('Administrativo', 1),
       ('Financiero', 1),
       ('Producción', 1),
       ('Logistica/BodegaPT', 1),
       ('Compactadora', 9),
       ('Compresor JAGUAR I', 2),
       ('Compresor JAGUAR II', 2),
       ('Pelletizadora 1', 3),
       ('Pelletizadora 2', 3),
       ('Pelletizadora 3', 3),
       ('Lavado Film', 3),
       ('PET', 3),
       ('Lavado Hogar', 3),
       ('Lavado Zuncho', 3),
       ('Clasificadora de colores', 3),
       ('PTAR', 4),
       ('Garita', 5),
       ('Puerta Garita', 5),
       ('Zuncho', 6),
       ('Hogar', 6),
       ('Film', 6),
       ('PET', 6),
       ('Trituradora', 6),
       ('Transformador Inatra 250 KVA', 7),
       ('Transformador Inatra 750 KVA', 7),
       ('Montacargas 1 - 2.5T', 8),
       ('Montacargas 2 - 2.5T', 8),
       ('Montacargas 3 - 3T', 8),
       ('Montacargas 4 - 3T', 8);



insert into especialidadtecnico(nameEspecialidad)
values ('Electricista'),
       ('Soldador'),
       ('Jefe'),
       ('Ayudante');



insert into prioridad(namePrioridad)
values ('Baja'),
       ('Media'),
       ('Alta');



insert into estadoMaquina(nameEstado)
values ('Operativa'),
       ('Parada');


select *
from usuario;

select *
from area;
select *
from maquina;


insert into tipomantenimiento(nameTipoMantenimiento)
values ('Preventivo'),
       ('Correctivo'),
       ('Mejora');



alter table orden_Status
    add column idUsuario int(6) not null;

alter table orden_Status
    add constraint fk_idUsuarioStatus foreign key (idUsuario) references usuario (iduser);

/*++++++++++++++++++++++++*/
alter table orden_status
    add column fechaInicio timestamp default current_timestamp;


alter table orden_status
    add column fechaFinal timestamp default current_timestamp;

alter table orden_status
    add column comentariosLider varchar(500) not null default "No comentarios";

alter table orden_Status
    add column comentariosTecnico varchar(500) not null default "Los comentarios se activan al momento de que la orden pasa a Revisión por el Lider Mantenimiento o PLanificador respectivamente";
select *
from orden_status;
select *
from status;



insert into tipoMantenimiento(nametipomantenimiento)
values ('Externo');


alter table orden_status
    add column idProveedor int(5) default 1;

alter table orden_status
    add constraint fk_idProveedor foreign key (idProveedor) references proveedor (idProveedor);


create table proveedor
(
    idProveedor   int(5) not null primary key auto_increment,
    nameProveedor varchar(50)
);

insert into proveedor(nameProveedor)
values ('Novared');


create table proveedor_orden
(
    idProveedor_Orden  int(100)     not null primary key auto_increment,
    idOrdenTrabajo     int(7)       not null,
    idProveedor        int(5)       not null,
    fechaInicioTrabajo timestamp,
    fechaFinalTrabajo  timestamp,
    descripcionTrabajo text(100000) not null
);



alter table proveedor_orden
    add constraint fk_idProveedorOrden foreign key (idOrdenTrabajo) references ordenTrabajo (idOrdenTrabajo) on delete cascade;


alter table proveedor_orden
    add constraint fk_OrdenProveedor foreign key (idProveedor) references proveedor (idProveedor);

alter table proveedor_orden
    add column id_tipoMantenimiento int(5) not null;


alter table proveedor_orden
    add constraint fk_proveedorOrdenTipoM foreign key (id_tipoMantenimiento) references tipoMantenimiento (idTipoMantenimiento) on update cascade;

create table fechas_orden
(
    idFechasOrden int(10) auto_increment primary key not null,
    fechaInicio   datetime,
    fechaFinal    datetime,
    create_at     timestamp default current_timestamp,
    idUser        int(10),
    idOrden       int(10)
);



alter table fechas_orden
    add constraint fk_idUser foreign key (idUser) references usuario (iduser) on update cascade;

alter table fechas_orden
    add constraint fk_idOrdenFecha foreign key (idOrden) references ordenTrabajo (idOrdenTrabajo) on update cascade;



create table comentarios_orden
(
    idComentarios_OrdenT int(10) auto_increment primary key,
    create_at            timestamp default current_timestamp,
    comentario           varchar(1000) not null,
    idOrden              int(10),
    idUser               int(10)
);

SET GLOBAL FOREIGN_KEY_CHECKS = 0;

alter table comentarios_orden
    drop constraint fk_UserComentarios;

alter table comentarios_orden
    add constraint fk_idComentarios foreign key (idOrden) references ordenTrabajo (idOrdenTrabajo) on delete cascade;

alter table comentarios_orden
    add constraint fk_UserComentarios foreign key (idUser) references usuario (iduser) ON UPDATE CASCADE;

alter table comentarios_orden
    add column idStatus int(100) not null;
alter table comentarios_orden
    add constraint fk_status_orden foreign key (idStatus) references status (idStatus) on delete cascade;


alter table orden_Status
    drop fechaFinal;
alter table orden_Status
    drop fechaInicio;
alter table orden_Status
    drop comentariosTecnico;
alter table orden_Status
    drop comentariosLider;

select *
from orden_Status;


describe orden_Status;


create table orden_tipomantenimiento
(
    idOrdeTipoMantenimiento int(10) primary key auto_increment,
    idOrden                 int(10),
    idTipoMantenimiento     int(10)
);


alter table orden_tipomantenimiento
    add constraint fk_orden_tipomantenimeinto foreign key (idOrden) references ordentrabajo (idOrdenTrabajo) ON UPDATE CASCADE;

alter table orden_tipomantenimiento
    add constraint fk_tipoidTipo foreign key (idTipoMantenimiento) references tipoMantenimiento (idTipoMantenimiento) ON UPDATE CASCADE;


alter table orden_Status
    drop constraint fk_idTipoMantenimiento;
alter table orden_Status
    drop idTipoMantenimiento;

describe orden_Status;

/*--------------------Vistas------------------------*/

create view TodosDatos as
SELECT ordenTrabajo.idOrdenTrabajo
     , a.nameArea
     , m.nameMaquina
     , ordenTrabajo.descripcion
     , ordenTrabajo.create_at as HoradeCreacion
     , em.nameEstado          as EstadoMaquina
     , u.fullname             as Creador
     , p.namePrioridad        as Prioridad
     , s.nameStatus           as Status
     , s.avanceStatus         as AvanceStatus
     , s.idStatus

FROM ordentrabajo
         inner join area a on ordenTrabajo.idArea = a.idArea
         inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina
         inner join estadoMaquina em on em.idEstadoMaquina = ordenTrabajo.estadoMaquina
         inner join usuario u on u.iduser = ordenTrabajo.idUsuario
         inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad
         inner join status s on ordenTrabajo.idStatus = s.idStatus
         inner join orden_Status oS on oS.idOrden = ordenTrabajo.idOrdenTrabajo
GROUP BY idOrdenTrabajo;

create view ordenStatusDetails as
select os.idOrden,
       u.fullname     as NameAcepto,
       s.nameStatus   as Estado,
       s.avanceStatus as AvanceStatus,
       os.create_at,
       s.idStatus
from orden_Status as os
         inner join usuario u on iduser = os.idUsuario
         inner join status s on os.idStatus = s.idStatus;

create view externo as
select orden_Status.idOrden,
       a.nameArea,
       m.nameMaquina,
       eM.nameEstado,
       orden_Status.idStatus,
       p2.namePrioridad,
       t.idTipoMantenimiento,
       t.nameTipoMantenimiento,
       p.nameProveedor
from orden_Status
         inner join ordenTrabajo ot on idOrden = ot.idOrdenTrabajo
         inner join area a on ot.idArea = a.idArea
         inner join maquina m on ot.idMaquina = m.idMaquina
         inner join tipomantenimiento t on orden_Status.idTipoMantenimiento = t.idTipoMantenimiento
         inner join proveedor p on orden_Status.idProveedor = p.idProveedor
         inner join prioridad p2 on ot.idPrioridad = p2.idPrioridad
         inner join estadoMaquina eM on ot.estadoMaquina = eM.idEstadoMaquina
where t.idTipoMantenimiento = 4
  and orden_Status.idStatus = 5
order by idOrden;

create view ordenesRevisar as
select os.idOrden, os.idStatus, a.nameArea, m.nameMaquina, e.nameEstado, p.namePrioridad
from orden_status os
         inner join ordentrabajo o on os.idOrden = o.idOrdenTrabajo
         inner join area a on o.idArea = a.idArea
         inner join maquina m on o.idMaquina = m.idMaquina
         inner join estadoMaquina e on o.estadoMaquina = e.idEstadoMaquina
         inner join prioridad p on o.idPrioridad = p.idPrioridad;

create view ordenesFechaActual as
select idOrdenTrabajo, DATE_FORMAT(create_at, "%Y-%m-%d") as fecha
from ordenTrabajo;

create view tecnicosOrden as
select o_t.idOrdenTrabajador,
       ot.idOrdenTrabajo,
       u.iduser,
       o.idTipoMantenimiento,
       t2.nameTipoMantenimiento,
       t.idTecnico,
       Os.idStatus,
       em.nameEstado,
       a.nameArea,
       m.nameMaquina,
       p.namePrioridad,
       s.nameStatus,
       u.fullname,
       e.nameEspecialidad
from orden_trabajador o_t
         inner join ordentrabajo ot on o_t.idOrden = ot.idOrdenTrabajo
         inner join estadoMaquina em on ot.estadoMaquina = em.idEstadoMaquina
         inner join area a on ot.idArea = a.idArea
         inner join maquina m on ot.idMaquina = m.idMaquina
         inner join prioridad p on ot.idPrioridad = p.idPrioridad
         inner join status s on ot.idStatus = s.idStatus
         inner join tecnico t on o_t.idTecnico = t.idTecnico
         inner join especialidadtecnico e on t.idEspecialidad = e.idEspecialidad
         inner join usuario u on t.idUser = u.iduser
         inner join orden_Status oS on s.idStatus = oS.idStatus
         inner join orden_tipomantenimiento o on o_t.idOrden = o.idOrden
         inner join tipomantenimiento t2 on o.idTipoMantenimiento = t2.idTipoMantenimiento;

create view comentariosOrdenUser as
select co.idOrden, co.idUser, co.idStatus, co.comentario, u.fullname, s.nameStatus
from comentarios_orden co
         inner join status s on s.idStatus = co.idStatus
         inner join usuario u on co.idUser = u.iduser
order by idStatus;


select *
from comentariosOrdenUser
where idOrden = 85;


select *
from ordenStatusDetails;
select *
from comentariosOrdenUser;
select *
from comentarios_orden;

/* Query que agrupa los comentarios con el status */
select c.idOrden, c.idStatus, oSD.AvanceStatus, c.fullname as Responsable, c.comentario
from ordenStatusDetails oSD
         inner join comentariosordenuser c on oSD.idStatus = c.idStatus
group by c.idStatus;



create view ordenesStatus as
select ordenTrabajo.*,
       s.nameStatus,
       a.nameArea,
       m.nameMaquina,
       e.nameEstado,
       p.namePrioridad
from ordenTrabajo
         inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad
         inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina
         inner join area a on ordenTrabajo.idArea = a.idArea
         inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina
         inner join status s on ordenTrabajo.idStatus = s.idStatus;

select *
from ordenesStatus
where idStatus = 6;

select *
from ordentrabajo;

select *
from orden_Status;

select *
from orden_Status
where idStatus = 6;

alter table producto
    drop column cantidadProducto;
alter table producto
    drop column datosAdicionales;

select *
from producto;

alter table producto
    add column DetallesProducto varchar(200);

select *
from producto;
select *
from orden_producto;
alter table orden_producto
    add column datosAdicionales varchar(200);
select *
from orden_producto;

alter table orden_producto
    add column idUser int(100);

alter table orden_producto
    add constraint fk_orden_producto foreign key (idUser) references usuario (iduser) ON DELETE CASCADE;
SELECT *
FROM orden_producto;

select *
from ordentrabajo;

ALTER TABLE orden_producto
    add column cantidad int(5) not null;
alter table orden_producto
    drop column datosAdicionales;
select *
from orden_producto;
describe orden_producto;


create view productosOrdenes as
select op.idOrdenProducto,
       op.idOrden,
       op.create_at,
       op.idUser,
       op.cantidad,
       p.idProducto,
       p.nameProducto,
       p.DetallesProducto
from orden_producto op
         inner join producto p on op.idProducto = p.idProducto;


alter table proveedor_orden
    drop column fechaFinalTrabajo;
alter table proveedor_orden
    drop column fechaInicioTrabajo;
alter table proveedor_orden
    drop column descripcionTrabajo;
select *
from proveedor_orden;

select *
from tipoMantenimiento;
delete
from tipoMantenimiento
where idTipoMantenimiento = 4;

create table tipoTrabajo
(
    idTipoTrabajo   int(100)    not null primary key auto_increment,
    nameTipoTrabajo varchar(50) not null
);
insert into tipoTrabajo(nameTipoTrabajo) value ('Externo');

select *
from tipoTrabajo;
create table tipoTrabajo_orden
(
    id_tipoTrabajo_orden int(100) not null primary key auto_increment,
    idOrden              int(100) not null,
    idProveedor          int(100) not null
);

alter table tipoTrabajo_orden
    add constraint fk_tipoTrabajo_orden foreign key (idOrden) references ordentrabajo (idOrdenTrabajo) ON DELETE CASCADE;

alter table tipoTrabajo_orden
    add constraint fk_tipoTrabajo_proveedor foreign key (idProveedor) references proveedor (idProveedor) on delete cascade;

insert into status (nameStatus, avanceStatus)
VALUES ('Asignada Externo', 80);

create view dataUser as
select u.iduser, u.fullname, u.username, r.nameRol
from usuario u
         inner join rolusuario r on u.rolusuario = r.idRol;

/*--------------------//Vistas------------------------*/

select *
from bddnova.dataUser;

update usuario
set rolusuario = 1
where iduser = 6;


select *
from usuario;



select *
from usuario;
select *
from rolusuario;
select *
from especialidadtecnico;
select *
from tecnico;

select *
from usuario
where rolusuario = 4;
select *
from rolusuario;


select t.idUser, u.fullname, e.nameEspecialidad
from tecnico t
         inner join usuario u on t.idUser = u.iduser
         inner join especialidadtecnico e on t.idEspecialidad = e.idEspecialidad;


delete
from especialidadtecnico;
DELETE
from tecnico
where idTecnico = 5;
select *
from tecnico;


select *
from tecnico;
select *
from usuario;
select *
from rolusuario;
select *
from especialidadtecnico;



select t.*
from tecnico t
         inner join usuario u on t.idUser = u.iduser
where rolusuario = 4;
select count(iduser)
from usuario;


select *
from especialidadtecnico;
select *
from tecnico;
select *
from usuario;

update tecnico
set idEspecialidad= ?
where iduser = ?;

insert into tecnico(idUser, idEspecialidad)
VALUES (?, ?);
select fullname, rolusuario
from usuario
         inner join tecnico t on usuario.iduser = t.idUser;
select *
from rolusuario;

select *
from status;
create view dataUser as
select u.fullname, u.username, r.nameRol
from usuario u
         inner join rolusuario r on u.rolusuario = r.idRol;


select *
from usuario;



select *
from sessions;
select *
from usuario;
describe usuario;



select *
from rolusuario;
update usuario
set rolusuario=1
where iduser = 7;
select *
from area;

select *
from orden_Trabajador;
select *
from tecnicosOrden;
select *
from tecnicosOrden;
select *
from fechas_orden;
select *
from comentarios_orden;
select *
from orden_tipomantenimiento;

select *
from tecnico;
select *
from tecnicosOrden;


select o_t.idOrdenTrabajador,
       ot.idOrdenTrabajo,
       u.iduser,
       o.idTipoMantenimiento,
       t2.nameTipoMantenimiento,
       t.idTecnico,
       Os.idStatus,
       em.nameEstado,
       a.nameArea,
       m.nameMaquina,
       p.namePrioridad,
       s.nameStatus,
       u.fullname,
       e.nameEspecialidad
from orden_trabajador o_t
         inner join ordentrabajo ot on o_t.idOrden = ot.idOrdenTrabajo
         inner join estadoMaquina em on ot.estadoMaquina = em.idEstadoMaquina
         inner join area a on ot.idArea = a.idArea
         inner join maquina m on ot.idMaquina = m.idMaquina
         inner join prioridad p on ot.idPrioridad = p.idPrioridad
         inner join status s on ot.idStatus = s.idStatus
         inner join tecnico t on o_t.idTecnico = t.idTecnico
         inner join especialidadtecnico e on t.idEspecialidad = e.idEspecialidad
         inner join usuario u on t.idUser = u.iduser
         inner join orden_Status oS on s.idStatus = oS.idStatus
         inner join orden_tipomantenimiento o on o_t.idOrden = o.idOrden
         inner join tipomantenimiento t2 on o.idTipoMantenimiento = t2.idTipoMantenimiento;


select o_t.idOrdenTrabajador,
       ot.idOrdenTrabajo,
       em.nameEstado,
       a.nameArea,
       m.nameMaquina,
       p.namePrioridad,
       o.idTipoMantenimiento,
       t2.nameTipoMantenimiento
from orden_Trabajador o_t
    inner join tecnico t on o_t.idTecnico = t.idTecnico
         inner join ordentrabajo ot on o_t.idOrden = ot.idOrdenTrabajo
         inner join estadoMaquina em on ot.estadoMaquina = em.idEstadoMaquina
         inner join area a on ot.idArea = a.idArea
         inner join maquina m on ot.idMaquina = m.idMaquina
         inner join prioridad p on ot.idPrioridad = p.idPrioridad
         inner join status s on ot.idStatus = s.idStatus
         inner join orden_tipomantenimiento o on o_t.idOrden = o.idOrden
         inner join tipomantenimiento t2 on o.idTipoMantenimiento = t2.idTipoMantenimiento;



select *
from tecnico
inner join especialidadtecnico e on tecnico.idEspecialidad = e.idEspecialidad;

select * from orden_Trabajador
inner join tecnico t on orden_Trabajador.idTecnico = t.idTecnico;

select * from orden_Trabajador;

select * from tecnico
inner join orden_Trabajador oT on tecnico.idTecnico = oT.idTecnico;


select iduser, fullname from usuario

