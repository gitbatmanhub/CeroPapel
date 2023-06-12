
use dbmaster;

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



show tables;


alter table usuario
    add constraint fk_RolUsuario foreign key (rolUsuario) references rolUsuario(idRol) on update cascade;
    
alter table usuario drop constraint fk_RolUsuario;


alter table ordenTrabajo
    add constraint fk_idUsuario foreign key (idUsuario) references usuario (iduser);

alter table ordenTrabajo
    add constraint fk_idPrioridad foreign key (idPrioridad) references prioridad (idPrioridad);

alter table ordenTrabajo
    add constraint fk_estadoMaquina foreign key (estadoMaquina) references estadoMaquina (idEstadoMaquina);

alter table ordenTrabajo
    add constraint fk_idstatusOT foreign key (idStatus) references status (idStatus);

alter table ordenTrabajo
    add constraint fk_idMaquina foreign key (idMaquina) references maquina (idMaquina);

alter table ordenTrabajo
    add constraint fk_idArea foreign key (idArea) references area (idArea);

alter table orden_Status
    add constraint fk_idOrden foreign key (idOrden) references ordenTrabajo (idOrdenTrabajo) on delete cascade;



alter table orden_Status
    add constraint fk_idTipoMantenimiento foreign key (idTipoMantenimiento) references tipoMantenimiento (idTipoMantenimiento) on update cascade;

alter table orden_Status
    add constraint fk_idStatusOs foreign key (idStatus) references status (idStatus);

alter table orden_Producto
    add constraint fk_idProducto foreign key (idProducto) references producto (idProducto);


use dbmaster;
alter table orden_Producto drop constraint fk_id_Orden;
alter table orden_Producto
    add constraint fk_id_Orden foreign key (idOrden) references ordenTrabajo (idOrdenTrabajo) on delete cascade;

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

insert into rolUsuario(nameRol)
values ('Administrador'),
       ('Lider Mantenimiento'),
       ('Usuario'),
       ('Tecnico');




insert into status(nameStatus, avanceStatus)
VALUES ('Abierta', 20),
       ('Aprobada', 40),
       ('Atendida', 60),
       ('En Progreso', 70),
       ('Espera Revisión', 90),
       ('Asignada Externo', 80),
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


insert into tipoMantenimiento(nameTipoMantenimiento)
values ('Preventivo'),
       ('Correctivo'),
       ('Mejora');



alter table orden_Status
    add column idUsuario int(6) not null;

alter table orden_Status
    add constraint fk_idUsuarioStatus foreign key (idUsuario) references usuario (iduser);

/*++++++++++++++++++++++++*/
alter table orden_Status
    add column fechaInicio timestamp default current_timestamp;


alter table orden_Status
    add column fechaFinal timestamp default current_timestamp;

alter table orden_Status
    add column comentariosLider varchar(500) not null default "No comentarios";

alter table orden_Status
    add column comentariosTecnico varchar(500) not null default "Los comentarios se activan al momento de que la orden pasa a Revisión por el Lider Mantenimiento o PLanificador respectivamente";
select *
from orden_status;
select *
from status;



insert into tipoMantenimiento(nametipomantenimiento)
values ('Externo');


alter table orden_Status
    add column idProveedor int(5) default 1;
use dbmaster;
create table proveedor_orden
(
    idProveedor_Orden  int(100)     not null primary key auto_increment,
    idOrdenTrabajo     int(7)       not null,
    idProveedor        int(5)       not null,
    fechaInicioTrabajo timestamp,
    fechaFinalTrabajo  timestamp,
    descripcionTrabajo text(100000) not null
);





create table proveedor
(
    idProveedor   int(5) not null primary key auto_increment,
    nameProveedor varchar(50)
);
alter table orden_Status
    add constraint fk_idProveedor foreign key (idProveedor) references proveedor (idProveedor);
    
    select * from usuario;



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
    add constraint fk_idOrdenFecha foreign key (idOrden) references ordenTrabajo (idOrdenTrabajo) on delete cascade;



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
    add constraint fk_orden_tipomantenimeinto foreign key (idOrden) references ordenTrabajo (idOrdenTrabajo) ON delete CASCADE;

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
        , ordenTrabajo.create_at as HoradeCreacion,
       em.nameEstado as EstadoMaquina,
       u.fullname as Creador,
       p.namePrioridad as Prioridad,
       s.nameStatus as Status,
       s.avanceStatus as AvanceStatus,
       s.idStatus


FROM ordenTrabajo
         inner join area a on ordenTrabajo.idArea = a.idArea
         inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina
         inner join estadoMaquina em on em.idEstadoMaquina=ordenTrabajo.estadoMaquina
         inner join usuario u on ordenTrabajo.idUsuario= u.iduser
         inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad
         inner join status s on ordenTrabajo.idStatus = s.idStatus;
select * from ordenTrabajo;


insert into proveedor(nameProveedor)
values ('Novared');








alter table proveedor_orden
    add constraint fk_idProveedorOrden foreign key (idOrdenTrabajo) references ordenTrabajo (idOrdenTrabajo) on delete cascade;


alter table proveedor_orden
    add constraint fk_OrdenProveedor foreign key (idProveedor) references proveedor (idProveedor);



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




create view ordenesRevisar as
select os.idOrden, os.idStatus, a.nameArea, m.nameMaquina, e.nameEstado, p.namePrioridad
from orden_Status os
         inner join ordenTrabajo o on os.idOrden = o.idOrdenTrabajo
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
       oS.idStatus,
       em.nameEstado,
       a.nameArea,
       m.nameMaquina,
       p.namePrioridad,
       s.nameStatus,
       u.fullname,
       e.nameEspecialidad
from orden_Trabajador o_t
         inner join ordenTrabajo ot on o_t.idOrden = ot.idOrdenTrabajo
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
         inner join tipoMantenimiento t2 on o.idTipoMantenimiento = t2.idTipoMantenimiento;


create view comentariosOrdenUser as
select co.idOrden, co.idUser, co.idStatus, co.comentario, u.fullname, s.nameStatus
from comentarios_orden co
         inner join status s on s.idStatus = co.idStatus
         inner join usuario u on co.idUser = u.iduser
order by idStatus;




/* Query que agrupa los comentarios con el status  revisar
select c.idOrden, c.idStatus, oSD.AvanceStatus, c.fullname as Responsable, c.comentario
from ordenStatusDetails oSD
         inner join comentariosordenuser c on oSD.idStatus = c.idStatus
group by c.idStatus;

*/

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





alter table producto
    drop column cantidadProducto;
alter table producto
    drop column datosAdicionales;

alter table producto
    add column DetallesProducto varchar(200);


alter table orden_Producto
    add column idUser int(100);

alter table orden_Producto
    add constraint fk_orden_producto foreign key (idUser) references usuario (iduser) ON DELETE CASCADE;


ALTER TABLE orden_Producto
    add column cantidad int(5) not null;









create view productosOrdenes as
select op.idOrdenProducto,
       op.idOrden,
       op.create_at,
       op.idUser,
       op.cantidad,
       p.idProducto,
       p.nameProducto,
       p.DetallesProducto,
       u.fullname
from orden_Producto op
         inner join producto p on op.idProducto = p.idProducto
         inner join usuario u on op.idUser = u.iduser;
         select * from orden_Producto;


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
    add constraint fk_tipoTrabajo_orden foreign key (idOrden) references ordenTrabajo (idOrdenTrabajo) ON DELETE CASCADE;

alter table tipoTrabajo_orden
    add constraint fk_tipoTrabajo_proveedor foreign key (idProveedor) references proveedor (idProveedor) on delete cascade;

insert into status (nameStatus, avanceStatus)
VALUES ('Asignada Externo', 80);

create view dataUser as
select u.iduser, u.fullname, u.username, r.nameRol
from usuario u
         inner join rolUsuario r on u.rolusuario = r.idRol;


select * from usuario;
update usuario set rolusuario=1 where iduser=1;

alter table proveedor_orden add column create_at timestamp default current_timestamp;


create view proveedorNombreOrden as
select po.idProveedor, po.idOrdenTrabajo, create_at, p.nameProveedor, tM.nameTipoMantenimiento
from proveedor_orden po
         inner join proveedor p on po.idProveedor = p.idProveedor
         inner join tipoMantenimiento tM on po.id_tipoMantenimiento=tM.idTipoMantenimiento;
	

create view tecnicosOrdenExterna as
select po.idOrdenTrabajo,
       po.idProveedor,
       po.id_tipoMantenimiento,
       p.nameProveedor,
       tm.nameTipoMantenimiento,
       po.create_at,
       ot.idTecnico,
       u.fullname,
       e.nameEspecialidad
from proveedor_orden po
         inner join proveedor p on po.idProveedor = p.idProveedor
         inner join tipoMantenimiento tm on tm.idTipoMantenimiento = po.id_tipoMantenimiento
         inner join orden_Trabajador ot on ot.idOrden = po.idOrdenTrabajo
         inner join tecnico t on ot.idTecnico = t.idTecnico
         inner join especialidadtecnico e on t.idEspecialidad = e.idEspecialidad
         inner join usuario u on t.idUser = u.iduser;
         
         

select * from tecnicosOrdenExterna;
delete from status where idStatus=7;
delete from status where idStatus=8;
insert into status (idStatus, nameStatus, avanceStatus) values (7, "Terminada", 100);



SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select * from usuario;
update usuario set rolusuario=1 where iduser=1;
select * from rolUsuario;

SET GLOBAL FOREIGN_KEY_CHECKS = 0;



select * from rolUsuario;
insert into rolUsuario(nameRol)
values ('Administrador'),
       ('Lider Mantenimiento'),
       ('Usuario'),
       ('Tecnico');
select * from usuario;
delete from usuario where iduser=4;
 update usuario set rolusuario=1 where iduser=5;
 select * from rolUsuario;
 
 

select * from area;

select * from status;



INSERT INTO orden_Status set `idOrden` = '3', `idStatus` = '2', `idUsuario` = 5;
select * from orden_Status;
select * from tipoMantenimiento;
select * from status;
INSERT INTO orden_Status set `idOrden` = '3', `idStatus` = '2', `idUsuario` = 5;

describe orden_Status;
SET FOREIGN_KEY_CHECKS=0;
SET GLOBAL FOREIGN_KEY_CHECKS=0;
alter table orden_Status drop column idTipoMantenimiento;
alter table orden_Status drop constraint fk_idTipoMantenimiento ;
select * from productosOrdenes where idOrden='3';


select * from usuario;
use dbmaster;
select * from proveedor_orden;

select * from orden_Status;
use dbmaster;
select * from ordenTrabajo;
alter table ordenTrabajo auto_increment=961;
delete from ordenTrabajo ;
use dbmaster;
select * from especialidadtecnico;
insert into especialidadtecnico(nameEspecialidad) value("Mecanico");





select * from usuario;

select * from rolUsuario;
INSERT INTO rolUsuario(nameRol)
VALUES ("Operador"),
		("Digitador de producción"),
       ("Supervisor de producción");

       alter table rolUsuario auto_increment=4;
       
       
       #A partir de aquí la bbd del Modulo de producción
       
       
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
       
       
       insert into turno(nameTurno, horasTurno)
VALUES ("Diurno", 12),
       ("Nocturno", 12);



create table tipoOperador
(
    idTipoOperador   int(3) primary key not null auto_increment,
    nameTipoOperador varchar(20)        not null
);

alter table operador drop constraint fk_tipoOperador;


describe operador;
select * from operador;
alter table operador 
    add constraint fk_tipoOperador foreign key (idTipoOperador) references tipoOperador (idTipoOperador);
    select * from tipoOperador;
    
    
    


insert into tipoOperador (nameTipoOperador)
values ("Principal");

insert into tipoOperador (nameTipoOperador)
values ("Ayudante");



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
         inner join tipoOperador t2 on o.idtipoOperador = t2.idTipoOperador
         inner join usuario u on o.idUsuario = u.iduser
         inner join statusOF sF on o2.idstatus = sF.idStatus;

insert into tipoPara (nameTipoPara)
values ("MANT. PREVENTIVO"),
       ("LIMPIEZA"),
       ("DAÑO"),
       ("LOGISTICA"),
       ("OPERACION"),
       ("OTROS"),
       ("ADMINISTRATIVA"),
       ("ALIMENTACION");
       
       alter table horas_Para
    modify column inicioPara time not null;
alter table horas_Para
    modify column finPara time not null;
alter table horas_Para
    modify column idOrdenFabricacion int(7) not null;


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
       
       alter table kg_material
    drop constraint fk_idMaquinaria_Material;
alter table kg_material
    drop column idMaquinaria_Material;
    
    alter table kg_material
    add column idMaterial int(7) not null;
    alter table kg_material
    add constraint idMaterialKg foreign key (idMaterial) references material (idMaterial);
    
    
    alter table kg_material
    drop column horasTrabajadas;
    alter table kg_material
    add column hInicioTM time not null;
alter table kg_material
    add column hFinTM time not null;
    
    create view horasMaterial as
SELECT IF(
                   kg.hInicioTM <= kg.hFinTM,
                   TIMEDIFF(kg.hFinTM, kg.hInicioTM),
                   ADDTIME(TIMEDIFF('24:00:00', kg.hInicioTM), kg.hFinTM)
           ) AS horasMaterial,
       idOrdenFabricacion
from kg_material kg;


create view horasPara as
SELECT IF(
                   hp.inicioPara <= hp.finPara,
                   timediff(hp.finPara, hp.inicioPara),
                   addtime(timediff('24:00:00', hp.inicioPara), hp.finPara)
           ) as horasPara,
       idOrdenFabricacion
from horas_Para hp;
alter table ordenFabricacion
    drop column fecha;
    alter table ordenFabricacion
    drop column idTurno;
    
#Fail    
create view totalHorasMaterial as
select sec_to_time(sum(time_to_sec(horas))) as horasMaterial, idOrdenFabricacion
from horasMaterial;

create view totalHorasPara as
select sec_to_time(sum(time_to_sec(horasPara))) as horasPara, idOrdenFabricacion
from horasPara;

describe ordenFabricacion;

alter table ordenFabricacion drop constraint fk_idCreador;    
alter table ordenFabricacion drop constraint fk_idMaquinaria;
alter table ordenFabricacion drop constraint fk_idOperador;
alter table ordenFabricacion drop constraint fk_idUsuarioOperador;
alter table maquinaria_Material drop constraint fk_OrdenFabricacion;
alter table horas_Para drop constraint fk_idOrdenFabricacion;
alter table kg_material drop constraint fk_idOrdenFabricacionKg_material;

drop table ordenFabricacion;

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
    
    
    alter table ordenFabricacion
    add constraint kf_idMaquinariaof foreign key (idMaquinaria) references maquinaria (idMaquinaria);
alter table ordenFabricacion
    add constraint kf_idMaterialof foreign key (idMaterial) references material (idMaterial);
    
    
    
    
    
    
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
         
         alter table horasParas rename column motivo to idtipoPara;






select * from horasParas;
select * from horas_Para;
/* Antes */
alter table horasParas
    add constraint fk_idtipoParahoraspara foreign key (idtipoPara) references horasParas (idHorasPara);
/* Despues */
alter table horasParas drop constraint fk_idtipoParahoraspara;
alter table horasParas
    add constraint fk_idtipoParahoraspara foreign key (idtipoPara) references tipoPara (idTipoPara);
    
select * from horasParas where idOrdenFabricacion=17;



    
    
    
    
    
    
    
    
    
alter table horasParas rename column idOrdeFabricacion to idOrdenFabricacion;
alter table horasParas
    add column create_at timestamp default current_timestamp;


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
         
         
         drop view horasPara;
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
from horasOrdenFabricacion hF;

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
         /*-------------------------------------------------*/
         create table tipoMarca
(
    idTipoMarca   int(2)      not null primary key auto_increment,
    nameTipoMarca varchar(50) not null

);
insert into tipoMarca(nameTipoMarca)
values ('Entrada'),
       ('Salida');

alter table operador
    add column create_at timestamp default current_timestamp;

    alter table operador
    add column idTipoMarca int(2) not null;
    
    alter table operador
    add constraint fk_idTipoMarca foreign key (idTipoMarca) references tipoMarca (idTipoMarca);
    
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
select * from operador;
/*----------------------------------------*/


select * from operador;


drop view operadorTipoMarca;
create view operadorTipoMarca as
select *, if(idTipoMarca = 2, "2", "1") as tipoMarca
from operador;
/* 1048*/
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
         inner join horasOrdenFabricacion h on h.idOrdenFabricacion = o.idOrdenFabricacion
         inner join ordenFabricacion F on o.idOrdenFabricacion = F.idOrdenFabricacion
         inner join kgMaterial kM on F.idOrdenFabricacion = kM.idOrdenFabricacion
         inner join turno t2 on F.idTurno = t2.idTurno
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material m2 on F.idMaterial = m2.idMaterial
         inner join tipoMarca tm on o.idTipoMarca = tm.idTipoMarca
         inner join horasOf hO on F.idOrdenFabricacion = hO.idOrdenFabricacion;
         
         drop view horasOf;
create view horasOf as
SELECT IF(
                   hF.horaInicio <= hF.horaFinal,
                   TIMEDIFF(hF.horaFinal, hF.horaInicio),
                   ADDTIME(TIMEDIFF('24:00:00', hF.horaInicio), hF.horaFinal)
           ) AS horasOf,
       idOrdenFabricacion
from horasOrdenFabricacion hF;


/* 1199*/

select * from ordenFabricacion;


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
       date_format(o.create_at, "%H:%i") as hora,
       o.idtipoOperador
from operador o
         inner join usuario u on o.idUsuario = u.iduser
         inner join tipoMarca tM on tM.idTipoMarca = o.idTipoMarca
         inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador
         inner join ordenFabricacion F on o.idOrdenFabricacion = F.idOrdenFabricacion
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material m2 on F.idMaterial = m2.idMaterial
         inner join turno t2 on F.idTurno = t2.idTurno;



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



create view horasss as
select HoraSalida, HoraEntrada, HOS.idOrdenFabricacion, HOS.iduser
from HorasOperadoresEntrada
         inner join HorasOperadoresSalida HOS on HorasOperadoresEntrada.idOrdenFabricacion = HOS.idOrdenFabricacion;
         
drop view if exists operadoresData;

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
         
         

         
   drop view if exists dataAsignadas;
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
       o.idStatus                     AS idstatus
from (HorasOperadoresEntrada ho join ordenFabricacion o
      on ((ho.idOrdenFabricacion = o.idOrdenFabricacion)));

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
  
  select * from dataAsignadas;


select * from horasOrdenFabricacion;
select * from horasParas;
SET FOREIGN_KEY_CHECKS = 0;
select * from operador;
select * from ordenFabricacion;
insert into operador set `idOrdenFabricacion` = '2', `idUsuario` = 18, `idtipoOperador` = '2', `idTipoMarca` = '1';
select * from tipoOperador;

insert into operador (idtipoOperador, idUsuario, idOrdenFabricacion, idTipoMarca) values ( 1, 18, 4, 1);
insert into operador (idtipoOperador, idUsuario, idOrdenFabricacion, idTipoMarca) values ( 1, 5, 9, 1);
select * from operador where idOrdenFabricacion=1;
select * from usuario;
select * from operador where idUsuario=18 and idOrdenFabricacion=2;


select * from dataAsignadas where iduser=18 and idstatus=1;

select time(now());
SET time_zone = '-05:00';

use dbmaster;
SELECT COUNT(*) FROM mysql.time_zone_name;
SELECT * FROM mysql.time_zone_name;
SELECT * FROM mysql.time_zone_name WHERE name LIKE '%Guayaquil';

SELECT * FROM dbmaster.ordenFabricacion where idOrdenFabricacion=18;
select time(now());
select * from horasParas where idOrdenFabricacion=15;
select * from HorasOperadoresEntrada where idOrdenFabricacion=18;
select * from HorasOperadoresSalida where idOrdenFabricacion=18;


drop view HorasOperadores;
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




drop view dataAsignadas;
use dbmaster;
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
from (HorasOperadoresEntrada ho join ordenFabricacion o
      on ((ho.idOrdenFabricacion = o.idOrdenFabricacion)))
      inner join statusOF sF on o.idstatus=sF.idStatus ;
      
      select * from dataAsignadas where iduser=10 and idstatus=1;


insert into material (nameMaterial)
values ("CLAS. SOPLADO"),
       ("CLAS. HOGAR"),
       ("CLAS. OTROS");
       
       select * from ordenFabricacion;
       insert into maquinaria (nameMaquinaria) valueS ("TRITURADORA");
       
       
       insert into material (nameMaterial)
values ("TORTA TRITURADA PP"),
       ("TORTA TRITURADA PEAD"),
       ("TORTA TRITURADA ZUNCHO PP"),
       ("TORTA TRITURADA SACOS PP"),
       ("TORTA TRITURADA FILM ALTA"),
       ("TORTA TRITURADA FILM BAJA");
       select * FROM material;
       
       
       
       #Hasta aquí funcionaba
       
       
       insert into rolsuario set nameRol="Coordinador de Compra";

alter table producto add column codigo varchar(9) not null;
alter table producto modify nameProducto varchar(100) not null ;
alter table producto modify codigo varchar(10) not null ;
alter table producto add column unidad varchar(4) not null;
alter table producto add column saldo int(5) not null;
select * from producto;  

delete from orden_Producto;
delete from producto;
alter table producto auto_increment=1;
alter table orden_Producto auto_increment=1;
         

insert into producto (codigo, nameProducto, unidad, saldo)
values ("SSI00120","ARNES 4 ARGOLLAS DIELECTRICO","UN",1),
("SSI00011","ARNES DE SEGURIDAD 3 ARGOLLAS","UN",2),
("SSI00072","BOTA SOLDADOR CAÑA ALTA PUNTERA COMPOSITE","UN",1),
("SSI00088","BOTAS DE CUERO CON PUNTA DE ACERO","UN",7),
("SSI00079","CAPUCHA EN POLIALGODON TIPO NINJA BLANCA","UN",8),
("SSI00057","CARETA PARA SOLDAR","UN",3),
("SSI00006","CASCO AMARILLO","UN",2),
("SSI00073","CASCO AZUL","UN",1),
("SSI00015","CASCO GRIS","UN",1),
("SSI00075","CASCO VERDE","UN",1),
("SSI00035","CHOMPA EN CUERO PARA SOLDAR","UN",1),
("SSI00059","CORDON GAFAS","UN",12),
("SSI00103","DELANTAL C-14 AMARILLO 1,10 X 0,70","UN",5),
("SSI00095","FILTRO DE PARTICULAS DISCO ROSADO 207 ARMOR","UN",14),
("SSI00121","FILTROS CARTUCHOS 701 VAPOR ORGANICOS","UN",15),
("SSI00032","GAFAS POLICARBONATO OSCURAS PROT UV","UN",8),
("SSI00119","GORRAS LEGIONARIAS","UN",11),
("SSI00139","GUANTE ALPHATEC 58-535","UN",2),
("SSI00138","GUANTE ALPHATEC 9-928 ","UN",2),
("SSI00106","GUANTE CAUCHO C40","UN",10),
("SSI00028","GUANTE CUERO SOLDAR","UN",6),
("SSI00142","GUANTE DE ALGODÓN","UN",7),
("SSI00027","GUANTE DE CUERO NAPA MIXTO","UN",18),
("SSI00005","GUANTE DIELECTRICO","UN",5),
("SSI00107","GUANTE DOMESTICO C20","UN",12),
("SSI00141","GUANTE JAVSA DE TEJIDO","UN",1),
("SSI00003","GUANTE NITRILO MASTERFLEX N100 (MANIOBRA)","UN",30),
("SSI00023","GUANTE TONIELITE ANTICORTE NIVEL 5","UN",8),
("SSI00090","GUANTES DE EXAMINACION","UN",700),
("SSI00029","MANDIL DE CUERO SOLDADOR","UN",5),
("SSI00030","MANGAS DE CUERO SOLDADOR","UN",8),
("SSI00082","MASCARILLA DE SILICON AIR MEDIO ROSTRO S900M","UN",4),
("SSI00097","MASCARILLA KN95","UN",27),
("SSI00092","MASCARILLA QUIRURGICA DESECHABLE","UN",43),
("SSI00085","MASCARILLAS LAVABLES","UN",105),
("SSI00140","MICA PROTECTORA PARA MASCARILLA FULL FACE","UN",10),
("SSI00054","MONOGAFA","UN",7),
("SSI00049","PANTALONES INDUSTRIALES TALLA 30","UN",4),
("SSI00051","PANTALONES INDUSTRIALES TALLA 34","UN",6),
("SSI00052","PANTALONES INDUSTRIALES TALLA 36","UN",5),
("SSI00123","PANTALONES INDUSTRIALES TALLA 38","UN",8),
("SSI00031","POLAINA EN LONA IMPERMEABLE","UN",4),
("SSI00017","PROTECTOR AUDITIVO","UN",6),
("SSI00099","PROTECTOR FACIAL CONFORT","UN",8),
("SSI00025","RETENEDOR FILTRO 3M-501”","UN",10),
("SSI00100","SOBRETODO PVC C-12 M","UN",4),
("SSI00016","TAPON AUDITIVO","UN",47),
("SSI00086","TRAJE DE BIOSEGURIDAD DESECHABLE","UN",18),
("SSI00102","TRAJE TALLA L PANTALON Y CHAQUETA","UN",12),
("SSI00046","VISORES","UN",4),
("PTAC0001","ACCESORIO CAUCHO ANTIDESLIZANTE BANDEJA","UN",3),
("PTAC0002","ACCESORIO CESPED BANDEJA","UN",67),
("PTAC0004","ACCESORIOS MUSGO GRIS BAND.","UN",344),
("PTAC0003","ACCESORIOS MUSGO NEGRO BAND.","UN",277),
("PTAC0005","ROLLO MUSGO BLANCO 12X1.20 ","MT",12),
("SRIM0035","BANDAS DE CALIBRACION (CALIBRATI ON STRIP)","UN",1),
("SRIM0025","COMPRESOR DE AIRE DE TORNILLO PTAR ZLS15","UN",3),
("SRIM0026","COMPRESOR DE AIRE DE TORNILLO","UN",2),
("SRIM0037","CUCHILLA FRONTAL CARRO ALIM.","UN",1),
("SRIM0030","CUCHILLA MOLINO S 1200 D 2","UN",24),
("SRIM0029","CUCHILLA MOLINO T 1200 SKD 2","UN",18),
("SRIM0039","CUCHILLAS TAPA CH-1800 PLANA","UN",2),
("SRIM0021","EJE DEL ROTOR DE FRICCION","UN",1),
("SRIM0023","MEDIDOR DE PRESION","UN",2),
("SRIM0027","PIEDRA DE RECTIFICADO","UN",15),
("SRIM0032","RESISTENCIA CERAMICA 3.6 KW ZONA 2","UN",3),
("SRIM0005","RESISTENCIA TUBULAR  VOLT: 440V","UN",1),
("SRIM0028","SEGURO DE VIBRACION","UN",7),
("SRIM0022","SENSOR DE PRESION","UN",2),
("SRL00013","ABRAZADERA DE SUSPENSION 3.5 XTRA REF","UN",2),
("SRL00032","ARAÑA DE EJE REDONDO PARA RULIMAN 212049/218248","UN",1),
("SRL00016","ARAÑA DE REMOLQUE PARA ARAÑA 6 PUNTAS","UN",2),
("SRL00026","ARO DE LLANTA RIN 22,5","UN",1),
("SRL00052","BOCIN DE SOPORTE DE MARTILLO","UN",12),
("SRL00044","CANALES DE 100x50x6x6000MM","UN",5),
("SRL00086","CAUCHO PARA TAPA ENROSCABLE","UN",1),
("SRL00002","ESPARRAGO 3/4 X 3 1/8 ARAÑA","UN",3),
("SRL00015","KING PIN 2 PARA REMOLQUES DE PERNOS","UN",1),
("SRL00063","MARTILLO LEFTH 1 3/8 PARA RACHE","UN",1),
("SRL00064","MARTILLO RIGHTH 1 3/8 PARA RACHE","UN",1),
("SRL00082","PASADOR DE ZAPATAS (NIQUELADO)","UN",10),
("SRL00007","PERNOS 5/8 CON TUERCA  Y RODELA","UN",10),
("SRL00087","PINTURA ANTICORROSIVA AZUL","GL",1),
("SRL00020","PULMON DE FRENO TIPO 30 SENCILLO","UN",6),
("SRL00018","PULMON DOBLE ACCIÓN TIPO 30/30","UN",1),
("SRL00006","RACHE DE FRENO 1 5/8 37 ESTRIAS","UN",12),
("SRL00008","RESORTE DE ZAPATAS 3/4 X 5-1/2 ORANGE","UN",14),
("SRL00076","RODELA DE TUERCA TIPO CASTILLA","UN",7),
("SRL00051","RODELAS DE MARTILLO","UN",19),
("SRL00029","RULIMAN 212049/11","UN",1),
("SRL00030","RULIMAN 218248/10","UN",5),
("SRL00047","RULIMAN Y PISTAS PARA EJE CUADRADO","UN",7),
("SRL00050","SEGURO DE MARTILLO 38MM","UN",24),
("SRL00074","SEGURO DE TUERCA PEQUEÑA","UN",5),
("SRL00083","SEGURO DE ZAPATA TIPO ALAMBRE","UN",23),
("SRL00024","SEPARADORES RIN 22.5","UN",2),
("SRL00033","SOQUET ELECTRICO HEMBRA 7 POLOS","UN",3),
("SRL00046","TAPA PUNTA DE EJE DE PERNOS","UN",5),
("SRL00011","TEMPLADOR FIJO","UN",2),
("SRL00012","TEMPLADORES REGULABLES","UN",6),
("SRL00075","TUERCA DE EJE GRANDE TIPO CASTILLA","UN",4),
("SRL00003","TUERCA DE ESPARRAGO 3/4 ARAÑA","UN",14),
("SRL00072","TUERCA PEQUEÑA ANCHA","UN",4),
("SRL00071","TUERCA PEQUEÑA DELGADA","UN",4),
("SRL00021","VALVULA DE EMERGENCIA RE6","UN",4),
("SRL00019","VALVULA DE MANITO DE AIRE PARA MANGUERA","UN",2),
("SRL00022","VALVULA QRI CHILLONA","UN",2),
("SHT00870","ESTILETE PLASTICO ECONOMIC0 10-143 / 10-323","UN",1),
("SHT01168","ABRAZADERA INDUSTRIAL 7-1/2","UN",4),
("SHT01738","ABRAZADERA INOXIDABLE DE 3/4","UN",6),
("SHT01101","ABRAZADERA JET VERDE 1-3/4 32-44","UN",2),
("SHT01289","ABRAZADERA JET VERDE 2","UN",2),
("SHT01341","ABRAZADERA JET VERDE 2-1/2 50-65","UN",2),
("SHT00771","ABRAZADERA METALICA 1/2","UN",1),
("SHT01620_1","ABRAZADERA TIPO CLAMP PARA BRIDA DE 8","UN",3),
("SHT00794","ABRAZADERA TIPO FAJA 12 INOX","UN",4),
("SHT00243","ACEITE 3 EN 1 90ML","UN",2),
("SHT01386","ACEITE COMPRESOR CETUS046 LINEA PET","UN",6),
("SHT00428","ACEITE HIDRAULICO RANDO OIL HP 68","UN",129),
("SHT01573","ACEITE MOTOR DIESEL 15 W 40","GL",10),
("SHT01572","ACEITE MOTOR DIESEL 25 W 60","GL",5),
("SHT00479","ACEITE PARA COMPRESOR DE PISTON","LT",1),
("SHT01566","ACEITE PARA MOTOR A GASOLINA 10 W30","GL",5),
("SHT00573","ACEITE SOLUBLE  E OIL D ","GL",11),
("SHT01219","ACEITE TRANSMISION AUTOMATICA ATF MD3","GL",1),
("SHT00377","ACEPILLO DE ACERO","UN",1),
("SHT01599","ACIDO MURIATICO ( CLORHIDRICO AL 20 %)","UN",50),
("SHT01713","ACOPLE PARA CADENA KC-6020","UN",1),
("SHT01830","ACOPLE PARA TERMOCUPLA 1/4 X 8 CM DE LARGO","UN",23),
("SHT00294","ADAPTADOR 63MM X 50MM PVC","UN",5),
("SHT01305","ADAPTADOR MACHO SOLDABLE PVC 2","UN",2),
("SHT00878","ADAPTADOR MACHO SOLDABLE PVC 50 MM X 1-1/2","UN",3),
("SHT00500","ADAPTADOR STANLEY 3/4 X 1/2","UN",3),
("SHT01104","ADAPTADOR TALADRO SDS DEWALT","UN",3),
("SHT00877","ADAPTADOR TANQUE MONOCAPA 1-1/2","UN",1),
("SHT00713","AISLADOR BARRA C/PERNO SM 35MM","UN",2),
("SHT00559","AISLADOR TAPA DE ROSCA DE CERAMICA 5 MM x 16 MM","UN",53),
("SHT00342","ALCOHOL ANTIBACTERIAL GL WEIR","UN",1),
("SHT00017","ALICATE P/ELECTRICISTA 9 1/4 PROTO","UN",1),
("SHT01428","ALICATE PRO CORTE DIAGONAL 8","UN",4),
("SHT01427","ALICATE PRO ELECTRICO PELACABLE","UN",2),
("SHT01442","ALICATE PRO PUNTA FINA 8","UN",3),
("SHT00616","AMARRAS 25 CM","UN",11),
("SHT00292","AMARRAS PLASTICAS 50CM","UN",163),
("SHT00098","AMARRAS PLASTICAS","UN",29),
("SHT00810","AMOLADORA DEWALT 9 2400 W","UN",2),
("SHT01803","AMPERIMETRO ANALOGICO 96 x 96","UN",10),
("SHT00532","AMPERIMETRO FLUKE 373","UN",2),
("SHT01381","AMPERIMETRO FLUKE 376","UN",1),
("SHT00867","ANGULO 1X2 (25X2MM)","UN",80),
("SHT00895","ANGULO 2X1/8 (50X3MM)","UN",20),
("SHT00373","ANILLO DE PRESION INOX 10MM","UN",164),
("SHT01264","ANILLO DE PRESION M16","UN",31),
("SHT01615","ANILLO DE PRESION M18","UN",33),
("SHT01241","ANILLO DE PRESION NEGRO 1 . 1/4","UN",4),
("SHT00711","ANILLO PLANO  5/8  ","UN",221),
("SHT00525","ANILLO PLANO 5/16","UN",77),
("SHT01046","ANILLO PLANO INOX 1/2","UN",63),
("SHT00374","ANILLO PLANO INOX 10MM","UN",69),
("SHT01265","ANILLO PLANO M16","UN",14),
("SHT01614","ANILLO PLANO M18","UN",12),
("SHT00303","ANILLO PLANO NEGRO 1/2","UN",84),
("SHT00739","ANILLO PLANO NEGRO 1/4","UN",41),
("SHT00439","ANILLO PLANO NEGRO 3/8 - 10MM","UN",123),
("SHT00893","ANILLO PLANO NEGRO 7/8","UN",34),
("SHT01467","ANILLO PLANO NEGRO M 12","UN",359),
("SHT00526","ANILLO PRESION  5/16","UN",92),
("SHT00495","ANILLO PRESION 1/2 GALV","UN",1),
("SHT01045","ANILLO PRESION INOX 1/2","UN",43),
("SHT00362","ANILLO PRESION INOX 3/8","UN",6),
("SHT00266","ANILLO PRESION INOXIDABLE 3/4","UN",4),
("SHT01671","ANILLO PRESION INOXIDABLE 5/16","UN",40),
("SHT00252","ANILLO PRESION NEGRO 1/2","UN",28),
("SHT00740","ANILLO PRESION NEGRO 1/4","UN",55),
("SHT00160","ANILLO PRESION NEGRO 3/4","UN",97),
("SHT00727","ANILLO PRESION NEGRO 3/8 ","UN",111),
("SHT00720","ANILLO PRESION NEGRO 5/16","UN",20),
("SHT00426","ANILLO PRESION NEGRO 5/8","UN",130),
("SHT00891","ANILLO PRESION NEGRO 7/8","UN",39),
("SHT00221","ANILLO PRESION NEGRO 9/16","UN",30),
("SHT01468","ANILLO PRESION NEGRO M 12","UN",166),
("SHT01706","ANILLO PRESION NEGRO M 20","UN",20),
("SHT01657","ARANDELA ESTRIADA M 8","UN",30),
("SHT00557","ARRANCADOR SUAVE 3RW4047-1BB14 SIEMENS","UN",1),
("SHT00275","B104 JASON","UN",2),
("SHT01373","BALANZA 600 KG MDELO ELW TSCALE","UN",1),
("SHT01857","BALIZA ROJA 220 VOLTIOS","UN",4),
("SHT01994","BANDA 13A1780C","UN",2),
("SHT00667","BANDA 160 XL","UN",10),
("SHT01950","BANDA A 39","UN",2),
("SHT02074","BANDA A 49 PIX","UN",2),
("SHT00057","BANDA A56 PIX","UN",4),
("SHT01622","BANDA B 47","UN",3),
("SHT01812","BANDA B 84","UN",6),
("SHT01287","BANDA B-2134 LI","UN",8),
("SHT00211","BANDA B114 JASON","UN",2),
("SHT01454","BANDA B1433632","UN",14),
("SHT00088","BANDA B43 CARLISLE","UN",7),
("SHT00089","BANDA B49 CARLISLE","UN",3),
("SHT00955","BANDA B66_JASON","UN",7),
("SHT01384","BANDA B85 MOLINO HOGAR","UN",2),
("SHT01042","BANDA B87","UN",4),
("SHT00058","BANDA B98 PIX","UN",2),
("SHT01661","BANDA C 128 PIX","UN",6),
("SHT01688","BANDA C 83","UN",3),
("SHT00059","BANDA C105 OPTIBELT","UN",3),
("SHT00060","BANDA C126 PIX","UN",6),
("SHT01254","BANDA COSEDORA DE 170 XL","UN",1),
("SHT01296","BANDA MICA Y CERAMICA PONTECIA CONTANTE INYEC. 8300W/440VAC","UN",1),
("SHT01944","BANDA PIX B-63","UN",14),
("SHT02002","BANDA RECMF-6470","UN",2),
("SHT02001","BANDA RECMF-6510","UN",2),
("SHT01562","BANDA XAX 48 DAYCO","UN",1),
("SHT01190","BARNIZ BRILLANTE LATINA","UN",1),
("SHT00904","BARNIZ EN SPRAY 20 ONZ DOLPHS ER-41 ","UN",4),
("SHT01120","BARRA DE COBRE 1/8 x 3/4 x 3M","UN",2),
("SHT01121","BARRA DE COBRE 2-1/2 x 3/8 x 3M","UN",1),
("SHT01323","BASE DE 14 PINES PLANO RXZE2M114M","UN",5),
("SHT01211","BASE P/ CONCETOR DE CERAMICA","UN",20),
("SHT01842","BASE PARA RELE 8 PINES","UN",3),
("SHT01654","BISAGRA TORNEADA DE 1/2","UN",3),
("SHT01655","BISAGRA TORNEADA DE 5/8","UN",4),
("SHT00224","BISAGRA","UN",3),
("SHT02055","BOMBA DE FUMIGAR DE MOTOR A GASOLINA","UN",1),
("SHT00905","BOMBA MANUAL PARA FUMIGAR MARCA JACTO PLUS","UN",1),
("SHT00142","BOQUILLA TRICONICA #3 TIPO AGA","UN",2),
("SHT00143","BOQUILLA TRICONICA #4 TIPO AGA","UN",2),
("SHT00144","BOQUILLA TRICONICA #5 TIPO AGA","UN",3),
("SHT01404","BORDE DE BATERIAS (+ -)","UN",4),
("SHT01374","BORNERA IN 20 3 P - 30 AMP PARA RIEL DIN","UN",11),
("SHT01067","BORNERA PARA RIEL DIN P/CABLE 12","UN",119),
("SHT00419","BORNERA","UN",4),
("SHT01412","BORNERAS PLASTICAS CABLE 18AWG","UN",8),
("SHT01369","BORNERAS TRIFASICAS(REPARTIDOR CARGA 4 P)","UN",7),
("SHT00537","BOTON DE EMERGENCIA ","UN",1),
("SHT01072","BOTON DE EMERGENCIA CON CAJA","UN",4),
("SHT01087","BOYA ELECTRICA PAOLO/DANU RADAR","UN",4),
("SHT01367","BOYA MECANICA DE 1","UN",2),
("SHT00511","BRASSO PULIMENTO PASTA 70 GR","UN",1),
("SHT00570","BREACKER 2 POLOS 63 AMP","UN",3),
("SHT00635","BREACKER 2P 6 AMP","UN",1),
("SHT00599","BREACKER 3 POLOS 250 AMP","UN",1),
("SHT00236","BREAKER 1P-20A ECH FINO","UN",2),
("SHT01376","BREAKER 2 POLOS 40 AMP","UN",1),
("SHT01156","BREAKER 2P 10AMP","UN",2),
("SHT01001","BREAKER 2P 20AMP RIEL","UN",1),
("SHT01943","BREAKER 3 POLOS 125 AMP PARA RIEL","UN",1),
("SHT01586","BREAKER 3 POLOS 20 AMP SCHNEIDER","UN",2),
("SHT00953","BREAKER RIEL 2X100AMP MDW-C100 WEG","UN",1),
("SHT01835","BREAKER SCHNEIDER 2 POLOS 32 AMP IC60 N","UN",1),
("SHT00989","BREAKER SCHNEIDER 2P63A IC60N","UN",9),
("SHT00296","BRIDA 63MM PVC","UN",3),
("SHT00944","BROCA CEMENTO 5/8 X 6 MAKITA D-24452","UN",1),
("SHT01238","BROCA CEMENTO SDS PLUS 3/4 12","UN",1),
("SHT00271","BROCA COBALTO SURTEK 5/8","UN",1),
("SHT01504","BROCA COBALTO SURTEX 3/32","UN",1),
("SHT01506","BROCA COBALTO SURTEX 5/16","UN",1),
("SHT02067","BROCA M 10 HSS","UN",2),
("SHT01780","BROCA M 11 HSS","UN",1),
("SHT02068","BROCA M 12 HSS","UN",2),
("SHT01719","BROCA M 14 HSS","UN",3),
("SHT02069","BROCA M 15,5 HSS","UN",2),
("SHT01718","BROCA M 16 HSS","UN",1),
("SHT01755","BROCA M 18 HSS","UN",1),
("SHT01756","BROCA M 20 HSS","UN",1),
("SHT02066","BROCA M 8 HSS","UN",2),
("SHT00681","BROCA PARA CEMENTO 3/8","UN",1),
("SHT00365","BROCHA 3","UN",2),
("SHT01307","BROCHA CONDOR 5","UN",5),
("SHT01191","BROCHA SODOYA 1 1/2","UN",2),
("SHT00501","BROCHA WILSON 4","UN",8),
("SGP00003","BROCHA WILSON 2","UN",4),
("SHT01330","BUSHING DE 1 1/2 A 3/4","UN",1),
("SHT01077","BUSHING ROSCABLE DE 1-1/2 A 1/2","UN",1),
("SHT00444","BUSHING ROSCABLE GALV 1 - 1/2 X 1","UN",2),
("SHT01521","BUSHING ROSCABLE GALVANIZADO 3/8 x 1/4 NPT","UN",5),
("SHT01019","BUSHING ROSCABLE INOX. 1 X 1/4","UN",1),
("SHT00217","BUSHING ROSCABLE P. P. 1 X 1/2","UN",6),
("SHT00459","BUSHING ROSCABLE P.P 1-1/2 X 1 - 1/4","UN",2),
("SHT00366","BUSHING ROSCABLE P.P 1-1/2X1","UN",1),
("SHT01025","BUSHING ROSCABLE P.P 1/2 x 3/8","UN",7),
("SHT01029","BUSHING ROSCABLE P.P 2 A 1","UN",6),
("SHT01078","BUSHING ROSCABLE P.P. 1-1/2 A 1","UN",4),
("SHT00828","CABLE # 4 AWG SUPERFLEX","MT",27),
("SHT00843","CABLE # 6 AWG SUPERFLEX","MT",143),
("SHT00917","CABLE APANTALLADO 6X18","UN",47),
("SHT01417","CABLE APANTALLADO CERVITRONIC 4X 22 AWG","MT",10),
("SHT00231","CABLE BLANCO #14","MT",60),
("SHT01714","CABLE CONCENTRICO 2 x 14 (METROS)","UN",85),
("SHT00682","CABLE CONCENTRICO 3X16","UN",49),
("SHT00829","CABLE CONCENTRICO 4X10","MT",42),
("SHT00260","CABLE CONCENTRICO 4X12","MT",11),
("SHT01453","CABLE CONCENTRICO 4X14","MT",6),
("SHT00967","CABLE CONCENTRICO 4X16","MT",84),
("SHT00930","CABLE DE ALTA TEMPERATURA #10 (400°)","MT",6),
("SHT01578","CABLE DE COMUNICACIÓN PROFIBUS","MT",10),
("SHT01344","CABLE FLEXIBLE # 12","UN",100),
("SHT01814","CABLE FLEXIBLE # 16","MT",20),
("SHT00202","CABLE P/ALTA TEMPERATURA #12","MT",17),
("SHT01808","CABLE PARA EXTENCION DE TERMOCUPLA TIPO J ","MT",20),
("SHT01071","CABLE PARA TERMOCUPLA 2 HILOS TIPO J","MT",39),
("SHT01368","CABLE PLIATINA 2X14","UN",100),
("SHT00920","CABLE SUPERFLEX #1/0 AWG","UN",33),
("SHT00969","CABLE SUPERFLEX #10","MT",100),
("SHT01016","CABLE SUPERFLEX #2/0 (METROS)","UN",22),
("SHT00571","CABLE TEMPERATURA # 10","MT",47),
("SHT00761","CABO DE 1CM DE DIAMETRO","MT",417),
("SHT01088","CADENA GALV 1/4","MT",1),
("SHT00873","CAJA ANTIEXPLOSIVA RECTANGULAR 1/2","UN",8),
("SHT00078","CAJA HERRAMIENTA 22 TIPO ACORDEON","UN",1),
("SHT01346","CAJA MARFIL 40MM EMPOTRABLE","UN",10),
("SHT00230","CAJA OCTAGUNAL PEQUEÑA METALICA","UN",4),
("SHT01922","CAJA PVC RECTANGULAR","UN",7),
("SHT00226","CAJA RECTANGULAR EMT 2X4 PROFUNDA","UN",3),
("SHT01097","CAJA RECTANGULAR INTEMPERIE","UN",6),
("SHT00237","CAJA RECTANGULATAR UNIVERSAL 2X4","UN",10),
("SHT00021","CALIBR. PIE D/REY 200MM / 8 TITANIO MITUTOYO","UN",1),
("SHT01234","CALIBRADOR LAMINA 32 HOJAS","UN",1),
("SHT00527","CALIBRADOR ROSCA MM - PULGADA BP","UN",1),
("SHT01343","CANALETA BLANCA 40X25","UN",3),
("SHT01935","CANALETA RANURADA 80 X 60 MM","UN",1),
("SHT00621","CANALETA TIPO ESCALERA 25 x 10 ","UN",1),
("SHT00999","CANALON GALV. 0,45X45","UN",5),
("SHT01777","CANDADO PASO 40 SIMPLE","UN",12),
("SHT01775","CANDADO PASO 60 DOBLE","UN",1),
("SHT01542","CANDADO PASO 60 SIMPLE","UN",1),
("SHT02000","CAPACITOR 5MFD 370/ 440 VOLTIOS","UN",1),
("SHT01575","CAPUCHON PARA CONECTOR RJ 45","UN",116),
("SHT00391","CARBON PARA PULIDORA","UN",2),
("SHT00964","CARBON PARA SIERRA DE MESA SKILSAW 3610","UN",1),
("SHT01206","CARCAZA CON TUBO 2X18W","UN",3),
("SHT01440","CARRETILLA AMARILLA","UN",1),
("SHT01364","CARTUCHO ROTULADORA CASIO 12MM","UN",2),
("SHT00379","CAUTIN STANLEY 45 WATTS SI45","UN",3),
("SHT00724","CEPILLO HIERRO ALEMAN ","UN",4),
("SHT00636","CERRADURA TIPO TRIANGULO DE 1/2","UN",1),
("SHT01733","CHISPERO","UN",1),
("SHT00800","CHUMACERA TENSORA MARCA NTN UCT 207","UN",6),
("SHT01811","CHUMACERA UCP 207-35 MM","UN",2),
("SHT01887","CILINDRO COMPACTO 63 X 50 MM","UN",2),
("SHT01398","CILINDRO NEUMATICO (PELLETIZADORA)","UN",1),
("SHT00101","CINTA AISLANTE","UN",9),
("SHT00533","CINTA AUTOFUNDENTE","UN",6),
("SHT00170","CINTA DE EMPAQUE TRANSPARENTE","UN",4),
("SHT00171","CINTA DOBLE FAZ 3/4 2MTRS","UN",1),
("SHT01275","CINTA ESPIRAL CABLE # 16","UN",1),
("SHT01055","CINTA FIBRA DE VIDRIO","UN",4),
("SHT01675","CINTA MASKING 1","UN",4),
("SHT00735","CINTA METRICA 50MTRS STANLEY","UN",1),
("SHT01214","CINTA REFLECTIVA AMARILLA","MT",20),
("SHT01729","CLAVIJA 32 AMP MACHO ENCHUFE 4P+1 T","UN",5),
("SHT01069","CLAVIJA 3P 32A HEMBRA AZUL","UN",1),
("SHT01068","CLAVIJA 3P 32A MACHO AZUL","UN",5),
("SHT01183","CLAVIJA HEMBRA 4P 32AMP","UN",2),
("SHT01182","CLAVIJA MACHO 4P 32AMP","UN",3),
("SHT01003","CODO EMT 1/2","UN",4),
("SHT00975","CODO EMT 3","UN",2),
("SHT00295","CODO PP R/R 2 X 90 (LISO GRIS)","UN",2),
("SHT01074","CODO ROSCABLE 45° P.P 1","UN",4),
("SHT00899","CODO ROSCABLE 90 PP 1-1/2 NPT","UN",11),
("SHT00052","CODO ROSCABLE 90 PP POR MEDIA 1/2","UN",18),
("SHT01008","CODO ROSCABLE 90° GALV. 2 NPT","UN",1),
("SHT00347","CODO ROSCABLE 90° P.P 1 NPT","UN",11),
("SHT01135","CODO ROSCABLE 90° P.P. 3/4 NPT","UN",2),
("SHT01030","CODOS ROSCABLE PP 2","UN",8),
("SHT01422","COMPRESOR 3HP 200 LITROS","UN",1),
("SHT01210","CONCETOR DE CERAMICA 35AMP","UN",18),
("SHT01449","CONECTOR DE FUNDA SELLADA CURVO 2","UN",1),
("SHT01059","CONECTOR DE ROMEX DE 1/2","UN",21),
("SHT00228","CONECTOR EMT 1/2","UN",32),
("SHT00974","CONECTOR EMT 3","UN",6),
("SHT00633","CONECTOR FUNDA SELLADA 2","UN",4),
("SHT00630","CONECTOR FUNDA SELLADA DE 1","UN",18),
("SHT01809","CONECTOR MINI PARA EXTENCION DE TERMOCUPLA HEMBRA Y MACHO","UN",1),
("SHT01895","CONECTOR NEGRO FLEX 3/4","UN",40),
("SHT01574","CONECTOR RJ 45 CAT 6","UN",94),
("SHT00871","CONTACTOR 32AMP 220V 3 POLOS SCHNEIDER","UN",1),
("SHT01230","CONTACTOR DE 9 AM 220 V","UN",3),
("SHT00987","CONTACTOR LC1D40A 40 AMP.SERIE SCHN 220V","UN",6),
("SHT00909","CONTACTOR SCHNEIDER LC1D09M7","UN",4),
("SHT00768","CONTACTOR TRIFASICO 18A 220 VAC SCHNEIDER","UN",1),
("SHT01933","CONTROLADOR DE TEMPERATURA TCN4H-24R","UN",2),
("SHT01383","CONTROLADOR DE TEMPERATURA","UN",3),
("SHT00268","COOPER INTERRUPTOR 1 SERVICIO 1301V","UN",1),
("SHT00269","COOPER PLACA PLASTICA TOMA. 1 HUECO RECTO","UN",1),
("SHT00121","COPA PARA TALADRO 5/16","UN",11),
("SHT01096","CORTINA PLAST.REFORZ. RIBBED 8X3/32 USA 45.72MTS","MT",52),
("SHT00709","COSEDORA MANUAL JONTEX JT-7A-1","UN",2),
("SHT01752","CUCHILLA 100 MM X 60 MM X 8 MM SQUEEZER","UN",2),
("SHT01233","CUCHILLA DENTADA 60X57X600MM AVELLANADAS M 20 - 5 PERFRACIONES","UN",2),
("SHT01598","CUCHILLA FIJA 20 x 100 x 95 (LAVADO PET)","UN",2),
("SHT00897","CUCHILLA FIJA TRITURADORA","UN",4),
("SHT00152","CUCHILLA GUIA INFERIOR CHAPA 60*605*65MM","UN",1),
("SHT00155","CUCHILLA GUIA SUPERIOR CHAPA 65*605*75MM","UN",1),
("SHT01402","CUCHILLA MOLINO 4 OJOS CHINOS PELLETIZADORA","UN",9),
("SHT01363","CUCHILLA MOLINO HOGAR AC.NEGRO- FIJAS","UN",10),
("SHT01362","CUCHILLA MOLINO HOGAR AC.NEGRO-MOVILES","UN",4),
("SHT00898","CUCHILLA MOVIL TRITURADORA","UN",125),
("SHT01232","CUCHILLA RECTA 60X40X597 mm AVELLANADAS M18 - 5 PERFORACIONES","UN",2),
("SHT01295","CUCHILLAS 6 X100X64MM","UN",8),
("SHT01371","CUCHILLAS FIJAS 6 OJOS CHINOS (L.FIM)","UN",8),
("SHT01370","CUCHILLAS MOBILES 6 OJOS CHINOS (L.FIM)","UN",12),
("SHT01372","CUCHILLAS MOLINO A GASOLINA (MOLINO HOGAR)","UN",5),
("SHT00045","DADO 3/4 X 41 MM 6PT FORCE","UN",1),
("SHT00126","DADO IMPACTO MANDO 3/4 CORTO 30MM","UN",1),
("SHT00300","DADO STANLEY MAND 1/2 CORTO 28MM","UN",1),
("SHT00849","DADO STANLEY MANDO 1/2 CORTO 19MM 6PT 88-741 (86-519)","UN",3),
("SHT00701","DADO STANLEY MANDO 1/2 CORTO 24 MM 6PT","UN",2),
("SHT01651","DADOS PARA ALTO TORQUE #24","UN",1),
("SHT01650","DADOS PARA ALTO TORQUE #27","UN",1),
("SHT01649","DADOS PARA ALTO TORQUE #32","UN",1),
("SHT00466","DESAGUE CODO 45. 110 MM 4","UN",2),
("SHT01315","DESAGUE CODO 90* - 4 X 2" ,"UN",1),
("SHT01316","DESAGUE CODO 90* 50MM - 2","UN",6),
("SHT00055","DESAGUE CODO 90. 110 MM 4","UN",4),
("SHT01317","DESAGUE EN Y 50MM - 2","UN",2),
("SHT01584","DESAGUE REDUCTOR PVC 4 x 3","UN",1),
("SHT00699","DESARMADOR PRO ESTRELLA # 2 1/4x8","UN",2),
("SHT00700","DESARMADOR PRO PLANO  # 2 1/4x 6","UN",1),
("SHT00628","DESARMADOR TIPO BORNERO PLANO STANLEY","UN",2),
("SHT00625","DESARMADORES 10 PZ STANLEY","UN",1),
("SHT00763","DESENGRASANTE DE MAQUINAS","GL",3),
("SHT00719","DESOXIDANTE FOSFATIZANTE","GL",1),
("SHT01166","DESPAGUETI PARA CABLE #10 (8mm)","MT",78),
("SHT01165","DESPAGUETI PARA CABLE #12 (5mm)","MT",18),
("SHT00145","DESTORNILLADOR ELECTRICO MANUAL","UN",1),
("SHT01301","DESTORNILLADOR ESTRELLA 3/16X4","UN",1),
("SHT01302","DESTORNILLADOR PLANO 1/4X4","UN",1),
("SHT01431","DESTORNILLADOR PRO ESTRELLA 2-3/4","UN",3),
("SHT01430","DESTORNILLADOR PRO PLANO 6X1/8","UN",3),
("SHT01405","DETECTOR DE HUMEDAD (LAB)","UN",1),
("SHT01179","DEWALT AMOLADORA 4¨","UN",1),
("SHT00076","DEWALT AMOLADORA 7 2400W","UN",2),
("SGP00002","DILUYENTE","GL",14),
("SHT00110","DISCO 7 1/2 SIRCONIO","UN",5),
("SHT01327","DISCO DE CORTE BOSCH 10X80D","UN",1),
("SHT00082","DISCO DE CORTE NORTON  4 1/2","UN",32),
("SHT00081","DISCO DE CORTE NORTON 7","UN",54),
("SHT01538","DISCO DE CORTE PARA CONCRETO DE 7","UN",1),
("SHT00102","DISCO DE DESVASTE 41/2","UN",14),
("SHT01284","DISCO DE SIERRA 10 X 80 DE ALUMINIO","UN",1),
("SHT00117","DISCO ZIRCONICO 4 1/2","UN",4),
("SHT00538","DIYUNTOR 2P X10A PARA RIEL DIN","UN",1),
("SHT01479","DOBLADORA DE TUBO EMT 1/2","UN",1),
("SHT01481","DOBLADORA DE TUBO EMT 1","UN",1),
("SHT01480","DOBLADORA DE TUBO EMT 3/4","UN",1),
("SHT00461","DOMINO ESMALTE BLANCO BRILLANTE","UN",5),
("SHT00123","Disco desbaste 7” ¼","UN",15),
("SHT00355","ELECTROVALVULA CENTRO TANDEM 220V","UN",2),
("SHT00248","EMPAQUE O SELLO DE CAUCHO EXT.305MM INT.240MM ESP.5MM","UN",1),
("SHT00852","EMT CODO 1","UN",6),
("SHT00853","EMT UNION 1","UN",37),
("SHT00047","ENGRASADORA NEUMATICA DE 50LIBRAS","UN",1),
("SHT01192","ESCALERA TIPO TIJERA 6 PIES","UN",1),
("SHT00086","ESCOBA ROJA","UN",4),
("SHT00392","ESCUADRA MANGO ALUMINIO 10","UN",1),
("SHT00277","ESLABON PASO 60 SENCILLO","UN",4),
("SHT00827","ESLINGA DE RACHET TOTAL","UN",2),
("SHT02064","ESMERIL DE BANCO 6 PULGADAS 1/2 HP 373 W","UN",1),
("SHT01656","ESPARRAGO DE 8 MM ","UN",1),
("SHT01437","ESPARRAGO M16X80","UN",8),
("SHT00744","ESTILETE INDUSTRIAL","UN",1),
("SHT01436","EXTENSION DE RACHE 3/4 X 16 STANLEY ","UN",1),
("SHT01187","EXTRACTOR P/7 TON. P/POLEAS","UN",1),
("SHT00191","EXTRACTOR PERNO 5PCS","UN",1),
("SHT01577","FACEPLATE DOBLE","UN",6),
("SHT01576","FACEPLATE SENCILLO","UN",9),
("SHT01138","FAJA DE NYLON EXT: 232MM, ESP: 6MM, ALTO:35MM","UN",12),
("SHT01139","FAJA DE NYLON EXT:300MM, ESP: 5MM, ALTO:33,2MM","UN",8),
("SHT01140","FAJA DE TEFLON EXT: 230MM, ESP: 4,5MM, ALTO:7MM","UN",2),
("SHT01141","FAJA DE TEFLON EXT: 305MM, ESP: 4MM, ALTO:10,7MM","UN",2),
("SHT01434","FILTRO DE MALLA EN LINEA DE 2  CON REDUCTOR DE 1 1/2","UN",1),
("SHT01749","FILTRO PARA PISCINA","UN",4),
("SHT01751","FILTRO PARA SILO 510 MM","UN",2),
("SHT01750","FILTRO PARA SILO 780 MM","UN",1),
("SHT01848","FINAL DE CARRERA TIPO MICRO SWITCH","UN",1),
("SHT00022","FLEXOMETRO DE 5M-16FT x 3/4 STANLEY","UN",2),
("SHT01051","FOCO AHORRADOR 20W","UN",4),
("SHT01627","FOCO LED 9W","UN",1),
("SHT01221","FORCE ADAPTADOR IMPACTO 1x3/4","UN",1),
("SHT00127","FORCE ADAPTADOR IMPACTO 1/2 X 3/4","UN",1),
("SHT00348","FORMADOR EMPAQUE 1C PERMATEX 11 OZ","UN",1),
("SHT02022","FUNDA PLASTICA 24 + 8 FL X 90 X 2","UN",450),
("SHT00643","FUNDA SELLADA 1","MT",20),
("SHT01495","FUNDA SELLADA DE 1 1/2","MT",12),
("SHT00687","FUNDA SELLADA DE 3/4","MT",32),
("SHT00403","GATA HIDRAULICA 10TN","UN",2),
("SHT01099","GRAPA EMT 1","UN",2),
("SHT00795","GRAPA EMT 1/2","UN",42),
("SHT01500","GRAPA EMT 2","UN",24),
("SHT01278","GRAPA EMT 3/4","UN",12),
("SHT00585","GRASA EN SPRAY PARA CADENAS ","UN",1),
("SHT01445","GRASA STARFLEX2 PARA RODAMIENTOS","KG",16),
("SHT01194","GRASERO 1/4 NPT","UN",3),
("SHT00327","GRASERO 10MM RECTO","UN",12),
("SHT00328","GRASERO 6MM RECTO","UN",3),
("SHT00438","GRASERO 8MM","UN",3),
("SHT01548","GRASERO CURVO 45 GRADOS 1/4","UN",3),
("SHT01547","GRASERO CURVO 45 GRADOS 10 MM","UN",3),
("SHT01551","GRASERO CURVO 45 GRADOS 3/8","UN",3),
("SHT01549","GRASERO CURVO 45 GRADOS 5/16","UN",3),
("SHT01545","GRASERO CURVO 45 GRADOS 6 MM","UN",3),
("SHT01546","GRASERO CURVO 45 GRADOS 8 MM","UN",3),
("SHT01544","GRASERO RECTO 3/8","UN",3),
("SHT01543","GRASERO RECTO 5/16","UN",3),
("SHT01747","GRATA DE COPA RIZADA DE 4 ","UN",2),
("SHT00901","GRILLETE CABLE 3/8 GALV","UN",55),
("SHT01017","GRILLETE PARA VARILLA DE TIERRA 5/8","UN",1),
("SHT01648","GUANTE PARA ALTA TEMPERATURA","UN",6),
("SHT01839","GUARDAMOTOR 1-1,6 AMP","UN",1),
("SHT01641","GUARDAMOTOR 37-50 AMP","UN",1),
("SHT00710","HIDROLAVADORA KARCHER K2 BASIC","UN",1),
("SHT00262","HOROMETRO PARA PUERTA 220VAC 48X48 MM GRIS","UN",4),
("SHT01424","INFLADOR DE AIRE PARA RUEDA 1/4","UN",1),
("SGP00005","INSECTIN D PARA CUCARACHAS","LT",1),
("SHT01482","INTERRUPTOR DOBLE BTICINO 110 VOLTIOS","UN",1),
("SHT00242","INTERRUPTOR SENCILLO","UN",3),
("SHT01579","JACK CAT 6","UN",20),
("SHT01625_1","JGO DE DADOS PARA TALADRO DE 1/4 A 1/2","UN",1),
("SHT01425","JGO DESTORNILDORES PRO 10 PCS","UN",4),
("SHT00006","JGO LLAVE MIXTA DE 10 A 32MM 14PC STANLEY","UN",1),
("SHT00037","JGO LLAVES ALLEN .07 A 17MM","UN",1),
("SHT00011","JGO LLAVES ALLEN LAR.T /BOLA 1,5 A 10MM 9Pc PROTO","UN",1),
("SHT01429","JGO LLAVES HEXAGONALES 21 LARGAS","UN",3),
("SHT00024","JGO.MACHUEL.TARR. 1/4 A 1 NC-NF 45PC.WESTWARD","UN",1),
("SHT01122","JUEGO DE BROCAS 21 PCS SURTEK","UN",2),
("SHT02071","JUEGO DE EXTRACTOR DE PERNOS 3-20 MM","UN",1),
("SHT00520","JUEGO DE LLAVES ALLEN PULGADAS","UN",3),
("SHT00661","JUEGO DE LLAVES LARGAS MM 14 PCS","UN",3),
("SHT00669","JUEGO DE MACHUELO M4 MM","UN",1),
("SHT01225","JUEGO DE PINZAS MEGGER","UN",2),
("SHT01085","JUEGO DE PONCHADORA MANUAL CSC 22 A 60 MM (1/2 A 2) CAMSCO","UN",1),
("SHT01054","JUEGO DE PUNTAS DE MULTIMETRO","UN",1),
("SHT01073","JUEGO DE TARRAJA DE 1/2 A 2 PARA PVC","UN",2),
("SHT01834","JUEGO DE TERMNALES PARA BREAKER 160 AMP","UN",2),
("SHT00662","JUEGO DESARMARDOR BORNERO ERGONOMICO","UN",1),
("SHT01324","JUEGO DOBLE DE ENZUNCHAR PLASTICO","UN",1),
("SHT00329","KALIPEGA LITRO 946 CC","UN",2),
("SHT00817","KANA CANDADO COMPLETO PASO 80","UN",16),
("SHT01890","KIT DE RECAMBIO PARA CILINDRO COMPACTO 63 x 50","UN",3),
("SHT00513","LIJA DE AGUA 1000","UN",2),
("SHT00514","LIJA DE AGUA 1200","UN",4),
("SHT00515","LIJA DE AGUA 240","UN",2),
("SHT00516","LIJA DE AGUA 360","UN",1),
("SHT00517","LIJA DE AGUA 400","UN",3),
("SHT00518","LIJA DE AGUA 500","UN",2),
("SHT00984","LIMA MEDIA CANA FINA 10","UN",1),
("SHT00138","LIMA ROTATIVA 12MM CILINDRICA PUNTA REDONDA","UN",1),
("SHT00319","LIMPIA BOQUILLA","UN",8),
("SHT00586","LIMPIADOR DE CONTACTOS ELECTRONICOS SPRAY ","UN",2),
("SHT00029","LINTERNA P/CASCO 3 LED 180 LUMENS ENERGIZER","UN",3),
("SHT00179","LLANTA 12R 22,5 18PR LM302","UN",1),
("SHT00523","LLANTA NEUMATICA 28X9 R15 MONTACARGAS 3 TON","UN",1),
("SHT01267","LLAVE ALLEN #14","UN",1),
("SHT00928","LLAVE ALLEN CORTA 1/2 (12,7)","UN",1),
("SHT01286","LLAVE ALLEN DE 17 MM","UN",1),
("SHT01035","LLAVE ALLEN EXAGONAL 27MM X 10MM","UN",1),
("SHT01353","LLAVE DE LAVAMANO CON PULSADOR","UN",1),
("SHT01441","LLAVE DE PARED PICO ALTO","UN",1),
("SHT01450","LLAVE DE PASO PVC 3/4","UN",1),
("SHT01300","LLAVE DE TUBO 12 STANLEY","UN",2),
("SHT00026","LLAVE DE TUBO 18 STANLEY","UN",1),
("SHT01555","LLAVE DE TUBO 36 STANLEY","UN",1),
("SHT00040","LLAVE FRANCESA DE 24 M/AISL.","UN",1),
("SHT00004","LLAVE FRANCESA DE 8 BL STANLEY","UN",1),
("SHT00708","LLAVE MIXTA CHINA 30 MM ","UN",1),
("SHT00009","LLAVE MIXTA DE 8MM STANLEY","UN",1),
("SHT00067","LLAVE MIXTA FORCE 55MM","UN",1),
("SHT01298","LLAVE MIXTA STANLEY 10 MM","UN",1),
("SHT01299","LLAVE MIXTA STANLEY 13 MM","UN",1),
("SHT00061","LLAVE MIXTA STANLEY 19 MM 86-864","UN",3),
("SHT00062","LLAVE MIXTA STANLEY 22 MM 86-867","UN",1),
("SHT00063","LLAVE MIXTA STANLEY 24 MM 86-869","UN",4),
("SHT00903","LLAVE MIXTA STANLEY 28 MM 86-628","UN",1),
("SHT00180","LLAVE MIXTA STANLEY 36MM 89-721","UN",1),
("SHT00068","LLAVE MIXTA STANLEY 50 MM 89-779","UN",1),
("SHT00190","LLAVE RUEDA 33X32","UN",1),
("SHT00050","LLAVE TUBO STANLEY 36","UN",1),
("SHT02070","LOCTITE 242 50 ML","UN",2),
("SHT00947","LOCTITE 271 50ML","UN",5),
("SHT00639","LUZ PILOTO ROJA 220V","UN",3),
("SHT00638","LUZ PILOTO VERDE 220V","UN",6),
("SHT00192","MACHETE","UN",5),
("SHT01047","MACHUELO 14 MM UNC 2-0 SKC","UN",1),
("SHT02072","MACHUELO 16 MM UNC-2,0 SKC","UN",1),
("SHT00925","MACHUELO 18 MM UNC-2.5 SKC","UN",2),
("SHT00491","MACHUELO 20 MM","UN",1),
("SHT00745","MACHUELO 5MM","UN",2),
("SHT01638","MACHUELO M 22 MM UNC","UN",2),
("SHT01266","MACHUELO M 8 X 1.25","UN",1),
("SHT00657","MACHUELO NPT 1/4","UN",1),
("SHT00658","MACHUELO NPT 1/8","UN",1),
("SHT00659","MACHUELO NPT 3/8","UN",2),
("SHT00926","MANGUERA AIRE 8 MM AZUL POLIURETANO","UN",8),
("SHT01154","MANGUERA ANILLADA SUCCION 4","MT",2),
("SHT01948","MANGUERA PUN 12 MM","MT",5),
("SHT01103","MANGUERA TRANSPARENTE LISA 1-1/2","MT",2),
("SHT00149","MANÓMETRO","UN",3),
("SHT00992","MEDIDOR DE PH DE BOLSILLO IMPERMEABLE MARCA OAKTON*ECO TESTR PH1","UN",1),
("SHT01802","MEDIDOR DIGITAL 96 x 48","UN",1),
("SHT01776","MEDIO CANDADO PASO 60 DOBLE","UN",1),
("SHT00199","MEDIO ESLABON PASO 60 SENCILLO","UN",5),
("SHT01322","MINI RELAY 14 PIN PLANO230 VAC RXM4AB1P7","UN",2),
("SHT00239","MINICANALETA 32X12MM","UN",1),
("SHT01410","MINICONECTOR TIPO J","UN",1),
("SHT01432","MOCHILA DE HERRAMIENTAS STANLEY","UN",4),
("SHT01836","MOTOR SIEMENS C/ BRIDA 3 F 5HP 1800 RPM 220/440 VOLTIOS","UN",1),
("SHT00451","NEPLO FLEX PVC 1/2","UN",2),
("SHT01499","NEPLO PERDIDO PVC 1 1/4","UN",1),
("SHT01522","NEPLO REDUCTOR ROSCABLE 3/8 x 1/4 NPT","UN",4),
("SHT01251","NEPLOS DE 1 ","UN",5),
("SHT00759","NIVEL DE MANO MEDIANO","UN",1),
("SHT01031","NUDO ROSCABLE P.P 2","UN",5),
("SHT00796","NUDO ROSCABLE P.P. 1-1/2 NPT","UN",5),
("SHT00916","NUDO ROSCABLE P.P. 1-1/4 NPT","UN",2),
("SHT00465","NUDO ROSCABLE P.P. 1/2 NPT","UN",4),
("SHT00320","NUDO ROSCABLE PP 1 NPT","UN",14),
("SHT00332","NUDO SOLDABLE PVC 60 MM","UN",2),
("SHT01611","ORING 112X4","UN",2),
("SHT01571","ORING 130 MM x 140 MM x 5 MM","UN",8),
("SHT00544","ORING 3,0 MM","UN",8),
("SHT00545","ORING 3,5 MM","UN",8),
("SHT00546","ORING 4,0 MM","UN",8),
("SHT00547","ORING 4,5 MM","UN",10),
("SHT00548","ORING 5,0 MM","UN",10),
("SHT00549","ORING 5,5 MM","UN",10),
("SHT00477","ORING 6 MM","UN",7),
("SHT00550","ORING 6,5 MM","UN",10),
("SHT00551","ORING 7,0 MM","UN",10),
("SHT00554","ORING 8,5 MM","UN",2),
("SHT01142","ORING ESP: 6,3MM, EXT 300MM","UN",4),
("SHT01143","ORING ESP: 6,6MM, EXT 240MM","UN",2),
("SHT00039","PALANCA ARTICULADA DE 1/2x17 1/4 STANLEY","UN",1),
("SHT00497","PALANCA DE FUERZA STANLEY 3/4","UN",1),
("SHT00809","PANEL DRT PLUS 1027X0,3X6000","UN",3),
("SHT01447","PANEL REDONDO LED 90LMW 6500K/24W 300MM EMPOTRABLE","UN",1),
("SHT01608","PASTILLAS LED 50W","UN",18),
("SHT01220","PATA DE CABRA 24 STANLEY","UN",1),
("SHT01708","PEGATANQUE","UN",3),
("SHT00626","PELADORA DE CABLE 9,5 STANLEY","UN",1),
("SHT01196","PERFIL NOVACERO CORREA G 80x1.50mmx6m","UN",20),
("SHT00535","PERILLA DE 2POSICIONES","UN",1),
("SHT00167","PERNO 18X60","UN",2),
("SHT00166","PERNO 20X80","UN",126),
("SHT00372","PERNO ACERO INOX 10X30","UN",42),
("SHT00562","PERNO ALEN AVELLANADO NEGRO 16 x 60 MM","UN",24),
("SHT00580","PERNO ALLEN  AVELLANADO HG 18 x 50 ","UN",20),
("SHT01164","PERNO ALLEN 10X30mm","UN",19),
("SHT01789","PERNO ALLEN 3/8 X 3/4","UN",5),
("SHT00695","PERNO ALLEN 3/8x2 ","UN",10),
("SHT01660","PERNO ALLEN 5/16 X 3","UN",11),
("SHT00981","PERNO ALLEN AMERICANO UNC 1/2 X 2","UN",8),
("SHT01005","PERNO ALLEN AMERICANO UNC 5/8 X 1-1/2","UN",8),
("SHT01709","PERNO ALLEN AVELLANADO M 12 x 40","UN",3),
("SHT01785","PERNO ALLEN AVELLANADO M 14 x 60 ","UN",8),
("SHT01721","PERNO ALLEN AVELLANADO M 16 x 80","UN",22),
("SHT02053","PERNO ALLEN AVELLANADO M 20 X 50","UN",20),
("SHT01602","PERNO ALLEN M 12X35","UN",9),
("SHT01662","PERNO ALLEN M 24 x 70 MM","UN",8),
("SHT01462","PERNO ALLEN M 4 x 20 MM","UN",47),
("SHT01463","PERNO ALLEN M 5 x 20 MM","UN",6),
("SHT01464","PERNO ALLEN M 6 x 20 MM","UN",21),
("SHT00333","PERNO ALLEN MILIMETRICO 10 X 60","UN",21),
("SHT00398","PERNO ALLEN MILIMETRICO 12 X 30","UN",55),
("SHT00334","PERNO ALLEN MILIMETRICO 14 X 50","UN",25),
("SHT00241","PERNO ALLEN MILIMETRICO 16X50","UN",1),
("SHT00956","PERNO ALLEN MILIMETRICO 20 X 60","UN",4),
("SHT00952","PERNO ALLEN MILIMETRICO 20 X 80","UN",7),
("SHT00325","PERNO ALLEN MILIMETRICO 8 X 20","UN",19),
("SHT00945","PERNO ALLEN MILIMETRICO 8 X 30","UN",12),
("SHT01712","PERNO ALLEN MILIMETRICO M 8 x 90","UN",12),
("SHT01004","PERNO ALLEN MM 16 X 40","UN",2),
("SHT00576","PERNO ALLEN MM 16 x 50","UN",11),
("SHT00578","PERNO ALLEN MM 16 x 60","UN",21),
("SHT00577","PERNO ALLEN MM 16 x 80","UN",2),
("SHT00584","PERNO ALLEN MM 18x60","UN",34),
("SHT00583","PERNO ALLEN MM 18x70","UN",18),
("SHT00649","PERNO ALLEN MM 24X100","UN",8),
("SHT00302","PERNO AMERICANO HG 1/2 X 1-1/2","UN",25),
("SHT00369","PERNO AMERICANO HG 1/2 X 3","UN",1),
("SHT00812","PERNO AMERICANO HG 1/4 X 1","UN",28),
("SHT00725","PERNO AMERICANO HG 3/8x1","UN",10),
("SHT00723","PERNO AMERICANO HG 5/16 x 1-1/2","UN",7),
("SHT00425","PERNO AMERICANO HG 5/8 X 2","UN",3),
("SHT00949","PERNO AMERICANO HG 7/8 X 4","UN",2),
("SHT00214","PERNO AMERICANO HG 9/16 X 3 CON ANILLO Y TUERCA","UN",14),
("SHT01567","PERNO AVELLANADO M 16 x 50","UN",28),
("SHT01390","PERNO AVELLANADO M5X30 CON TUERCA","UN",12),
("SHT01389","PERNO AVELLANADO M6X30 CON TUERCA","UN",12),
("SHT00608","PERNO DE EXPANSION 3/8 x2","UN",1),
("SHT00156","PERNO ESTRIADO 22X98X1,5","UN",1),
("SHT01526","PERNO EXAGONAL M 10 x 30 MM","UN",52),
("SHT01659","PERNO EXAGONAL M 12 x 30","UN",2),
("SHT01466","PERNO EXAGONAL M 12 x 50","UN",224),
("SHT01516","PERNO EXAGONAL M 16 x 60","UN",26),
("SHT01771","PERNO EXAGONAL M 4 x 30","UN",30),
("SHT01524","PERNO EXAGONAL M 6 x 30 MM","UN",21),
("SHT01525","PERNO EXAGONAL M 8 x 30 MM","UN",22),
("SHT01212","PERNO EXAGONAL M14X60","UN",20),
("SHT00503","PERNO EXPANSION 1/2 x 3","UN",12),
("SHT00631","PERNO EXPANSION 7/16","UN",8),
("SHT01222","PERNO EXPANSION GALV. 5/8X3","UN",40),
("SHT01851","PERNO HEXAGONAL HILO CORRIDO M 10 X 25 MM","UN",30),
("SHT01850","PERNO HEXAGONAL HILO CORRIDO M 20 X 80 MM","UN",33),
("SHT01603","PERNO HEXAGONAL INOX M  8X30","UN",2),
("SHT01604","PERNO HEXAGONAL INOX M 10X30","UN",2),
("SHT01605","PERNO HEXAGONAL INOX M 12X30","UN",10),
("SHT01606","PERNO HEXAGONAL INOX M 14X50","UN",3),
("SHT01682","PERNO HEXAGONAL INOXIDABLE M 8 x 30","UN",12),
("SHT01817","PERNO HEXAGONAL M 10 X 100","UN",8),
("SHT01818","PERNO HEXAGONAL M 10 X 40","UN",3),
("SHT01865","PERNO HEXAGONAL M 12 X 40 HILO CORRIDO","UN",50),
("SHT01564","PERNO HEXAGONAL M 14 x 50 MM","UN",5),
("SHT01736","PERNO HEXAGONAL M 22 X 60","UN",83),
("SHT01796","PERNO HEXAGONAL M 22 X 70","UN",8),
("SHT01704","PERNO HEXAGONAL M 22 x 80","UN",10),
("SHT01443","PERNO HEXAGONAL M10X120 INOX","UN",6),
("SHT01628","PERNO HEXAGONAL M14 X 40","UN",11),
("SHT01263","PERNO HEXAGONAL M16X60 DE LARGO","UN",2),
("SHT01613","PERNO HEXAGONAL M18X60 DE LARGO","UN",32),
("SHT01043","PERNO INOX 1/2 X 2 HG","UN",65),
("SHT01093","PERNO INOX 3/4 X 2 HG","UN",10),
("SHT00940","PERNO INOX. MILIMETRICO 10 X 50","UN",21),
("SHT01184","PERNO INOX. MILIMETRICO 16X60","UN",73),
("SHT00264","PERNO INOXIDABLE AMERICANO UNC 3/4 X 3","UN",2),
("SHT00318","PERNO INOXIDABLE MILIMETRICO 8X20","UN",18),
("SHT01215","PERNO MILIMETRICO 10X80","UN",31),
("SHT00250","PERNO MILIMETRICO 12 X 50 NEGRO","UN",6),
("SHT00254","PERNO MILIMETRICO 20 X 60","UN",35),
("SHT01280","PERNO MILIMETRICO HG 14 X 100","UN",7),
("SHT01281","PERNO MILIMETRICO HG 14 X 70","UN",7),
("SHT01282","PERNO MILIMETRICO HG 18 X 60","UN",90),
("SHT01185","PERNO MILIMETRICO HG10X60","UN",10),
("SHT00848","PERNO MILIMETRICO TODO ROSCA 12X100","UN",58),
("SHT00508","PERNO MM 8x12","UN",8),
("SHT01126","PERNO ORIGINAL 12 X 50 HF","UN",4),
("SHT00734","PERNO PUNTA BROCA 10 X 1 1/2","UN",600),
("SHT01248","PERNOS ALLEN METRICO 30 X 100 MM","UN",4),
("SHT01079","PERNOS DE EXPANSION 1/2 X 4","UN",2),
("SHT01540","PHOENIX CONTACT STARTER KIT","UN",1),
("SHT01131","PICAPORTE HERCULES 6","UN",1),
("SHT00777","PIEDRA CONICA CONCRETO ABRACOL 5 X 2","UN",4),
("SHT00314","PIEDRA DE AFILAR","UN",1),
("SHT01732","PIEDRA DE CHISPERO","UN",2),
("SHT00598","PIEDRA DE DIAMANTE DE COPA 125 MM","UN",13),
("SHT02046","PIEDRA DE ESMERIL GRANO 36 6 X 3/4 X 1 1/4","UN",1),
("SHT02047","PIEDRA DE ESMERIL GRANO 46 6 X 3/4 X 1 1/4","UN",1),
("SHT01658","PIEDRA TIPO COPA 5 X 2 X 5/8 GRANO 36","UN",11),
("SHT00983","PIEDRA WIDIA 6X1X1 C-60","UN",3),
("SHT01173","PINTURA ANTICORRESIVA GRIS MATE","GL",4),
("SHT01520","PINTURA ANTICORROSIVA BLANCO MATE","UN",2),
("SHT00995","PINTURA ANTICORROSIVA NEGRA","GL",1),
("SHT00729","PINTURA ANTICORROSIVA VERDE ","GL",3),
("SHT00738","PINTURA ANTICORROSIVO GRIS LATINA","UN",1),
("SHT00590","PINTURA ANTICORROSIVO ROJO","UN",3),
("SHT01034","PINTURA BLANCA PARA EXTERIORES","GL",4),
("SHT01223","PINTURA CAUCHO BLANCO","GL",27),
("SHT00589","PINTURA EN SPRAY BLANCO BRILLANTE 400 ML","UN",1),
("SHT01692","PINTURA ESMALTE BLANCA","UN",7),
("SHT01693","PINTURA ESMALTE GRIS","UN",1),
("SHT02051","PINTURA LATEX RAL 7047","GL",5),
("SHT00910","PINTURA TRAFICO AMARILLO LATINA","GL",5),
("SHT00911","PINTURA TRAFICO NEGRO LATINA","GL",5),
("SHT00627","PINZA PUNTA LARGA STANLEY 6 1000 V STANLEY","UN",1),
("SHT00148","PIOLA","UN",2),
("SHT01382","PIROMETRO 60 FLUKE","UN",1),
("SHT00124","PISTOLA NEUMATICA MANDO STANLEY 1/2 ","UN",2),
("SHT01348","PISTOLA PARA SILICON INDUSTRIAL","UN",1),
("SHT00452","PISTOLA PINTAR GRAVEDAD INGCO","UN",1),
("SHT00510","PISTOLA PULVERIZADORA CON MANGUERA","UN",2),
("SHT00988","PITO TIPO PLATILLO 24V","UN",1),
("SHT01908","PLACA PORTA RESISTENCIA 1100 WATIOS 440 VOLTIOS","UN",1),
("SHT01884","PLANCHA ACERO INOXIDABLE 1220 X 2440 X 1,5 ESPESOR","UN",1),
("SHT01748","PLANCHA DE ACRILICO 1220 X 2440 X 3 MM","UN",1),
("SHT00473","PLANCHA DE ASBESTO 1/32 1,50MTR X1,50MTR","UN",1),
("SHT00868","PLATINA 1X1/8 ( 25X3MM)","UN",100),
("SHT00015","PLAYO DE PRESION 10 CURVO STANLEY","UN",3),
("SHT00087","PLAYO ELECTRICO","UN",2),
("SHT00683","PLETINA COBRE 1/8 x 1/2 172 AMP","UN",1),
("SHT01618","POLEA SPB 160 X 4 CANALES + BUJE 2517","UN",1),
("SHT00668","POLIEMPAQUE ISI 110 - 125 ","UN",4),
("SHT01022","PORTAELECTRODO 500A","UN",2),
("SHT00781","POTENCIOMETRO 10K 10 VUELTAS","UN",12),
("SHT01057","PRESOSTATO (SWITCH DE PRESIÓN)","UN",2),
("SSI00130","PRUEBAS KIT DIP 6","UN",50),
("SHT00539","PULSADOR N-A","UN",9),
("SHT00540","PULSADOR N-C","UN",1),
("SHT00788","PULSADOR NC ROJO","UN",1),
("SHT00789","PULSADOR NO VERDE","UN",1),
("SHT01272","PUNTA DE ESTRELLA AUTOPERFORANTE","UN",4),
("SHT01312","PUNTADE CINCEL 10 SURTEK","UN",1),
("SHT00381","RACHE STANLEY DE 1/2 X 10","UN",3),
("SHT01963","RACOR CODO 6 MM","UN",6),
("SHT00934","RACOR CODO 8MM X1/4 VPC","UN",8),
("SHT00846","RACOR CONEXIÓN MACHO B68 8","UN",2),
("SHT00411","RACOR M10 X 1/2","UN",2),
("SHT00410","RACOR M10 X 3/8","UN",2),
("SHT01946","RACOR RECTO 12 MM X 1/4 NPT","UN",28),
("SHT00935","RACOR RECTO 8MM X1/4 VPC","UN",11),
("SHT01947","RACOR TEE 12 MM X 1/4 NPT","UN",8),
("SHT01680","RACOR TEE 8M X 1/4","UN",5),
("SHT00270","RACOR TEE B-64 8 MM","UN",16),
("SHT01471","RACOR TIPO CODO 90 M8 x 1/4","UN",7),
("SHT00412","RACOR TIPO CODO 90° M10 X 3/8","UN",2),
("SHT01962","RACOR UNION B-62 6 MM","UN",4),
("SHT01694","RACOR UNION B-62 8MM","UN",10),
("SHT01144","RASCADOR DE NYLON EXT: 240MM, ALTO 19MM, ESP: 95MM","UN",2),
("SHT02065","RECOGEDOR DE BASURA","UN",10),
("SHT01326","RECTIFICADOR DEWALT 1/2","UN",1),
("SHT01435","REDUCTOR DE RACHE 3/4 A1/2 STANLEY ","UN",1),
("SHT01607","REFLECTOR LED START SYLVANIA 200W","UN",1),
("SHT00804","REGULADOR DE ACETILENO","UN",1),
("SHT01433","REGULADOR DE AIRE -UNIDAD DE MTTO 0-160 PSI FESTO","UN",1),
("SHT01832","RELAY 14 PIN PLANO 110 VAC","UN",1),
("SHT01321","RELAY 14 PIN PLANO 4X3A 24 VDC MY-4","UN",4),
("SHT01204","RELE 8 PINES OMRON 220V","UN",4),
("SHT01203","RELE RXM 230V AC SCHERIDER","UN",3),
("SHT01444","RELE TERMICO 12-18A LRD21 TELEMEC","UN",1),
("SHT01588","RELE TERMICO 16 -24 AMP SCHNEIDER","UN",1),
("SHT01320","RELE TERMICO 2,5 AMP NR CHINT","UN",1),
("SHT01229","RELE TERMICO 7-10 AMP","UN",1),
("SHT00912","REMACHE POP CHINO 1/8 X 1/2 UNIDAD","UN",397),
("SHT00693","REMACHE POP CHINO 5/32x 1/2","UN",320),
("SHT01217","REPARTIDOR DE CARGA 100AMP","UN",3),
("SHT01395","REPARTIDOR DE CARGA 4P 125A LEGRAND (CLAS DE COLORES)","UN",1),
("SHT01766","RESISTENCIA MEDIA LUNA 620 X 200 WATIOS 5000 VOLTIOS 460","UN",2),
("SHT01828","RESISTENCIA TIPO BANDA 120 MM X 100 MM 220 VOLTIOS","UN",1),
("SHT01909","RESISTENCIA TIPO BANDA 130 MM X 200 MM 3000 WATIOS 460 VOLTIOS","UN",2),
("SHT02017","RESISTENCIA TIPO BANDA 17 X 28 CM X 2600 W X 840 VOLTIOS","UN",1),
("SHT02015","RESISTENCIA TIPO BANDA 17 X 5 CM X 1000 W X 240 VOLTIOS","UN",1),
("SHT01906","RESISTENCIA TIPO BANDA 170 MM X 300 MM 5000 WATIOS 460 VOLTIOS","UN",2),
("SHT02016","RESISTENCIA TIPO BANDA 24,5 X 10 CM X 2200 W X 240 VOLTIOS","UN",1),
("SHT01585","RESISTENCIA TIPO BANDA 7 MM X 10,5 MM 440 VOLTIOS","UN",1),
("SHT02040","RESISTENCIA TIPO BANDA CERAMICA 12 CM X 120 CM X 5000 W X 440 VOLTIOS","UN",1),
("SHT01176","RESISTENCIA TIPO BANDA","UN",6),
("SHT01421","RESISTENCIA TIPO CARTUCHO ( 19.03 X 25CM)","UN",4),
("SHT01905","RESISTENCIA TIPO CARTUCHO 16,6 CM X 60 CM 1500 WATIOS 460 VOLTIOS","UN",4),
("SHT01810","RESISTENCIA TIPO CARTUCHO 17 MM X 400 MM 800 WATIOS 480 VOLTIOS","UN",1),
("SHT01743","RESISTENCIA TIPO CARTUCHO 19,5 X 340 1500 W 440 VOLTIOS","UN",1),
("SHT01829","RESISTENCIA TIPO CARTUCHO 20 MM X 20 CM 1000 WATIOS 220 VOLTIOS","UN",2),
("SHT01559","RESISTENCIA TIPO CARTUCHO 20 MM X 40 CM 440 VOLTIOS","UN",2),
("SHT00385","RESISTENCIA TIPO CARTUCHO 20MMX280MM 1200W","UN",1),
("SHT01907","RESISTENCIA TIPO PLACA 125 MM X 200 MM X 3,1 KW 440 VOLTIOS","UN",2),
("SHT01782","RESISTENCIA TIPO PLANA 220 MM X 220 MM WATIOS 1500 VOLTIOS 440 LADO DERECHO","UN",1),
("SHT01783","RESISTENCIA TIPO PLANA 220 MM X 220 MM WATIOS 1500 VOLTIOS 440 LADO IZQUIERDO","UN",1),
("SHT02014","RESISTENCIA TIPO PLANA 44 X 10 CM X 1700 W X 240 VOLTIOS","UN",2),
("SHT02018","RESISTENCIA TIPO TUBULAR 3/8 X 56 CM X 1000 W X 240 VOLTIOS","UN",4),
("SHT01619_1","RESORTE 96,5 X 45 X 5 MM","UN",2),
("SHT01993","RETENEDOR 105 X 75 X 13","UN",3),
("SHT01409","RETENEDOR 130X 100 X12","UN",5),
("SHT01689","RETENEDOR 52 x 35 x 10","UN",2),
("SHT02021","RETENEDOR 60 X 90 X10","UN",3),
("SHT01311","RETENEDOR 60-10-80","UN",5),
("SHT01955","RETENEDOR 85 X 65 X 10 MM","UN",2),
("SHT02005","RETENEDOR 90 X 130 X 13","UN",4),
("SHT01226","RETENEDOR 90X120X12","UN",2),
("SHT01145","RETENEDOR DE CAUCHO NITRILO EXT: 242MM ESP: 11MM, ALTO: 16,2MM","UN",2),
("SHT00306","RETENEDOR INT.205MM ESP.9MM ALTO 15MM","UN",4),
("SHT00463","RETENEDOR MED. 65X90X10","UN",22),
("SHT01158","RETENEDOR USH 110X125X9","UN",11),
("SHT01159","RETENEDOR USH 60X70X6","UN",4),
("SHT01632","RETNEDOR 75 X 95 X 12","UN",2),
("SHT01066","RIEL DIN","UN",4),
("SHT01189","RODAMIENTO 1212 C3","UN",3),
("SHT01600","RODAMIENTO 30218","UN",1),
("SHT01601","RODAMIENTO 30220","UN",1),
("SHT01557","RODAMIENTO 30318","UN",1),
("SHT01630","RODAMIENTO 32212","UN",2),
("SHT01793","RODAMIENTO 32216","UN",2),
("SHT01529","RODAMIENTO 51312","UN",2),
("SHT01510","RODAMIENTO 6002 2RS","UN",2),
("SHT01953","RODAMIENTO 6010 2RS","UN",2),
("SHT01954","RODAMIENTO 6013 2RS","UN",2),
("SHT01511","RODAMIENTO 6200 2RS","UN",2),
("SHT00188","RODAMIENTO 62042RS","UN",7),
("SHT01629","RODAMIENTO 6205 2RS","UN",1),
("SHT01957","RODAMIENTO 6207 2RS","UN",2),
("SHT01871","RODAMIENTO 6209 2RS","UN",1),
("SHT01631","RODAMIENTO 6212 2RS","UN",2),
("SHT01517","RODAMIENTO 6305 2RS","UN",2),
("SHT00187","RODAMIENTO 63072RS","UN",2),
("SHT00186","RODAMIENTO 63102RS","UN",2),
("SHT01984","RODAMIENTO CONICO 32316 J2 SKF","UN",1),
("SHT02027","RODAMIENTO F204-19 MM","UN",3),
("SHT01169","RODILLO 9¨","UN",5),
("SHT01052","ROSETON PORTAFOCOS","UN",5),
("SHT01147","ROTOMARTILLO STANLEY","UN",1),
("SHT00272","RULIMAN 1212C3 KOYO","UN",2),
("SHT00382","RULIMAN 63052RSC3 //_KOYO","UN",2),
("SHT00420","RULIMAN 63092RSC3","UN",4),
("SHT01318","SACA VINCHAS 7 STANLEY","UN",1),
("SHT01319","SANTIAGO 2 PATAS 0,4","UN",1),
("SHT00907","SANTIAGO 8 (PULG) 3 PATASTAIWAN","UN",1),
("SHT01710","SEGURO RAPIDO GH431 GALVANIZADO","UN",30),
("SHT00767","SELECTOR 2 POSICIONES","UN",3),
("SHT00733","SELECTOR 3 POSICIONES","UN",5),
("SHT00310","SELLO DE CAUCHO EXT.179MM INT.161MM ESP.9MM ALTO 7,3MM","UN",2),
("SHT01146","SELLO DE CAUCHO NITRILO EXT: 290MM ESP: 10MM, ALTO: 9,4MM","UN",1),
("SHT01711","SELLO MECANICO DE 3/4","UN",1),
("SHT01024","SENSOR FINAL DE CARRERA","UN",1),
("SHT01503","SENSOR FOTO DIFUSO C-400MM M16","UN",1),
("SHT00900","SENSOR PRDL18-7DP 10","UN",2),
("SHT01285","SERPENTINA 1/2 X 7/8 X 12  INODORO","UN",3),
("SHT00882","SIERRA CIRCULAR DEWALT 7 1/4 ","UN",1),
("SHT01960","SIERRA COPA MORSE 7/8 HSS","UN",1),
("SHT00790","SIERRA SANDFLEX 1/2 X 18 DPP","UN",5),
("SHT00509","SILICON ROJO 3 ONZ","UN",6),
("SHT00249","SISTEMA PARA FLAMA CON MANGUERA Y PULMON A GAS","UN",1),
("SHT01388","SOLDADORA LINCONL ACD 225","UN",1),
("SHT00906","SOLDADORA PTK 250A 110-220V HOBBY","UN",1),
("SHT00132","SOLDADURA 6011 - 1/8","UN",	1),
("SHT01745","SOLDADURA 6013 x 1/8","UN",450),
("SHT00184","SOLDADURA 7018-1/8 X 1KG", "UN", 1),
("SHT00213","SOLDADURA ACERO INOXIDABLE 3/32 X KILO","UN",5),
("SHT00782","SOLDADURA B84", "UN",2),
("SHT02073","SOLDADURA DE ACERO E312 X 1/8","KG",10),
("SHT00814","SOLDADURA ESTANO/BRONCE 1.5 MM 52/48% ESTANO PLOMO X ROLLO 0,5 KLG","UN",1),
("SHT00865","SOPLADOR MARCA MAKITA M4000","UN",2),
("SHT01415","SOPORTE DE TECLADO","UN",1),
("SHT00980","SPRAY ESPUMA DE ALTO PODER POLIURETANO 500ML","UN",2),
("SHT01170","STANLEY ENGRASADORA 6¨ 14 ONZAS","UN",1),
("SHT00703","STANLEY ESPATULA 4","UN",2),
("SHT00080","STANLEY JUEGO DESARMADORES PRO 10 PCS","UN",2),
("SHT00982","STANLEY MARTILLO GOMA 20 ONZ. 57-523","UN",1),
("SHT00913","STANLEY PINZA PARA SEGURO EXTERIOR RECTO 7 84-271","UN",1),
("SHT00914","STANLEY PINZA PARA SEGURO INTERIOR RECTO 7 84-273","UN",1),
("SHT00070","STANLEY PLAYO BASICO 8 84-098","UN",2),
("SHT00073","STANLEY PRENSA C 4 83-504","UN",3),
("SHT00850","STANLEY RACHET 1/2 86-404","UN",2),
("SHT00978","TABLERO METALICO 30X20X15","UN",4),
("SHT00120","TACO #8","UN",22),
("SHT00991","TACO DE SOPORTE P/GYPSUM TG-912","UN",4),
("SHT00133","TACO FISCHER F","UN",12),
("SHT01634","TACO METALICO DE GOLPE DE 1/2 X 2 CON PERNO","UN",15),
("SHT00994","TALADRO ATORN PERCUTOR INAL DEWALT 20V","UN",2),
("SHT00993","TALADRO DEWALT 1/2 650/710W","UN",1),
("SHT00624","TALADRO PECUTOR 1/2 650 W MARCA DEWALT","UN",1),
("SHT00747","TANQUE DE OXIGENO 6M3","UN",4),
("SHT00791","TAPON CARTER 22 X 1,50 MM","UN",2),
("SHT01336","TAPON HEMBRA ROSCABLE 1/2 NPT","UN",1),
("SHT01338","TAPON MACHO 1/2  NPT","UN",2),
("SHT01339","TAPON MACHO 2  NPT","UN",1),
("SHT01288","TAPON MACHO ROSCABLE 1 1/2","UN",2),
("SHT01283","TAPON MACHO ROSCABLE 3/4","UN",2),
("SHT01807","TAPONES PARA TABLERO ELECTRICO 1/2","UN",25),
("SHT01455","TEE GALVANIZADA 1","UN",1),
("SHT01041","TEE ROSCABLE 2 PVC","UN",1),
("SHT01313","TEE ROSCABLE DE 1/2 NPT","UN",2),
("SHT00886","TEE ROSCABLE P.P. 1-1/2 NPT","UN",6),
("SHT00350","TEE ROSCABLE PP 1 NPT","UN",6),
("SHT01491","TEE ROSCABLE PP 3 NPT","UN",1),
("SHT00053","TEE ROSCABLE PP 3/4 NPT","UN",2),
("SHT01056","TEFLON DE ALTA TEMPERATURA","UN",5),
("SHT00054","TEFLON INDUSTRIAL AMARILLO","UN",6),
("SHT01244","TEMPLADOR OJO DE GANCHO 1/2 X 8","UN",4),
("SHT01259","TEMPLADOR OJO DE GANCHO 3/8 X 6 ","UN",35),
("SHT01011","TERMINAL COMPRESION CABLE 2/0","UN",4),
("SHT01018","TERMINAL COMPRESION CABLE 500MCM","UN",4),
("SHT00838","TERMINAL COMPRESION T/ OJO # 4","UN",12),
("SHT00932","TERMINAL DE ALTA TEMPERATURA P/ CABLE #10","UN",7),
("SHT00922","TERMINAL DE COMPRESION P/ CABLE #6","UN",28),
("SHT00918","TERMINAL DE COMPRESION P/ CABLE #8","UN",240),
("SHT00863","TERMINAL DE COMPRESION TIPO OJO #10","UN",98),
("SHT00864","TERMINAL DE COMPRESION TIPO OJO #12","UN",74),
("SHT01112","TERMINAL DE COMPRESION TIPO OJO P/CABLE #250","UN",4),
("SHT01111","TERMINAL DE COMPRESION TIPO OJO P/CABLE #350","UN",6),
("SHT01118","TERMINAL DE COMPRESIÓN P/CABLE #10 TIPO PUNTERA","UN",73),
("SHT01117","TERMINAL DE COMPRESIÓN P/CABLE #10 TIPO UÑA","UN",69),
("SHT00923","TERMINAL TIPO OJO P/ CABLE #16","UN",50),
("SHT01695","TERMINAL TIPO OJO P/CABLE # 8","UN",100),
("SHT01889","TERMINAL TIPO U P/ CABLE # 18","UN",160),
("SHT00881","TERMINALES ALTA TEMPERATURA TIPO OJO CABLE #12","UN",185),
("SHT00113","TERMINALES DE CAÑA LARGA O CORTA #8","UN",4),
("SHT00284","TERMINALES DE CAÑA LARGA O CORTA 1/0","UN",7),
("SHT00601","TERMINALES DE COMPRESION CABLE # 2 ","UN",17),
("SHT00103","TERMINALES PARA TEMPERATURA #8","UN",100),
("SHT00569","TERMINALES TEMPERATURA #10 ","UN",17),
("SHT01772","TERMINALES TIPO OJO PARA CABLE # 8","UN",8),
("SHT01061","TERMINALES TIPO OJO PARA CABLE #18","UN",100),
("SHT00195","TERMINALES TIPO U CABLE 12 PARA TEMPERATURA","UN",111),
("SHT00196","TERMINALES TIPO U CABLE 14 PARA TEMPERATURA","UN",3),
("SHT00819","TERMOCUPLA BAYONETATIPO J 2MT EBC","UN",14),
("SHT00371","TERMOMETRO INFRAROJO","UN",1),
("SHT01209","TIJERA 10 STANLEY","UN",1),
("SHT00137","TIZA INDUSTRIAL","UN",9),
("SHT00675","TOMA CORRIENTE SIMPLE 220 VAC","UN",1),
("SHT01730","TOMA SOBREPUESTO 3P-T 32 AMPERIOS","UN",6),
("SHT00875","TOMACORRIENTE 110 V CON TAPAS","UN",5),
("SHT00225","TOMACORRIENTE CHINO SENCILLO 250V","UN",1),
("SHT00281","TOMACORRIENTE DOBLE POLAR C/PROT 15A 110V C/PLACA PLASTICA","UN",7),
("SHT00227","TOMACORRIENTE DOBLE T/AISL NARANJA 15A 110V C/TAPA","UN",4),
("SHT00107","TOMACORRIENTE POLARIZADO 110V","UN",13),
("SHT00119","TORNILLO 12 X 1","UN",25),
("SHT00716","TORNILLO AGLOMERADO 8 x 1- 1/2","UN",14),
("SHT01473","TORNILLO AVELLANADO ESTRELLA 1/4 x 25 MM","UN",100),
("SHT01472","TORNILLO AVELLANADO ESTRELLA 5,5 x 15 MM","UN",92),
("SHT01094","TORNILLO MM GALV 5X50","UN",10),
("SHT00990","TORNILLO NEGRO HILO FINO 6x1 1/4 GYPSUM","UN",6),
("SHT00134","TORNILLO TRIPA PATO NIQUELADO ","UN",181),
("SHT01231","TORQUIMETRO 600 LB 3/4","UN",1),
("SHT00125","TORQUIMETRO SURTEK 3/4 50-300 FT","UN"	,1),
("SHT00822","TRANSFORMADOR DE CORRIENTE 400-5A EBC","UN"	,1),
("SHT00939","TRUPER LIMA TRIANGULAR 6 LTP-6M","UN"	,1),
("SHT01257","TUBO DE 3/4 DE POLIBICARBONATO","UN"	,1),
("SHT01314","TUBO DE DESAGUE PLASTIDOR 50 MM - 2 ","UN"	,2),
("SHT01501","TUBO DE GRASA GRAFITADA","UN"	,3),
("SHT01331","TUBO DE PRESION ROJO PLASTIGAMA 1 1/2","UN"	,7),
("SHT00464","TUBO DESAGUE PLASTIGAMA 110 MM - 4","UN"	,1),
("SHT00860","TUBO EMT 1-1/2 X 3 MTS","UN"	,2),
("SHT00793","TUBO EMT 1/2 X 3 METROS","UN"	,8),
("SHT00979","TUBO EMT 3 3MT","UN"	,4),
("SHT01239","TUBO EMT 3/4 X 3 MTS","UN"	,10),
("SHT01197","TUBO IPAC 3x3.2mmx3m","UN"	,14),
("SHT01132","TUBO PRESION GRIS 3/4 PVC","UN"	,1),
("SHT00884","TUBO PRESION GRIS PLASTIDOR 1-1/2","UN"	,2),
("SHT00349","TUBO PRESION GRIS PLASTIGAMA 1","UN"	,1),
("SHT01075","TUBO PVC 1/2 X 6 MTS","UN"	,8),
("SHT01391","TUBOS GALVANIZADOS 1/2","UN"	,4),
("SHT01720","TUERCA DE SEGURIDAD M 14","UN"	,30),
("SHT01237","TUERCA GALV. 3/8 HG","UN"	,10),
("SHT01044","TUERCA INOX 1/2 HG","UN"	,31),
("SHT00331","TUERCA INOX 14 MM X 2,0 HG","UN"	,18),
("SHT00941","TUERCA INOX. 10 MM X 1,5 HG","UN"	,4),
("SHT01681","TUERCA INOXIDABLE M 12","UN"	,1),
("SHT01670","TUERCA INOXIDABLE M8","UN"	,28),
("SHT01469","TUERCA M 12","UN"	,166),
("SHT00707","TUERCA M4","UN"	,30),
("SHT00813","TUERCA NEGRA 1/4 HG","UN"	,35),
("SHT00712","TUERCA NEGRA 16 MM x 2 HG","UN"	,47),
("SHT00387","TUERCA NEGRA 20MM","UN"	,69),
("SHT00746","TUERCA NEGRA 5 MM X 0.8","UN"	,50),
("SHT00450","TUERCA NEGRA 5/16 HG","UN"	,12),
("SHT00950","TUERCA NEGRA 7/8 HG","UN"	,2),
("SHT00456","TUERCA NEGRA 8MM X 1.25 HG","UN"	,1),
("SHT00222","TUERCA NEGRA 9/16 ACERO","UN"	,15),
("SHT01342","TUERCA NEGRA DE 18MM","UN"	,58),
("SHT01528","TUERCA NEGRA M 10","UN"	,51),
("SHT01527","TUERCA NEGRA M 6","UN"	,16),
("SHT01124","TUERCA ORIGINAL 12 MM X 1,25 HF","UN"	,28),
("SHT00561","TUERCA PRESION  INOX 16 MM x 2,0 HG","UN"	,9),
("SHT00655","UNION BRONCE 1/2","UN"	,1),
("SHT01150","UNION DE COMPRESION CABLE #6","UN"	,2),
("SHT01012","UNION DE COMPRESION CABLE 2/0","UN"	,31),
("SHT00831","UNION DE COMPRESION CABLE 4/0","UN"	,45),
("SHT00229","UNION EMT 1/2","UN"	,12),
("SHT00976","UNION EMT 3","UN"	,5),
("SHT01329","UNION EMT 3/4","UN"	,13),
("SHT00326","UNION ROSCABLE INOX. 304 1/2 NPT","UN"	,24),
("SHT01028","UNION ROSCABLE P.P 2","UN"	,1),
("SHT00267","UNION ROSCABLE P.P. 1 NPT","UN"	,1),
("SHT01235","VALVULA CHECK 2 VERTICAL","UN"	,1),
("SHT00322","VALVULA CHECK HORIZONTAL FILTRO INOX TIPO Y 1 - 1/2","UN"	,1),
("SHT00442","VALVULA CHECK VERTICAL 1","UN"	,4),
("SHT01084","VALVULA CHECK VERTICAL INOX. 1-1/2","UN"	,2),
("SHT01513","VALVULA DE PASO BRONCE 2","UN"	,1),
("SHT01646","VALVULA DE PASO GALVANIZADA 2","UN"	,1),
("SHT01040","VALVULA PASO RAPIDO 1 1/2","UN"	,2),
("SHT00736","VALVULA PASO RAPIDO 1 METAL","UN"	,2),
("SHT00317","VALVULA PASO RAPIDO PVC CON NUDO 50MM","UN"	,1),
("SHT01102","VALVULA PASO RAPIDO PVC ROSCABLE 1-1/2","UN"	,7),
("SHT00454","VALVULA PASO RAPIDO PVC ROSCABLE 1/2","UN"	,1),
("SHT01448","VALVULA SELENOIDE 24 VOLTIOS","UN"	,1),
("SHT01414","VARIADOR DE FRECUENCIA 440 VOLT HP3F INVT","UN"	,1),
("SHT00691","VARILLA GALV 16 MM","MT"	,1),
("SHT01236","VARILLA GALV. 3/8 X METRO","UN"	,6),
("SHT00760","VARILLA GALV. DE 20MM","MT"	,1),
("SHT00312","VENTILADOR 710MM TRIFASICO 220/440 CAUDAL 8,37 m3/s potencia 3,58KW","UN"	,1),
("SHT01227","VENTILADOR PARA TABLERO 220","UN"	,3),
("SHT02010","VENTILADOR PLASTICO 28 X 28 CM 220 VOLTIOS","UN"	,1),
("SHT01303","VERNIER CALIBRADOR 6","UN"	,1),
("SHT00845","VIDRIO NEGRO PARA SOLDAR # 10","UN"	,2),
("SHT00185","VIDRIO NEGRO PARA SOLDAR #12","UN"	,11),
("SHT00390","VIDRIO TRANSPARENTE PARA SOLDAR","UN"	,4),
("SHT00051","WYPE COLOR X LIBRA","UN"	,9),
("SPP0035","ADITIVO PURGA PARA POLIEFINAS ","KG"	,100),
("SPP0018","COAGULANTE CATONICO","KG"	,225),
("SPP0002","COMBUSTIBLE DIESEL","GL",	1967),
("SPP0008","DESENGRASANTE NOVARED Q","LT"	,242),
("SPP0022","FLOCULANTE","KG"	,18),
("SPP0014","GRASA MULTIFAK EP2","UN"	,105),
("SPP0005","HILO POLY","UN"	,38),
("SPP0012","LIMPIA CARBURADOR","UN"	,1),
("SPP0029","LONA MILENIUM KAKI","MT"	,325),
("SHT01553","MALLA AC INOX MESH # 24 HILO 0,40MM 1,0MT C316","MT"	,6),
("SPP0027","MALLA AC.INOX.MESH# 40 HILO 0.23MM 1.0MT C316","UN"	,6),
("SPP0004","PALLET","UN"	,100),
("SPP0030","PASTILLAS DE CLORO","UN"	,5),
("SPP0006","PLASTICO FILM","UN"	,40),
("SPP0001","SACOS 25KG","UN"	,2500),
("SPP0011","SILICON GRIS","UN"	,3),
("SPP0003","TULAS MEDIANAS 1000 KG","UN"	,120),
("SPP0010","WD-40","UN",5);


       select count(idProducto) from producto;
       select * from material;
       
       drop view productosOrdenes;
create view productosOrdenes as
select op.idOrdenProducto,
       op.idOrden,
       op.create_at,
       op.idUser,
       op.cantidad,
       p.idProducto,
       p.nameProducto,
       p.DetallesProducto,
       u.fullname,
       p.saldo
from orden_Producto op
         inner join producto p on op.idProducto = p.idProducto
         inner join usuario u on op.idUser = u.iduser;
         
         
    drop view HorasOperadores;
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
       o.idtipoOperador,
       F.idStatus
from operador o
         inner join usuario u on o.idUsuario = u.iduser
         inner join tipoMarca tM on tM.idTipoMarca = o.idTipoMarca
         inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador
         inner join ordenFabricacion F on o.idOrdenFabricacion = F.idOrdenFabricacion
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material m2 on F.idMaterial = m2.idMaterial
         inner join turno t2 on F.idTurno = t2.idTurno;     
         
         
drop view operadores;
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
       HOE.nameTipoOperador,
       o.idStatus
from HorasOperadoresEntrada HOE
         inner join HorasOperadoresSalida HOS on HOE.idOrdenFabricacion = HOS.idOrdenFabricacion
            inner join ordenFabricacion o on HOE.idOrdenFabricacion = o.idOrdenFabricacion;
            

drop view HorasOperadores;
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
       o.create_at,
       date_format(o.create_at, "%H:%i:%s") as hora,
       o.idtipoOperador,
       F.idStatus
from operador o
         inner join usuario u on o.idUsuario = u.iduser
         inner join tipoMarca tM on tM.idTipoMarca = o.idTipoMarca
         inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador
         inner join ordenFabricacion F on o.idOrdenFabricacion = F.idOrdenFabricacion
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material m2 on F.idMaterial = m2.idMaterial
         inner join turno t2 on F.idTurno = t2.idTurno;
         
drop view HorasOperadoresEntrada;


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
        create_at,
       hora as HoraEntrada,
       idStatus
from HorasOperadores
where idTipoMarca = 1;

drop view HorasOperadoresSalida;
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
       hora as HoraSalida,
       create_at,
       idStatus
from HorasOperadores
where idTipoMarca = 2;



drop view dataOperadoresHoras;
create view dataOperadoresHoras as
select distinct HOE.idOrdenFabricacion as IdOrden,
                HOE.fullname           as NombreOperador,
                HOE.nameTipoOperador   as TipoOperador,
                HOE.HoraEntrada        as HoraEntrada,
                HOS.HoraSalida         as HoraSalida,
                HOE.nameTurno          as Turno,
                HOE.nameMaquinaria     as Maquinaria,
                HOE.nameMaterial       as Material,
                HOE.create_at
from HorasOperadoresEntrada HOE,
     HorasOperadoresSalida HOS
where HOE.iduser = HOS.iduser
  and HOE.idOrdenFabricacion = HOS.idOrdenFabricacion
  and HOE.idtipoOperador = 2;


drop view dataOperadoresHoras;
create view dataOperadoresHoras as
select distinct HOE.idOrdenFabricacion as IdOrden,
                HOE.fullname           as NombreOperador,
                HOE.nameTipoOperador   as TipoOperador,
                HOE.HoraEntrada        as HoraEntrada,
                HOS.HoraSalida         as HoraSalida,
                HOE.nameTurno          as Turno,
                HOE.nameMaquinaria     as Maquinaria,
                HOE.nameMaterial       as Material,
                date_format(HOE.create_at, '%d/%m/%Y') AS Fecha,
                HOS.idStatus,
                HOE.iduser
from HorasOperadoresEntrada HOE,
     HorasOperadoresSalida HOS
where HOE.iduser = HOS.iduser
  and HOE.idOrdenFabricacion = HOS.idOrdenFabricacion
  and HOE.idtipoOperador = 2;


CREATE VIEW horasOperadoresEntradaySalida AS
SELECT
    HOE.iduser,
    HOE.idOrdenFabricacion,
    HOE.fullname,
    HOE.nameTurno,
    HOE.nameMaterial,
    HOE.nameMaquinaria,
    HOE.nameTipoOperador,
    MAX(HOE.HoraEntrada) AS HoraEntrada,
    MAX(HOS.HoraSalida) AS HoraSalida,
    MAX(HOS.idtipoOperador) AS idtipoOperador
FROM
    HorasOperadoresEntrada AS HOE
    JOIN HorasOperadoresSalida AS HOS ON HOE.iduser = HOS.iduser AND HOE.idOrdenFabricacion = HOS.idOrdenFabricacion
GROUP BY
    HOE.iduser,
    HOE.idOrdenFabricacion;
    
    create table horasEntradaOF (
    idHoraEntradaOf int(10) not null primary key auto_increment,
    create_at          timestamp default current_timestamp,
    idUsuario int(7) not null ,
    idTipoOperador int(7) not null
);
alter table horasEntradaOF add constraint fk_idHorasUsuario foreign key (idUsuario) references usuario(iduser);
alter table horasEntradaOF add constraint fk_idTipoOperador foreign key (idTipoOperador) references tipoOperador(idTipoOperador);
alter table horasEntradaOF add column (idOrden int(10) not null );
alter table horasEntradaOF add constraint fk_idOrdenHoraE foreign key (idOrden) references ordenFabricacion(idOrdenFabricacion);

create table horasSalidaOF (
    idHoraSalidaOf int(10) not null primary key auto_increment,
    create_at timestamp default current_timestamp,
    idUsuario int(7) not null,
    idTipoOperador int(7) not null,
    idHoraEntrada int(7) not null
);
alter table horasSalidaOF add constraint fk_idHoraUsuario foreign key (idUsuario) references usuario(iduser);
alter table horasSalidaOF add constraint fk_idTipoOperadorH foreign key (idTipoOperador) references tipoOperador(idTipoOperador);
alter table horasSalidaOF add constraint fk_idHoraEntrada foreign key (idHoraEntrada) references horasEntradaOF(idHoraEntradaOf);
alter table horasSalidaOF add column (idOrden int(10) not null );
alter table horasSalidaOF add constraint fk_idOrdenHoraS foreign key (idOrden) references ordenFabricacion(idOrdenFabricacion);
    
create view HorasOperadoresOf as
select heO.create_at as HoraEntrada,
       hsO.create_at as HoraSalida,
       hsO.idUsuario,
       hsO.idOrden,
       u.fullname,
       m.nameMaquinaria,
       m2.nameMaterial,
       t.nameTurno,
       t2.nameTipoOperador,
       heO.idTipoOperador
from horasEntradaOF heO
inner join horasSalidaOF hsO on heO.idHoraEntradaOf = hsO.idHoraEntrada
inner join usuario u on u.iduser=heO.idUsuario
inner join ordenFabricacion o on o.idOrdenFabricacion = heO.idOrden
inner join maquinaria m on o.idMaquinaria = m.idMaquinaria
inner join material m2 on m2.idMaterial=o.idMaterial
inner join turno t on o.idTurno = t.idTurno
inner join tipoOperador t2 on heO.idTipoOperador = t2.idTipoOperador;


create view horasOperadoresCalcular as
SELECT IF(HOO.HoraEntrada <= HOO.HoraSalida,
    TIME_FORMAT(TIMEDIFF(HOO.HoraSalida, HOO.HoraEntrada), '%H:%i:%s'),
    TIME_FORMAT(ADDTIME(TIMEDIFF('24:00:00', HOO.HoraEntrada), HOO.HoraSalida), '%H:%i:%s')) AS TiempoTrabajado,
    TIME_FORMAT(HoraEntrada, '%H:%i:%s') as HoraEntrada,
    time_format(HoraSalida, '%H:%i:%s') as HoraSalida,
    date_format(HoraEntrada, "%d/%m/%Y") as Fecha,
    HoraEntrada as HoraCompleta,
    idUsuario,
    fullname,
    idOrden,
    nameMaquinaria,
    nameMaterial,
    nameTurno,
    nameTipoOperador,
    idTipoOperador
FROM HorasOperadoresOf HOO;

drop view datosPara;
create view datosPara as
select hP.idHorasPara,
       hP.horaInicio,
       hP.horaFinal,
       TIMEDIFF(hP.horaFinal, hP.horaInicio) as TotalPara,
       hP.comentario,
       tP.nameTipoPara,
       hP.idOrdenFabricacion,
       create_at as FechaCompleta
from horasParas hP
         inner join tipoPara tP on hP.idtipoPara = tP.idTipoPara;


#Eliminar Orden
select * from horasEntradaOF where idOrdenFabricacion= ?;
delete from horasSalidaOF where idOrdenFabricacion= ?;
delete from horasEntradaOF where idOrdenFabricacion= ?;
delete from kgMaterial where idOrdenFabricacion= ?;
delete from operador where idOrdenFabricacion= ?;
delete from horasPara where idOrdenFabricacion= ?;
delete from horasOrdenFabricacion where idOrdenFabricacion= ?;
delete from ordenFabricacion where idOrdenFabricacion= ?;




drop view dataOperadores;
create view dataOperadores as
select date_format(F.create_at, "%d/%m/%Y") as Fecha,
       F.create_at                            as FechaCompleta,
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
         inner join horasOrdenFabricacion h on h.idOrdenFabricacion = o.idOrdenFabricacion
         inner join ordenFabricacion F on o.idOrdenFabricacion = F.idOrdenFabricacion
         inner join kgMaterial kM on F.idOrdenFabricacion = kM.idOrdenFabricacion
         inner join turno t2 on F.idTurno = t2.idTurno
         inner join maquinaria m on F.idMaquinaria = m.idMaquinaria
         inner join material m2 on F.idMaterial = m2.idMaterial
         inner join tipoMarca tm on o.idTipoMarca = tm.idTipoMarca
         inner join horasOf hO on F.idOrdenFabricacion = hO.idOrdenFabricacion;


select  * from horasOrdenFabricacion;








/* ------------------------------------------- */
drop view HorasOperadoresOf;
create view HorasOperadoresOf as
select heO.create_at as HoraEntrada,
       hsO.create_at as HoraSalida,
       hsO.idUsuario,
       hsO.idOrden,
       u.fullname,
       m.nameMaquinaria,
       m2.nameMaterial,
       t.nameTurno,
       t2.nameTipoOperador,
       heO.idTipoOperador,
       o.create_at as Fecha
from horasEntradaOF heO
         inner join horasSalidaOF hsO on heO.idHoraEntradaOf = hsO.idHoraEntrada
         inner join usuario u on u.iduser=heO.idUsuario
         inner join ordenFabricacion o on o.idOrdenFabricacion = heO.idOrden
         inner join maquinaria m on o.idMaquinaria = m.idMaquinaria
         inner join material m2 on m2.idMaterial=o.idMaterial
         inner join turno t on o.idTurno = t.idTurno
         inner join tipoOperador t2 on heO.idTipoOperador = t2.idTipoOperador;


drop view horasOperadoresCalcular;
create view horasOperadoresCalcular as
SELECT IF(HOO.HoraEntrada <= HOO.HoraSalida,
          TIME_FORMAT(TIMEDIFF(HOO.HoraSalida, HOO.HoraEntrada), '%H:%i:%s'),
          TIME_FORMAT(ADDTIME(TIMEDIFF('24:00:00', HOO.HoraEntrada), HOO.HoraSalida), '%H:%i:%s')) AS TiempoTrabajado,
       TIME_FORMAT(HoraEntrada, '%H:%i:%s') as HoraEntrada,
       time_format(HoraSalida, '%H:%i:%s') as HoraSalida,
       date_format(Fecha, "%d/%m/%Y") as Fecha,
       HoraEntrada as HoraCompleta,
       idUsuario,
       fullname,
       idOrden,
       nameMaquinaria,
       nameMaterial,
       nameTurno,
       nameTipoOperador,
       idTipoOperador
FROM HorasOperadoresOf HOO;



drop view datosPara;
create view datosPara as
select hP.idHorasPara,
       hP.horaInicio,
       hP.horaFinal,
       TIMEDIFF(hP.horaFinal, hP.horaInicio) as TotalPara,
       hP.comentario,
       tP.nameTipoPara,
       hP.idOrdenFabricacion,
       o.create_at as FechaCompleta
from horasParas hP
         inner join tipoPara tP on hP.idtipoPara = tP.idTipoPara
         inner join ordenfabricacion o on o.idOrdenFabricacion= hp.idOrdenFabricacion;



select * from horasParas;
select * from ordenfabricacion;
select * from horasParas hp
inner join ordenfabricacion o on o.idOrdenFabricacion= hp.idOrdenFabricacion;
select * from material;


drop view datosof;
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
       sF.nameStatus,
       m.idMaquinaria
from ordenFabricacion o
         inner join maquinaria m on o.idMaquinaria = m.idMaquinaria
         inner join material m2 on o.idMaterial = m2.idMaterial
         inner join turno t on o.idTurno = t.idTurno
         inner join statusOF sF on o.idStatus = sF.idStatus
         inner join usuario u on o.idUser = u.iduser;


