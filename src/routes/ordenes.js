const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions} = require('../lib/auth');



//=======================================================Home
/*
router.get('/orden', isLoggedIn, async (req, res) => {
    const users = await pool.query('SELECT * from usuario', [req.user.rolusuario]);
    const idRol = ([req.user.rolusuario][0]);


    switch (idRol) {
        //Andres
        case 2:
            const idUserLider = ([req.user.iduser][0])
            const ordenesPropias = await pool.query('select ordenTrabajo.idOrdenTrabajo, s.avanceStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina,  e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idUsuario=?;', [idUserLider]);
            const ordenesPorAsignar = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idStatus=1;');
            const ordenesAceptadas = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idStatus=2;');

            res.render('ordenes/liderMantenimiento/listaOrdenLM', {
                ordenesPropias,
                ordenesPorAsignar,
                ordenesAceptadas
            });
            break;
        //Tecnicos
        case 4:
            //const idUser = req.user.id;
            const idUserTecnico = ([req.user.iduser][0])
            const ordenesPropiasTecnico = await pool.query('select ordenTrabajo.idOrdenTrabajo, s.avanceStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina,  e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idUsuario=?;', [idUserTecnico]);
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
*/



//====================================================
router.get('/misordenes', isLoggedIn, async (req, res)=>{
    //console.log(req.user)
    const idUser = ([req.user.iduser][0]);
    //console.log(req.user.rolusuario)
    const misOrdenes = await pool.query('select ordenTrabajo.idOrdenTrabajo, s.avanceStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina,  e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idUsuario=?', [idUser]);
    const contadorMisOrdenes = await pool.query('select count(*) from ordentrabajo where idUsuario=2')
        //console.log(misOrdenes);
    //console.log(contadorMisOrdenes)
    res.render('ordenes/misordenes', {misOrdenes, contadorMisOrdenes})

})


router.get('/ordenesporaceptar', isLoggedIn, permissions, async (req, res)=>{
    //console.log(req.user)
    //const idUser = ([req.user.iduser][0]);
    //console.log()
    const ordenesPorAceptar = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idStatus=1;');
    //const contadorMisOrdenes = await pool.query('select count(*) from ordentrabajo where idUsuario=2')
    //console.log(misOrdenes);
    //console.log(ordenesPorAceptar);
    res.render('ordenes/liderMantenimiento/ordenesPA', {ordenesPorAceptar});

})

router.get('/ordenesaprobadas', isLoggedIn, permissions, async (req, res)=>{
    //console.log(req.user)
    //const idUser = ([req.user.iduser][0]);
    //console.log()
    const ordenesAceptadas = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idStatus=2;');
    //const contadorMisOrdenes = await pool.query('select count(*) from ordentrabajo where idUsuario=2')
    //console.log(misOrdenes);
    //console.log(ordenesAceptadas);
    res.render('ordenes/liderMantenimiento/ordenesAprobadas', {ordenesAceptadas})

})


router.get('/ordenesasignadas', isLoggedIn, permissions, async (req, res)=>{
    const idUser = ([req.user.iduser][0]);
    const ordenesPorAceptar = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idStatus=3 or ordenTrabajo.idStatus=4;');
    //console.log(ordenesPorAceptar);
    res.render('ordenes/lidermantenimiento/asignadas', {ordenesPorAceptar});
})



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
    //console.log(req.body);

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
    res.redirect('/misordenes');
});
//=========================================================


//=============================================Borrar Ordenes
router.get('/delete/:id', isLoggedIn, permissions, async (req, res) => {
    const {id} = req.params;

    await pool.query('DELETE FROM ordenTrabajo where idOrdenTrabajo=?', [id]);
    req.flash('error', 'Orden eliminada correctamente');
    res.redirect('/misordenes');
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


router.post('/edit/:id', isLoggedIn, async (req, res) => {

    const {id} = req.params;
    //console.log(id);
    //console.log(req.body);
    const {area, maquina, descripcion, prioridad, estadoMaquina} = req.body;
    const newOrden = {
        idArea: area,
        idMaquina: maquina,
        descripcion,
        idPrioridad: prioridad,
        estadoMaquina: estadoMaquina
    }


    await pool.query('UPDATE ordenTrabajo set ? WHERE idOrdenTrabajo = ?', [newOrden, id]);
    req.flash('success', 'Orden actualizada correctamente');
    res.redirect('/misordenes');
})


//================================================


//=============================================Ver Ordenes
router.get('/view/:id', isLoggedIn, async (req, res) => {
    const ordenesVista = await pool.query('select ordenTrabajo.idOrdenTrabajo, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on m.idArea = a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idOrdenTrabajo=?', [req.params.id]);
    //console.log(ordenesVista);
    res.render('ordenes/view', {orden: ordenesVista[0]});
});
//================================================


//=============================================Asignar Ordenes

router.get('/details/:id', isLoggedIn, async (req, res) => {
    //console.log(req.params);
    const idOrden=req.params.id;
    //console.log(idOrden)
    const everDatos = await pool.query('select * from TodosDatos where idOrdenTrabajo=?', [idOrden]);
    const tecnicosOrden= await pool.query('select * from tecnicosOrden where idOrden = ? group by fullname;', [idOrden]);
    const statuS = await pool.query('select * from ordenStatusDetails where idOrden=? order by AvanceStatus;', [idOrden])
    const externo = await pool.query('select * from externo where idOrden=?;', [idOrden])
    //console.log(datosStatus)
    res.render('ordenes/liderMantenimiento/details', {datos: everDatos[0],statuS, tecnicosOrden, externo: externo[0]});

});


router.post('/accept/:id', isLoggedIn, permissions, async (req, res) => {
    const {orden, status, tipoMantenimiento} = req.body;
    const data =
        {
            idOrden: orden,
            idStatus: status,
            idTipoMantenimiento: tipoMantenimiento,
            idUsuario: req.user.iduser

        };
    await pool.query('INSERT INTO orden_Status set ?', [data]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=2 WHERE idOrdenTrabajo = ?', [orden]);

    res.redirect('/ordenesaprobadas');
})


router.get('/probe', isLoggedIn,  async (req, res) => {
    const {id} = req.params;
    res.render('ordenes/probe');
});


router.post('/probe/', isLoggedIn, async (req, res) => {
    //console.log(req.body);
    const obj = Object.assign({}, req.body)
    const data = {nombres, apellidos} = obj;


    for (let i = 0; i < data.nombres.length; i++) {
        const newProbeName = data.nombres[i]
        const newProbeApellido = data.apellidos[i]

    }
    req.flash('success', 'Nombre y apellidos');
    res.redirect('/orden/probe');


});


router.get('/suministro/:id', isLoggedIn, permissions, async (req, res) => {
    res.render('ordenes/liderMantenimiento/assign/suministros');
});

router.get('/tecnico/:id', isLoggedIn, permissions, async (req, res) => {
    //console.log([req.user.iduser][0]);
    const id = req.params.id;
    const tecnicos = await pool.query('select tecnico.idUser, u.fullname, tecnico.idEspecialidad, e.nameEspecialidad from tecnico inner join usuario u on tecnico.idUser = u.iduser inner join especialidadtecnico e on tecnico.idEspecialidad = e.idEspecialidad');
    const ordenes = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idOrdenTrabajo=?;', [id]);
    const tipoMantenimiento = await pool.query('select * from tipomantenimiento')
    //console.log(tecnicos);
    res.render('ordenes/liderMantenimiento/assign/tecnicos',
        {
            tecnico: tecnicos,
            ordenes,
            tipoMantenimiento
        });


});

router.post('/tecnico/:id', isLoggedIn, permissions, async (req, res) => {
    const userId = [req.user.iduser][0];
    const idOrden = req.params.id;
    //console.log(userId)
    const objo = Object.assign({}, req.body);
    //console.log(objo);
    const exmaple = {idTecnico, fechaInicioPre, fechaFinalPre, tipoMantenimiento, descripcionTrabajo, idStatus} = objo;
    //console.log(comentario);
    for (let i = 0; i < exmaple.idTecnico.length; i++) {
        const idTecnico = exmaple.idTecnico[i];
        //Inserto en tabla orden_Trabajador los id de los tecnicos junto a los de la orden
        await pool.query('INSERT orden_Trabajador (idOrden, idTecnico) values (?, ?);', [idOrden, idTecnico]);
        //
        await pool.query('insert orden_status (idStatus, idOrden, idTipoMantenimiento, idUsuario,  comentariosLider) values (?,?,?,?,?)', [idStatus, idOrden, tipoMantenimiento, userId ,descripcionTrabajo]);
        await pool.query('update orden_status set fechaFinal=?, fechaInicio=?,  comentariosLider=? where idOrden=?;', [fechaFinalPre, fechaInicioPre, descripcionTrabajo, idOrden]);
        await pool.query('UPDATE ordenTrabajo SET idStatus=3 WHERE idOrdenTrabajo = ?', [idOrden]);
    }




    res.redirect('/ordenesasignadas')
})


router.get('/trabajoexterno/:id', isLoggedIn, permissions, async (req, res) => {
    const maquina = await pool.query('select * from maquina');
    const id = req.params.id;
    const ordenes = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idOrdenTrabajo=?;', [id]);
    const proveedor = await pool.query('select * from proveedor');

    //console.log(maquina)
    res.render('ordenes/liderMantenimiento/assign/trabajoexterno', {maquina, proveedor, ordenes});
    //console.log(req.body);
})

router.post('/trabajoexterno/:id', isLoggedIn, permissions, async (req, res) => {
    const userId = [req.user.iduser][0];


    const {proveedor, fechaInicioTE, fechaFinalTE, descripcionTrabajo, tipoMantenimiento} = req.body;
    const trabajoExterno =
        {
            idProveedor: proveedor,
            fechaInicioTrabajo: fechaInicioTE,
            fechaFinalTrabajo: fechaFinalTE,
            descripcionTrabajo,
            //idStatus:4,
            id_tipoMantenimiento: tipoMantenimiento,
            idOrdenTrabajo: req.params.id

        }
    await pool.query('INSERT orden_status (idStatus, idOrden, idTipoMantenimiento, idUsuario,  comentariosLider, fechaInicio, fechaFinal) values (5,?,?,?,?, ?, ?);', [ req.params.id,4,userId,descripcionTrabajo, fechaInicioTE, fechaFinalTE]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=5 WHERE idOrdenTrabajo = ?', [req.params.id]);
    await pool.query('UPDATE orden_status SET idProveedor=? WHERE idOrden = ?;', [trabajoExterno.idProveedor, req.params.id]);
    await pool.query('INSERT INTO proveedor_orden set ?', [trabajoExterno]);

    res.redirect('/porrevisar');
})


router.get('/tecnicoexterno/:id', isLoggedIn, permissions, async (req, res) =>{
    const id = req.params.id;
    const ordenes = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idOrdenTrabajo=?;', [id]);
    const tecnicos = await pool.query('select tecnico.idUser, u.fullname, tecnico.idEspecialidad, e.nameEspecialidad from tecnico inner join usuario u on tecnico.idUser = u.iduser inner join especialidadtecnico e on tecnico.idEspecialidad = e.idEspecialidad');
    const tipoMantenimiento = await pool.query('select * from tipomantenimiento')
    res.render('ordenes/liderMantenimiento/assign/tecnicoExterno', {ordenes, tecnico:tecnicos, tipoMantenimiento});
})
router.post('/tecnicoexterno/:id', isLoggedIn, permissions, async (req, res) =>{
    const idOrden = req.params.id;
    const objo = Object.assign({}, req.body);
    const exmaple = {idTecnico} = objo;
    for (let i = 0; i < exmaple.idTecnico.length; i++) {
        const idTecnico = exmaple.idTecnico[i];
        await pool.query('INSERT orden_Trabajador (idOrden, idTecnico) values (?, ?);', [idOrden, idTecnico]);
    }
    res.redirect('/ordenesasignadas/');
})


router.get('/ordenesatender', isLoggedIn, async (req, res)=>{

    const idUser = ([req.user.iduser][0]);
    const tecnicosDatosOrden = await pool.query('select * from bddnova.tecnicosDatosOrden where iduser=? and idStatus=3 group by idOrden;', [idUser]);
    res.render('ordenes/tecnico/ordenesatender', {tecnicosDatosOrden})
});


router.get('/datosordent/:id', isLoggedIn  ,async(req, res)=>{
    const idOrden=req.params.id;
    //console.log(idOrden)
    const datosOrden = await pool.query('select * from TodosDatos where idOrdenTrabajo=?', [idOrden]);
    const tecnicosOrden= await pool.query('select * from tecnicosOrden where idOrden = ? group by fullname;', [idOrden]);
    const externo = await pool.query('select * from externo where idOrden=? and idStatus=3;', [idOrden])
    res.render('ordenes/tecnico/detailsTecnico', {datos:datosOrden[0], tecnicosOrden, externo: externo[0]})
} );


router.post('/attendTecnico', isLoggedIn, async (req, res)=>{
    const {orden, status, tipoMantenimiento} = req.body;
    const data =
        {
            idOrden: orden,
            idStatus: status,
            idTipoMantenimiento: tipoMantenimiento,
            idUsuario: req.user.iduser
        };

    await pool.query('INSERT INTO orden_Status set ?', [data]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=4 WHERE idOrdenTrabajo = ?', [orden]);
    res.redirect('/ordenesatendidasT')
})

router.get('/ordenesatendidasT', isLoggedIn, async (req, res)=>{
    const idUser = ([req.user.iduser][0]);
    const tecnicosDatosOrdenAtendida = await pool.query('select * from bddnova.tecnicosDatosOrden where iduser=? and idStatus=4 group by idOrden;', [idUser]);
    res.render('ordenes/tecnico/ordenesatendidas', {tecnicosDatosOrdenAtendida});
});




router.post('/finishTecnico', isLoggedIn, async (req, res)=>{
    const {orden, status, tipoMantenimiento, comentarioTecnico} = req.body;
    const data =
        {
            idOrden: orden,
            idStatus: status,
            idTipoMantenimiento: tipoMantenimiento,
            idUsuario: req.user.iduser,
            comentariosTecnico: comentarioTecnico
        };
    await pool.query('INSERT INTO orden_Status set ?', [data]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=5 WHERE idOrdenTrabajo = ?', [orden]);


    console.log(data);


    res.redirect('/ordenesatendidasT')
})


router.get('/porrevisar', isLoggedIn, async (req, res)=>{
    const tecnicosDatosOrden = await pool.query('select * from bddnova.tecnicosDatosOrden where idStatus=5 group by idOrden;');
    res.render('ordenes/liderMantenimiento/ordenesporrevisar', {tecnicosDatosOrden})
})

router.post('/finishLiderplanificador', isLoggedIn, async (req, res)=>{
    const {orden, status, tipoMantenimiento, comentarioLider} = req.body;
    const data =
        {
            idOrden: orden,
            idStatus: status,
            idTipoMantenimiento: tipoMantenimiento,
            idUsuario: req.user.iduser,
            comentariosLider: comentarioLider
        };

    await pool.query('INSERT INTO orden_Status set ?', [data]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=6 WHERE idOrdenTrabajo = ?', [orden]);


    res.redirect('/ordenesatendidasT')
})

router.get('/cerradas', isLoggedIn, permissions, async (req, res)=>{
    const tecnicosDatosOrden = await pool.query('select * from bddnova.tecnicosDatosOrden where idStatus=6 group by idOrden;');
    res.render('ordenes/liderMantenimiento/ordenescerradas', {tecnicosDatosOrden})
})



























//Rutas add x cosa


router.get('/addtecnico/:id', async(req, res)=>{
    res.render('ordenes/liderMantenimiento/addRecursos/tecnico');
});


router.post('/addtecnico/:id', async(req, res)=>{
    const users= await pool.query('select * from usuario');
    const{nameTec}=req.body;
    await pool.query ('insert into tecnico set ?');
    res.render('ordenes/')
});


router.get('/addmaquina', isLoggedIn, permissions, async(req, res)=>{
    const area= await pool.query('select * from area')
    //console.log(area);
    res.render('ordenes/liderMantenimiento/addRecursos/maquina', {area});

    //console.log(req.body);
});

router.post('/addmaquina', async(req, res)=>{
    //console.log(req.body)
    const {idArea, nameMaquina}=req.body;
    const dataMaquina={
        nameMaquina: nameMaquina.replace(/\b\w/g, function(l){ return l.toUpperCase() }),
        idArea
    }
    await pool.query('insert into maquina set ?', [dataMaquina]);
    req.flash('success', 'Maquina agregada correctamente');
    res.redirect('/addmaquina')
})

router.get('/addarea', async(req, res)=>{
    res.render('ordenes/liderMantenimiento/addRecursos/areas');
    //console.log(req.body);
})

router.post('/addarea', async(req, res)=>{
    const {nameArea}=req.body;
    const dataArea={
        nameArea: nameArea.replace(/\b\w/g, function(l){ return l.toUpperCase() })
    }
    await pool.query('insert into area set ?', [dataArea]);
    req.flash('success', 'Area agregada correctamente');
    res.redirect('/addarea')

})

router.get('/addProveedor', async(req, res)=>{
    res.render('ordenes/liderMantenimiento/addRecursos/proveedor');
})

router.post('/addProveedor', async(req, res)=>{
    const {nameProveedor}=req.body;
    const dataProveedor={
        nameProveedor: nameProveedor.replace(/\b\w/g, function(l){ return l.toUpperCase() })
    }
    await pool.query('insert into proveedor set ?', [dataProveedor]);
    req.flash('success', 'Proveedor agregado correctamente');
    res.redirect('/addProveedor')
})

router.get('/addsuministros', async(req, res)=>{
    res.render('/liderMantenimiento/addRecursos/suministros');
    //console.log(req.body);
})

router.post('/addsuministros', async(req, res)=>{
    const{nameSuministros}= req.body;
    await pool.query('insert into suministros set ?');
    res.render('ordenes/')
    //console.log(req.body);
})








module.exports = router;