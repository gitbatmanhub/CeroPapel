CREATE
DATABASE if not exists novared;
    use novared;

create table users
(
    id       int(11) not null,
    username varchar(16)  not null,
    password varchar(60)  not null,
    fullname varchar(100) not null
);

alter table users
    add primary key (id);


alter table users
    modify id int not null auto_increment, auto_increment = 1;

describe users;

Create table ordenesTrabajo
(
    id          int(11) not null,

    area        varchar(40) not null,
    descripcion text        not null,

    user_id     int(11),
    constraint fk_user foreign key (user_id) references users (id),
        create_at timestamp not null default current_timestamp

);


alter table ordenesTrabajo
    add primary key (id);

alter table ordenesTrabajo
    modify id int (11) not null auto_increment, auto_increment=1;


Create table ordenesTomadas
(
    id int(11) not null,

    tecnico varchar(40) not null,
    ayudante text not null,
    tipoMantenimiento text not null,
    descripcionM text not null,
    horaInicio text not null,

    user_id int(11)
   

);


alter table ordenesTomadas
    add primary key (id);

alter table ordenesTomadas
    modify id int (11) not null auto_increment, auto_increment=1;






alter table ordenesTrabajo
    add primary key (id);

alter table ordenesTrabajo
    modify id int (11) not null auto_increment, auto_increment=1;


use novared;

alter table ordenesTrabajo
	 ADD fecha DATE DEFAULT (CURDATE());

alter table ordenesTrabajo
	 ADD hora time DEFAULT (DATE_FORMAT(NOW(), "%H:%i:%S"));
use novared;
create table rolUsuarios
	(
    idRol int(2),
    nameRol varchar(30)
    
    )
select * from rolUsuarios;
insert into rolUsuarios (idRol, nameRol)
values(1, "Administrador"),
		(2, "Supervisor")
;
create table areas
(
	idAreas int(2),
    nombreAreas char(20)
)

select * from areas;

alter table areas
    add primary key (idAreas);

alter table areas
modify idAreas int(2) not null auto_increment, auto_increment=1;

create table maquinas

(
	idMaquina int(2) primary key,
    nombreMaquina char(20)
)
;
alter table maquinas
modify idMaquina int(2) not null auto_increment, auto_increment=1;
 
 
 alter table users
 add sobreMi char(200),
 add empresa char(20) default "Novared",
 add pais char(20),
 add direccion varchar(100),
 add telefono varchar(10),
 add igLink varchar(100),
 add twitterLink varchar(100),
 add inkedInLink varchar (100);
 
 
 select * from users;
 
 

 ALTER TABLE users MODIFY username varchar( 16 ) NOT NULL DEFAULT " N - N "; 
 ALTER TABLE users MODIFY password varchar( 60 ) NOT NULL DEFAULT " N - N "; 
 ALTER TABLE users MODIFY fullname varchar(100) NOT NULL DEFAULT " N - N "; 
 
 
 
 
 
UPDATE users SET sobreMi='Hola esto es un texto generico', pais='Ecuador', direccion='Vieja kennedy av Fco', telefono='0967792636', igLink='https://www.instagram.com/edwin.pdf/', twitterLink='https://twitter.com/Edwin_pdf', inkedInLink='https://www.linkedin.com/in/edwin-romero98/' WHERE id = 1;
update users set fullname="Edwin C. Romero Orellana" where id=1;
update users set sobreMi='Hola esto es un texto generico, Hola esto es un texto generico, Hola esto es un texto generico, Hola esto es un texto generico' where id=1;
 use novared;
update users set fullname="Edwin Romero" where id=1;
  
 select * from users ;
 
 alter table users
 modify username varchar(50);
 
/*
Insertar Dtaos en tabla
insert into name_Tabla (column1, column2, etc...)
values(valueColumn1, valueColumn1);
*/


/*
alter table nameTable
	 ADD columan type(length) ;


 */
 
 describe areas;
describe maquinas;

alter table maquinas 
add column id_area int(3);


alter table maquinas
add foreign key (id_area) references areas(idAreas);
/*
Agregar foreign Key 
alter table maquinas
add foreign key (id_area) references areas(idAreas);
  */
  
  describe areas;
  
  
  describe maquinas;
  
  
insert into areas (nombreAreas )
values ("Edificio"),
("Equipos Auxiliares"),
("Maquinas"),
("PTAR"),
("Garita"),
("Molinos"),
("Subestacion"),
("Montacargas"),
("Compactadora")
;
		
  select * from areas;
  
  alter table maquinas  
  modify nombreMaquina char(50);
  
  
  insert into maquinas (nombreMaquina, id_area)
  values ("Administrativo", 1),
  ("Financiero", 1),
  ("Producción", 1),
  ("Logistica/BodegaPT", 1),
  ("Compactadora", 9),
  ("Compresor JAGUAR I", 2),
  ("Compresor JAGUAR II", 2),
  ("Pelletizadora 1", 3),
  ("Pelletizadora 2", 3),
  ("Pelletizadora 3", 3),
  ("Lavado Film", 3),
  ("PET", 3),
  ("Lavado Hogar", 3),
  ("Lavado Zuncho", 3),
  ("Clasificadora de colores", 3),
  ("PTAR", 4),
  ("Garita", 5),
  ("Puerta Garita", 5),
  ("Zuncho ", 6),
  ("Hogar ", 6),
  ("Film ", 6),
  ("PET ", 6),
  ("Trituradora ", 6),
  ("Transformador Inatra 250 KVA ", 7),
  ("Transformador Inatra 750 KVA ", 7),
  ("Montacargas 1 - 2.5T ", 8),
  ("Montacargas 2 - 2.5T ", 8),
  ("Montacargas 3 - 3T", 8),
  ("Montacargas 4 - 3T ", 8);
  
  
  select * from maquinas;
  select * from areas;
  
  
  select * from maquinas, areas
  where id_area= idAreas order by idMaquina;
  





  select * from areas;
  select * from maquinas;
  
  select * from ordenestrabajo;
  
  select * from rolusuarios;
  
  describe rolusuarios;
  
  insert into rolusuarios(idRol, nameRol)
values (3, "Lider mantenimeinto"),
		(4, "Tecnico"),
		(10000, "No usuario");
	
      insert into rolusuarios(idRol, nameRol)
values (6, "Planificador")

	

        

		  
  select * from rolusuarios;
  
  alter table users
	 ADD idRol int(2);
     
     alter table rolusuarios
     add primary key (idRol);
     
     alter table users
add foreign key (idRol) references rolusuarios(idRol);
     
  select * from rolusuarios;
  select * from users;
  
/*
Modify table
 alter table users
 modify username varchar(50);

*/



   alter table users
 modify idRol int(2) default 10000;
 
 
 select * from users;
  
  
UPDATE users SET idRol= 1 WHERE id = 1;
UPDATE users SET idRol= 2 WHERE id = 3;
UPDATE users SET idRol= 3 WHERE id = 4;

  select * from users;
  
    insert into rolusuarios(idRol, nameRol)
values (5, "Lider Produccion");
  
  UPDATE users SET idRol= 2 WHERE id = 8;
  UPDATE users SET idRol= 3 WHERE id = 7;
  UPDATE users SET idRol= 5 WHERE id = 6;

  
  
  create table ordenesAprobadas
  (
	idOA int not null,
    fecha DATE DEFAULT (CURDATE()),
    hora time DEFAULT (DATE_FORMAT(NOW(), "%H:%i:%S")),
    createAt timestamp not null default current_timestamp,
    idUsuario int not null,
    idOrden int not null
  
  );
  
  alter table ordenesaprobadas
  add primary key(idOA);
  
  
alter table ordenesaprobadas
add foreign key (idOrden) references ordenestrabajo(id);


ALTER TABLE ordenesaprobadas CHANGE idUsuario idUserCreo int;


alter table ordenesaprobadas
add foreign key (idUserCreo) references ordenestrabajo(user_id);

describe ordenesaprobadas;

alter table ordenesaprobadas
add column idAprobo int;

alter table ordenesaprobadas
add foreign key (idAprobo) references users(id);


alter table ordenesaprobadas
add column comentariosSupervisor text;

alter table ordenesaprobadas
    modify idOA int not null auto_increment, auto_increment = 1;
/*
drop table statusorden;
alter table ordenestrabajo drop foreign key ordenestrabajo_ibfk_2;
*/

create table statusOrden(
	idStatus int  not null,
    nombreStatus char(30)
);

insert into statusOrden(idStatus, nombreStatus)
values (0, "Pendiente Aprobacion"),
		(1, "Aprobado"),
		(2, "Asignada"),
		(3, "Atendida"),
		(4, "Terminada"),
		(5, "Cerrada")
;

alter table statusorden
add primary key(idStatus);




alter table ordenestrabajo
add column idStatus int;

alter table ordenestrabajo
add column estadoMaquina int(1) not null ;



alter table ordenestrabajo
add foreign key (idStatus) references statusorden(idStatus);

   alter table ordenestrabajo
 modify idStatus int default 0;
use novared;

UPDATE ordenestrabajo SET idStatus= 0 where estado="Abierto";

UPDATE ordenestrabajo SET idStatus= 1 where id=3;

describe ordenesaprobadas;

use novared;
UPDATE ordenestrabajo SET idStatus= 0;

/*
Hasta aquí me quedé

SELECT ordenestrabajo.*, users.fullname 
FROM novared.ordenestrabajo
inner join users on users.id=ordenestrabajo.id
inner join statusorden on ordenestrabajo.id=statusorden.idStatus;


*/





#Para eliminar en cascada
ALTER TABLE ordenestrabajo drop foreign key fk_user;
alter table ordenestrabajo add constraint fk_user foreign key (user_id) references users (id) on delete cascade;

alter table ordenesaprobadas drop foreign key ordenesaprobadas_ibfk_2;
alter table ordenesaprobadas add constraint ordenesaprobadas_ibfk_2 foreign key (idUserCreo) references ordenestrabajo (user_id) on delete cascade;

alter table ordenesaprobadas drop foreign key ordenesaprobadas_ibfk_1;
alter table ordenesaprobadas add constraint ordenesaprobadas_ibfk_1 foreign key (idOrden) references ordenestrabajo (id) on delete cascade;


create table especialidadTecnico
( 
	idEspecialidad int(2) not null,
    nameEspecialidad char(20),
    fkIdRol int(3)
);
 
 alter table especialidadtecnico
 add primary key (idEspecialidad); 
 alter table especialidadTecnico add constraint fkEspecialidad foreign key (fkIdRol) references rolusuarios (idRol) on delete cascade;


alter table especialidadtecnico
    modify idEspecialidad int (2)  auto_increment, auto_increment=1;

insert into especialidadTecnico(idEspecialidad, nameEspecialidad, fkIdRol)
values(1, "Electrico", 4),
		(2, "Mecánico", 4),
		(3, "Soldador", 4);



  UPDATE users SET idRol= 4 WHERE id = 4;

create table tipoMantenimiento
(
    idTipoMantenimiento int(2),
    nameTipoMantenimiento char(50)
);

show tables;

alter table tipoMantenimiento
add primary key (idTipoMantenimiento);
describe tipoMantenimiento;
alter table tipoMantenimiento
    modify idTipoMantenimiento int not null auto_increment, auto_increment = 1;



insert into tipoMantenimiento(idTipoMantenimiento, nameTipoMantenimiento)
value (1, "Preventivo"),
    (2, "Correctivo"),
    (3, "Mantenimiento"),
    (4, "Mejora");

select * from tipoMantenimiento;

create table ordenesasignadas
(
    id_OrAs int(100),
    create_at timestamp not null default current_timestamp,
    fecha_create DATE DEFAULT (CURDATE()),
    hora_create time DEFAULT (DATE_FORMAT(NOW(), "%H:%i:%S")),
    idTecnico1 int(4),
    idTecnico2 int(4),
    idAyudante1 int(4),
    idAyudante2 int(4),
    tipoMantenimiento int(4),
    descripcionMantenimiento text(1000),
    fechaHoraInicio datetime,
    fechaHoraFinal datetime
);
alter table ordenesasignadas
    add primary key (id_OrAs) ;
alter table ordenesasignadas
    modify id_OrAs int not null auto_increment, auto_increment = 1;

alter table ordenesasignadas
add column idUserAsigno int(3);

alter table ordenesasignadas
add column idOrden int;



#ALTER TABLE ordenesasignadas DROP COLUMN idUserAsignó;

select * from ordenesasignadas;
describe ordenesasignadas;


alter table ordenesasignadas
add foreign key (tipoMantenimiento) references tipoMantenimiento(idTipoMantenimiento);

alter table ordenesasignadas
    add foreign key (idUserAsigno) references users(id);

alter table ordenesasignadas
    add foreign key (idOrden) references ordenestrabajo(id);


alter table ordenesasignadas drop foreign key ordenesasignadas_ibfk_1;
alter table ordenesasignadas add constraint ordenesasignadas_ibfk_1 foreign key (tipoMantenimiento) references tipoMantenimiento(idTipoMantenimiento) on delete cascade;


alter table ordenesasignadas drop foreign key ordenesasignadas_ibfk_2;
alter table ordenesasignadas add constraint ordenesasignadas_ibfk_2 foreign key (idUserAsigno) references users(id) on delete cascade;


alter table ordenesasignadas drop foreign key ordenesasignadas_ibfk_3;
alter table ordenesasignadas add constraint ordenesasignadas_ibfk_3 foreign key (idOrden) references ordenestrabajo(id) on delete cascade;

alter table ordenesasignadas add constraint ordenesasignadas_ibfk_4 foreign key (idTecnico1) references users(id) on delete cascade;
alter table ordenesasignadas add constraint ordenesasignadas_ibfk_6 foreign key (idAyudante1) references users(id) on delete cascade;
alter table ordenesasignadas add constraint ordenesasignadas_ibfk_7 foreign key (idAyudante2) references users(id) on delete cascade;
alter table ordenesasignadas add constraint ordenesasignadas_ibfk_5 foreign key (idTecnico2) references users(id) on delete cascade;


select * from statusOrden;


delete from statusOrden where idStatus=2;
delete from statusOrden where idStatus=3;

insert into statusOrden(idStatus, nombreStatus) VALUE (2, "Asignada");
select * from ordenesasignadas;

select * from ordenestrabajo;
describe ordenestrabajo;
select * from statusOrden;

delete from ordenesasignadas;

select * from users where idRol= 4;
  UPDATE users SET idRol= 4 WHERE id = 9;



select * from rolusuarios;

drop table estadoMaquina;

create table estadoMaquina(
    idEstadoMaquina int not null,
    nameEstado char(50) not null
);

alter table estadoMaquina
add primary key (idEstadoMaquina);

select * from estadoMaquina;
insert into estadoMaquina(idEstadoMaquina, nameEstado) VALUE (1, "Operativa"), (2,"Parada");

describe estadoMaquina;

select * from ordenestrabajo;




select * from statusorden;





select * from ordenesTomadas;
describe ordenesTomadas;

drop table ordenesTomadas;

create table ordenesatendidas
(
    id int(11) not null,
    user_id int(11) not null,
    date_atendida timestamp not null default current_timestamp,
    comentarios text(500)



);


alter table ordenesatendidas
    add primary key (id);

alter table ordenesatendidas
    modify id int (11) not null auto_increment, auto_increment=1;


alter table ordenesatendidas
add foreign key (user_id) references users(id);

alter table ordenesatendidas
change comentarios comentariosTecnico text(500);

alter table ordenesatendidas
add column id_orden int(11);


alter table ordenesatendidas
add foreign key (id_orden) references ordenestrabajo(id);

describe users;


select * from ordenestrabajo;
select * from statusorden;
select * from estadoMaquina;

ALTER TABLE ordenestrabajo add foreign key (estadoMaquina) references estadoMaquina(idEstadoMaquina);
ALTER TABLE ordenestrabajo drop foreign key ordenestrabajo_ibfk_3;

alter table ordenestrabajo add constraint estadoMaquina foreign key (estadoMaquina) references estadoMaquina(idEstadoMaquina)  on update cascade;
alter table ordenestrabajo add constraint idStatus foreign key (idStatus) references statusorden(idStatus)  on update cascade;


select * from ordenesasignadas;
describe ordenesasignadas;

ALTER TABLE ordenesasignadas drop foreign key ordenesasignadas_ibfk_11;
alter table ordenesasignadas add constraint idOrden foreign key (idOrden) references ordenestrabajo(id)  on delete cascade;


alter table ordenestrabajo drop foreign key idStatus;
alter table ordenestrabajo drop foreign key ordenestrabajo_ibfk_1;




select * from statusorden;





SELECT *  from ordenesatendidas where user_id=10;


alter table ordenesatendidas drop foreign key ordenesatendidas_ibfk_2;

alter table ordenesatendidas add constraint ordenesatendidas_ibfk_2 foreign key (id_orden) references ordenestrabajo(id)  on delete cascade;

use novared;

create table probe
(
    idProbe int(100) primary key auto_increment,
    nameTecnico varchar(100),
    apellidoTecnico varchar(100)

);

insert into probe ( nameTecnico, apellidoTecnico)
value ( "Holaa", "Hola3");

select * from probe;



INSERT into probe (nameTecnico, apellidoTecnico)
    value ('Edwin', 'romero');
select * from probe;

INSERT probe (nameTecnico, apellidoTecnico) values (`nameTecnico` = 'Edwin', 'Jonathan');


INSERT probe (nameTecnico, apellidoTecnico) values (`nameTecnico` = 'Edwin', 'Jonathan'), (`apellidoTecnico` = 'Romero', 'Sananiego');

 INSERT probe (nameTecnico, apellidoTecnico) values ('Edwin', 'Romero');
select * from probe;