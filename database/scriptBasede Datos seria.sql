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
    nameRol varchar(15)
    
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
  ("Compresor JAGUAR II", 3),
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
  where id_area= idAreas order by idMaquina
  
  
delete from maquinas
where idMaquina=38;

  select * from maquinas;