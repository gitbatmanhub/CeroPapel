CREATE
DATABASE novared;
    use
novared;
--users table

create table users
(
    id       int(11) not null,
    username varchar(16)  not null,
    password varchar(60)  not null,
    fullname varchar(100) not null,

)

alter table users
    add primary key (id);


alter table users
    modify id int not null auto_increment, auto_increment = 1;

describe users;

--ORDENES table
Create table ordenesTrabajo
(
    id          int(11) not null,

    area        varchar(40) not null,
    descripcion text        not null,

    user_id     int(11),
    constraint fk_user foreign key (user_id) references users (id)
        create_at timestamp not null default current_timestamp,

);


alter table ordenesTrabajo
    add primary key (id);

alter table ordenesTrabajo
    modify id int (11) not null auto_increment, auto_increment=1;


--Asignación table
Create table ordenesTomadas
(
    id int(11) not null,

    tecnico varchar(40) not null,
    ayudante text not null,
    tipoMantenimiento text not null,
    descripcionM text not null,
    horaInicio text not null,
    horaInicio text not null,

    user_id int(11),
    constraint fk_user foreign key (user_id) references users (id)
        create_at timestamp not null default current_timestamp,

);


alter table ordenesTrabajo
    add primary key (id);

alter table ordenesTrabajo
    modify id int (11) not null auto_increment, auto_increment=1;


alter table ordenesTrabajo
modify create_at smalldatetime


/*
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





 */