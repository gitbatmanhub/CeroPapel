const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, isNotLoggedIn, permissions} = require('../lib/auth');
const assert = require("assert");


//=======================================================Home

router.get('/', isLoggedIn, async (req, res) => {
    const users = await pool.query('SELECT * from usuario', [req.user.rolusuario]);
    const idRol = ([req.user.rolusuario][0]);



    switch (idRol) {
        //Andres
        case 2:
            const idUserLider=([req.user.iduser][0])
            const ordenesPropias = await pool.query('select ordenTrabajo.idOrdenTrabajo, s.avanceStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina,  e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idUsuario=?;', [idUserLider]);
            const ordenesPorAsignar = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idStatus=1;');
            const ordenesAceptadas = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idStatus=2;');
            res.render('ordenes/liderMantenimiento/listaOrdenLM', {ordenesPropias, ordenesPorAsignar,ordenesAceptadas});
            break;
        //Tecnicos
        case 4:
            //const idUser = req.user.id;
            const idUserTecnico=([req.user.iduser][0])
            const ordenesPropiasTecnico = await pool.query('select ordenTrabajo.idOrdenTrabajo, ordenTrabajo.descripcion, a.nameArea, m.nameMaquina,  e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea = a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join ordentrabajo o on ordenTrabajo.idUsuario = o.idUsuario  and o.idUsuario=?;', [idUserTecnico]);
            //console.log(ordenesPropiasTecnico);

            res.render('ordenes/tecnico/listaOrdenT', {
                ordenesPropiasTecnico
            });
            break;
        case 1:
            res.send("Eres Admin");
            break;
        default:
            res.send("No tienes asignado un rol");
            break;
    }


});
//====================================================


//======================================= Agregar Orden
router.get('/agregarOrden', isLoggedIn, async (req, res) => {
    var area = await pool.query('select * from area');
    var maquina = await pool.query('select * from maquina');
    var prioridad = await pool.query('select * from prioridad');
    var estadoMaquina = await pool.query('select * from estadoMaquina');
    res.render('ordenes/agregarorden', {area, maquina, prioridad, estadoMaquina});

});


//====================================Recibir Datos de la Orden
router.post('/agregarOrden', isLoggedIn, async (req, res) => {
    console.log(req.body);

    const {area, descripcion, prioridad, maquina, estadoMaquina, idStatus} = req.body;

    const newOrden = {
        idArea: area,
        idMaquina: maquina,
        descripcion,
        idPrioridad: prioridad,
        estadoMaquina,
        idUsuario: req.user.iduser,
        idStatus

    };

   // console.log(newOrden);

    await pool.query('INSERT INTO ordenTrabajo set ?', [newOrden]);

    req.flash('success', 'Orden agregada correctamente');
    res.redirect('/orden');
});
//=========================================================


//=============================================Borrar Ordenes
router.get('/delete/:id', async (req, res) => {
    const {id} = req.params;

    await pool.query('DELETE FROM ordenTrabajo where idOrdenTrabajo=?', [id]);
    req.flash('error', 'Orden eliminada correctamente');
    res.redirect('/orden');
});
//=========================================================


//=============================================Editar Ordenes
router.get('/edit/:id', isLoggedIn, async (req, res) => {
    const {id} = req.params;
    const ordenes = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idOrdenTrabajo=?;', [req.params.id]);
    var area = await pool.query('select * from area');
    var maquina = await pool.query('select * from maquina');
    var prioridad = await pool.query('select * from prioridad');
    var estadoMaquina = await pool.query('select * from estadoMaquina');
    //console.log(ordenes)
    res.render('ordenes/edit', {
        orden: ordenes[0],
        idArea: area,
        idMaquina: maquina,
        idPrioridad: prioridad,
        idEstadoMaquina: estadoMaquina
    });
});


router.post('/edit/:id', async (req, res) => {

    const {id} = req.params;
    console.log(id);
    console.log(req.body);
    const {area, maquina, descripcion, prioridad, estadoMaquina} = req.body;
    const newOrden = {
        idArea: area,
        idMaquina: maquina,
        descripcion,
        idPrioridad: prioridad,
        estadoMaquina:estadoMaquina
    }


    await pool.query('UPDATE ordenTrabajo set ? WHERE idOrdenTrabajo = ?', [newOrden, id]);
    req.flash('success', 'Orden actualizada correctamente');
    res.redirect('/orden');
})



//================================================


//=============================================Ver Ordenes
router.get('/view/:id', isLoggedIn, async (req, res) => {

    const ordenesVista = await pool.query('select ordenTrabajo.idOrdenTrabajo, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on m.idArea = a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idOrdenTrabajo=?', [req.params.id]);
    console.log(ordenesVista);
    res.render('ordenes/view', {orden:ordenesVista[0]});
});
//================================================


//=============================================Asignar Ordenes
/*
router.get('/assign/:id', isLoggedIn, async (req, res) => {
    const {id} = req.params;
    const ordenes = await pool.query('SELECT ordenestrabajo.*, users.fullname  FROM novared.ordenestrabajo, novared.users where ordenestrabajo.user_id = users.id AND ordenestrabajo.idStatus=0', [req.user.id]);
    const fechas = await pool.query('select date_format(ordenestrabajo.fecha, "%Y-%m-%d") as fecha from ordenestrabajo where ordenestrabajo.id =?', [id]);
    const datosTecnicos = await pool.query('select fullname, id from users where idRol=4');
    const tipoMantenimientos = await pool.query('select * from tipoMantenimiento;');

    res.render('ordenes/liderMantenimiento/assign', {
        orden: ordenes[0],
        fecha: fechas[0],
        datos: datosTecnicos,
        tipos: tipoMantenimientos
    });

});
//================================================


 */

//=============================================Ver Ordenes Tecnicos
router.get('/review/:id', isLoggedIn, async (req, res) => {
    const {id} = req.params;
    const ordenes = await pool.query('select ordenesasignadas.*, ot.*, u.fullname from novared.ordenesasignadas inner join ordenestrabajo ot on ordenesasignadas.idOrden = ot.id inner join users u on ot.user_id = u.id where idOrden=?;', [id]);

    const fechas = await pool.query('select date_format(ordenestrabajo.fecha, "%Y-%m-%d") as fecha from ordenestrabajo where ordenestrabajo.id =?', [id]);
    const ayudante1 = await pool.query('SELECT fullname as ayudante1 FROM novared.ordenesasignadas inner join users u on ordenesasignadas.idAyudante1 = u.id where idOrden=?', [id]);
    const ayudante2 = await pool.query('SELECT fullname as ayudante2 FROM novared.ordenesasignadas inner join users u on ordenesasignadas.idAyudante2 = u.id where idOrden=?', [id]);
    const tecnico1 = await pool.query('SELECT fullname as tecnico1 FROM novared.ordenesasignadas inner join users u on ordenesasignadas.idTecnico1 = u.id where idOrden=?', [id]);
    const tecnico2 = await pool.query('SELECT fullname as tecnico2 FROM novared.ordenesasignadas inner join users u on ordenesasignadas.idTecnico2 = u.id where idOrden=?', [id]);
    const datosAdicionales = await pool.query('select nameTipoMantenimiento ,descripcionMantenimiento, date_format(ordenesasignadas.fechaHoraInicio, "%Y-%m-%d") as fechaInicio, date_format(ordenesasignadas.fechaHoraInicio, "%H:%m") as horaInicio,date_format(ordenesasignadas.fechaHoraFinal, "%H:%m") as horaFinal , date_format(ordenesasignadas.fechaHoraFinal, "%Y-%m-%d") as fechaFinal from novared.ordenesasignadas inner join tipomantenimiento t on ordenesasignadas.tipoMantenimiento = t.idTipoMantenimiento where idOrden=?;', [id]);

    res.render('ordenes/tecnico/viewT', {
        orden: ordenes[0],
        fecha: fechas[0],
        ayudante1: ayudante1[0],
        ayudante2: ayudante2[0],
        tecnico1: tecnico1[0],
        tecnico2: tecnico2[0],
        datosAdicionales: datosAdicionales[0]


    });

});
//================================================


//============================================== Asignar Ordenes
router.post('/assign/:id', isLoggedIn, async (req, res) => {
    const {
        idTecnico1,
        idTecnico2,
        idAyudante1,
        idAyudante2,
        tipoMantenimiento,
        descripcionMantenimiento,
        fechaHoraInicio,
        fechaHoraFinal,
        idOrden
    } = req.body;
    const newOrden = {
        idTecnico1,
        idTecnico2,
        idAyudante1,
        idAyudante2,
        tipoMantenimiento,
        descripcionMantenimiento,
        fechaHoraInicio,
        fechaHoraFinal,
        idUserAsigno: req.user.id,
        idOrden

    };
    await pool.query('INSERT INTO ordenesasignadas set ?', [newOrden]);
    await pool.query('UPDATE ordenestrabajo SET idStatus=2 WHERE id = ?', [newOrden.idOrden]);
    req.flash('success', 'Orden Asignada correctamente');
    res.redirect('/orden');


});
//================================================


//============================================== Aprobar Ordenes
router.post('/view/:id', isLoggedIn, async (req, res) => {
    const {idOrden, idUserCreo, comentariosSupervisor} = req.body;
    const newOrdenAprobada = {
        idOrden,
        idUserCreo,
        idAprobo: req.user.id,
        comentariosSupervisor
    };

   // await pool.query('INSERT INTO ordenesaprobadas set ?', [newOrdenAprobada]);
    //await pool.query('UPDATE ordenestrabajo SET idStatus=1 WHERE id = ?', [idOrden]);
    req.flash('success', 'Orden Aprobada correctamente');
    res.redirect('/orden');


});
//=======================================================

//=============================================== Vista Ordenes Tecnicos
router.post('/viewT/:id', isLoggedIn, async (req, res) => {

    const {comentariosTecnico, id_orden} = req.body;
    const newOrdenAtendida = {
        user_id: req.user.id,
        comentariosTecnico,
        id_orden
    };


    await pool.query('INSERT INTO ordenesatendidas set ?', [newOrdenAtendida]);
    await pool.query('UPDATE ordenestrabajo SET idStatus=3 WHERE id = ?', [newOrdenAtendida.id_orden]);
    req.flash('success', 'Orden atendida correctamente');


    res.redirect('/orden');


});
//=======================================================


router.post('/accept/:id', isLoggedIn, async (req, res)=>{
    const {orden, status, tipoMantenimiento}=req.body;
    const data=
        {
            idOrden: orden,
            idStatus: status,
            idTipoMantenimiento: tipoMantenimiento,
            idUsuario: req.user.iduser

        };
        await pool.query('INSERT INTO orden_Status set ?', [data]);
        await pool.query('UPDATE ordenTrabajo SET idStatus=2 WHERE idOrdenTrabajo = ?', [orden]);

    res.redirect('/orden');
})


router.get('/probe', isLoggedIn, async (req, res) => {
    const {id} = req.params;
    res.render('ordenes/probe');
});


router.post('/probe/', isLoggedIn, async (req, res) => {
    const obj = Object.assign({}, req.body)
    const data = {nombres, apellidos} = obj;


    for (let i = 0; i < data.nombres.length; i++) {
        const newProbeName = data.nombres[i]
        const newProbeApellido = data.apellidos[i]

        console.log(newProbeName, newProbeApellido);


        //await pool.query('INSERT probe (nameTecnico, apellidoTecnico) values (?, ?)', [newProbeName, newProbeApellido]);

        // pocas cantidades de usuarios
    }
    req.flash('success', 'Nombre y apellidos');


    res.redirect('/orden/probe');


});


router.get('/suministro', async (req, res)=>{
    res.render('ordenes/liderMantenimiento/assign/suministros');
});

router.get('/tecnico/:id', async (req, res)=>{
    console.log(req.body);
    const tecnicos= await pool.query('select u.fullname, e.nameEspecialidad, u.iduser from tecnico inner join usuario u on tecnico.idUser = u.iduser inner join especialidadtecnico e on tecnico.idEspecialidad = e.idEspecialidad where e.idEspecialidad !=4');

    //console.log(tecnicos);
    res.render('ordenes/liderMantenimiento/assign/tecnicos',
        {
            tecnico: tecnicos
        });




});


router.post('/tecnico', (req, res )=>{
    console.log(req.body);
    res.redirect('/orden/')
})




module.exports = router;