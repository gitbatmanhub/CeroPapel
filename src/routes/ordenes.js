const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions} = require('../lib/auth');


//=======================================================Home

router.get('/dashboard', isLoggedIn, async (req, res) => {

    const rolusuario = req.user.rolusuario;
    const ordenesHoy= await pool.query('select count(idOrdenTrabajo) as ordenesHoy from ordenesFechaActual where fecha= DATE (NOW());')
    const ordenesTotal= await pool.query('select count(idOrdenTrabajo) as ordenesTotales from ordenesFechaActual;')
    const ordenesAprobar= await pool.query('select count(idOrdenTrabajo) as ordenesPorAprobar from ordenTrabajo where idStatus=1;')
    const ordenesAprobadas= await pool.query('select count(idOrdenTrabajo) as ordenesPorAprobadas from ordenTrabajo where idStatus=2;')
    const ordenesAsignadas= await pool.query('select count(idOrdenTrabajo) as ordenesPorAsignadas from ordenTrabajo where idStatus=3;')
    const ordenesRevisar= await pool.query('select count(idOrdenTrabajo) as ordenesPorRevisar from ordenTrabajo where idStatus=5;')
    const ordenesCerradas= await pool.query('select count(idOrdenTrabajo) as ordenesPorCerradas from ordenTrabajo where idStatus=6;')
    const ordenesExternas = await pool.query('select count(idOrden) as ordenesPorExternas  from orden_Status where idStatus=7;');
    const nrUsuarios= await pool.query('select count(iduser) as nrUsuarios from usuario;')
    res.render('ordenes/dashboard', {
        ordenesHoy: ordenesHoy[0],
        ordenesTotal: ordenesTotal[0],
        ordenesAprobar: ordenesAprobar[0],
        ordenesAprobadas: ordenesAprobadas[0],
        ordenesAsignadas: ordenesAsignadas[0],
        ordenesRevisar: ordenesRevisar[0],
        ordenesCerradas: ordenesCerradas[0],
        ordenesExternas: ordenesExternas[0],
        rolusuario,
        nrUsuarios: nrUsuarios[0]
    })
})

//====================================================
router.get('/misordenes', isLoggedIn, async (req, res) => {
    //console.log(req.user)
    const idUser = ([req.user.iduser][0]);
    //console.log(req.user.rolusuario)
    const misOrdenes = await pool.query('select ordenTrabajo.idOrdenTrabajo, s.avanceStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina,  e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idUsuario=?', [idUser]);
    const contadorMisOrdenes = await pool.query('select count(*) from ordentrabajo where idUsuario=2')
    //console.log(misOrdenes);
    //console.log(contadorMisOrdenes)
    res.render('ordenes/misordenes', {misOrdenes, contadorMisOrdenes})

})


router.get('/ordenesporaceptar', isLoggedIn, permissions, async (req, res) => {
    //console.log(req.user)
    //const idUser = ([req.user.iduser][0]);
    //console.log()
    const ordenesPorAceptar = await pool.query('select * from ordenesStatus where idStatus=1;');
    //const contadorMisOrdenes = await pool.query('select count(*) from ordentrabajo where idUsuario=2')
    //console.log(misOrdenes);
    //console.log(ordenesPorAceptar);
    res.render('ordenes/liderMantenimiento/ordenesPA', {ordenesPorAceptar});

})

router.get('/ordenesaprobadas', isLoggedIn, permissions, async (req, res) => {
    //console.log(req.user)
    //const idUser = ([req.user.iduser][0]);
    //console.log()
    const ordenesAceptadas = await pool.query('select * from ordenesStatus where idStatus=2;');
    //const contadorMisOrdenes = await pool.query('select count(*) from ordentrabajo where idUsuario=2')
    //console.log(misOrdenes);
    //console.log(ordenesAceptadas);
    res.render('ordenes/liderMantenimiento/ordenesAprobadas', {ordenesAceptadas})

})


router.get('/ordenesasignadas', isLoggedIn, permissions, async (req, res) => {
    const idUser = ([req.user.iduser][0]);
    const ordenesasignadas = await pool.query('select * from ordenesStatus where idStatus=3 or idStatus=4;');
    //console.log(ordenesPorAceptar);
    res.render('ordenes/lidermantenimiento/asignadas', {ordenesasignadas});
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
    const idOrden = req.params.id;
    //console.log(idOrden)
    const everDatos = await pool.query('select * from TodosDatos where idOrdenTrabajo=?', [idOrden]);
    const tecnicosOrden = await pool.query('select * from tecnicosOrden where idOrdenTrabajo = ? group by iduser;', [idOrden]);
    const statuS = await pool.query('select * from ordenStatusDetails where idOrden=? group by AvanceStatus;', [idOrden])
    const comentarios = await pool.query('select * from comentariosOrdenUser where idOrden=?;', [idOrden])
    console.log(comentarios)
    res.render('ordenes/liderMantenimiento/details', {
        datos: everDatos[0],
        statuS,
        tecnicosOrden,
        comentarios/*, externo: externo[0]*/
    });

});


router.post('/accept/:id', isLoggedIn, permissions, async (req, res) => {
    const {orden, status, tipoMantenimiento} = req.body;
    const data =
        {
            idOrden: orden,
            idStatus: status,
            idUsuario: req.user.iduser

        };
    await pool.query('INSERT INTO orden_Status set ?', [data]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=2 WHERE idOrdenTrabajo = ?', [orden]);

    res.redirect('/ordenesaprobadas');
})


router.get('/probe', isLoggedIn, async (req, res) => {
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
        console.log(newProbeName, newProbeApellido)

    }
    //console.log(data)
    req.flash('success', 'Nombre y apellidos');
    res.redirect('/probe');


});


router.get('/suministro/:id', isLoggedIn, permissions, async (req, res) => {
    const idOrden = req.params.id;
    const ordenes = await pool.query('select * from ordentrabajo where idOrdenTrabajo=?;', [idOrden]);
    const suministros = await pool.query('select * from producto;')
    const productosOrdenes = await pool.query('select * from productosOrdenes where idOrden=?;', [idOrden])
    res.render('ordenes/liderMantenimiento/assign/suministros', {ordenes, suministros, productosOrdenes});
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
    const idOrden = [req.params.id];
    const objo = Object.assign({}, req.body);
    const exmaple = {idTecnico, fechaInicioPre, fechaFinalPre, tipoMantenimiento, descripcionTrabajo, idStatus} = objo;
    for (let i = 0; i < exmaple.idTecnico.length; i++) {
        const idTecnico = exmaple.idTecnico[i];
        await pool.query('INSERT into orden_Trabajador (idOrden, idTecnico) VALUES (?, ?)', [idOrden, idTecnico]);
        console.log("Aquí estoy",+idOrden, idTecnico)
    }
    await pool.query('INSERT into orden_status (idStatus, idOrden, idUsuario) VALUES (?,?,?)', [idStatus, idOrden, userId]);
    await pool.query('insert into fechas_orden (fechaInicio, fechaFinal, idUser, idOrden) values (?,?,?,?);', [fechaInicioPre, fechaFinalPre, userId, idOrden]);
    await pool.query('insert into comentarios_orden (comentario, idOrden, idUser, idStatus) values (?,?,?,?)', [descripcionTrabajo, idOrden, userId, 3])
    await pool.query('UPDATE ordenTrabajo SET idStatus=3 WHERE idOrdenTrabajo = ?', [idOrden]);
    await pool.query('insert into orden_tipomantenimiento (idOrden, idTipoMantenimiento) VALUES (?,?);', [idOrden, tipoMantenimiento]);


    res.redirect('/ordenesasignadas')
})


router.get('/trabajoexterno/:id', isLoggedIn, permissions, async (req, res) => {
    const maquina = await pool.query('select * from maquina');
    const id = req.params.id;
    const ordenes = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idOrdenTrabajo=?;', [id]);
    const proveedor = await pool.query('select * from proveedor');
    const tipoTrabajo = await pool.query('select * from tipoTrabajo');
    const tecnicos = await pool.query('select tecnico.idUser, u.fullname, tecnico.idEspecialidad, e.nameEspecialidad from tecnico inner join usuario u on tecnico.idUser = u.iduser inner join especialidadtecnico e on tecnico.idEspecialidad = e.idEspecialidad');
    const tipoMantenimiento = await pool.query('select * from tipomantenimiento');



    //console.log(maquina)
    res.render('ordenes/liderMantenimiento/assign/trabajoexterno', {maquina, proveedor, ordenes, tipoTrabajo, tecnico:tecnicos, tipoMantenimiento});
    //console.log(req.body);
})

router.post('/trabajoexterno/:id', isLoggedIn, permissions, async (req, res) => {
    const userId = [req.user.iduser][0];
    const idOrden = req.params.id;
    const {proveedor, tecnico, fechaInicioTE, fechaFinalTE, descripcionTrabajo,tipoTrabajo, tipoMantenimiento } = req.body;
    const trabajoExterno =
        {
            proveedor,
            tecnico,
            fechaInicioTE,
            fechaFinalTE,
            tipoTrabajo,
            descripcionTrabajo,
            tipoMantenimiento

        }
    for (let i = 0; i < trabajoExterno.tecnico.length; i++) {
        const idTecnico = trabajoExterno.tecnico[i];
        //Inserto en tabla orden_Trabajador los id de los tecnicos junto a los de la orden

        await pool.query('INSERT into orden_Trabajador (idOrden, idTecnico) VALUES (?, ?)', [idOrden, idTecnico]);
    }
    console.log(trabajoExterno);
    await pool.query('INSERT into orden_status (idStatus, idOrden, idUsuario, idProveedor) values (?,?,?,?);', [7, idOrden, userId, proveedor]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=? WHERE idOrdenTrabajo = ?', [7,idOrden]);
    await pool.query('insert into proveedor_orden(idOrdenTrabajo, idProveedor, id_tipoMantenimiento) values(?,?,?);', [idOrden, proveedor, tipoMantenimiento])
    await pool.query('insert into orden_tipomantenimiento(idorden, idtipomantenimiento) VALUES (?,?);', [idOrden, tipoMantenimiento]);
    await pool.query('insert into comentarios_orden(comentario, idOrden, idUser, idStatus) VALUES (?,?,?,?);', [descripcionTrabajo,idOrden, userId,7 ]);

    res.redirect('/externas');
})


router.get('/tecnicoexterno/:id', isLoggedIn, permissions, async (req, res) => {
    const id = req.params.id;
    const ordenes = await pool.query('select ordenTrabajo.*, s.nameStatus, ordenTrabajo.descripcion, ordenTrabajo.create_at , a.nameArea, m.nameMaquina , e.nameEstado,  p.namePrioridad from ordenTrabajo inner join prioridad p on ordenTrabajo.idPrioridad = p.idPrioridad inner join maquina m on ordenTrabajo.idMaquina = m.idMaquina inner join area a on ordenTrabajo.idArea=a.idArea inner join estadoMaquina e on ordenTrabajo.estadoMaquina = e.idEstadoMaquina inner join status s on ordenTrabajo.idStatus = s.idStatus where ordenTrabajo.idOrdenTrabajo=?;', [id]);
    const tecnicos = await pool.query('select tecnico.idUser, u.fullname, tecnico.idEspecialidad, e.nameEspecialidad from tecnico inner join usuario u on tecnico.idUser = u.iduser inner join especialidadtecnico e on tecnico.idEspecialidad = e.idEspecialidad');
    const tipoMantenimiento = await pool.query('select * from tipomantenimiento')
    res.render('ordenes/liderMantenimiento/assign/tecnicoExterno', {ordenes, tecnico: tecnicos, tipoMantenimiento});
})
router.post('/tecnicoexterno/:id', isLoggedIn, permissions, async (req, res) => {
    const idOrden = req.params.id;
    const objo = Object.assign({}, req.body);
    const exmaple = {idTecnico} = objo;
    for (let i = 0; i < exmaple.idTecnico.length; i++) {
        const idTecnico = exmaple.idTecnico[i];
        await pool.query('INSERT orden_Trabajador (idOrden, idTecnico) values (?, ?);', [idOrden, idTecnico]);
    }
    res.redirect('/ordenesasignadas/');
})


router.get('/ordenesatender', isLoggedIn, async (req, res) => {

    const idUser = ([req.user.iduser][0]);
    const tecnicosDatosOrden = await pool.query('select * from tecnicosOrden where iduser=? and idStatus=3 group by idOrdenTrabajo ;', [idUser]);
    res.render('ordenes/tecnico/ordenesatender', {tecnicosDatosOrden})
});


router.get('/datosordent/:id', isLoggedIn, async (req, res) => {
    const idOrden = req.params.id;
    //console.log(idOrden)
    const datosOrden = await pool.query('select * from TodosDatos where idOrdenTrabajo=?', [idOrden]);
    const tecnicosOrden = await pool.query('select * from tecnicosOrden where idOrdenTrabajo=? group by iduser;', [idOrden]);
    const comentario = await pool.query('select * from comentariosOrdenUser where idOrden=?;', [idOrden])
    const fechasOrden = await pool.query('select fechaInicio, fechaFinal from fechas_orden where idOrden=?', [idOrden]);
    console.log(fechasOrden);
    res.render('ordenes/tecnico/detailsTecnico', {
        datos: datosOrden[0],
        tecnicosOrden,
        comentario,
        fecha: fechasOrden[0]/*, externo: externo[0]*/
    })
});


router.post('/attendTecnico', isLoggedIn, async (req, res) => {
    const {orden, status} = req.body;
    const data =
        {
            idOrden: orden,
            idStatus: status,
            idUsuario: req.user.iduser
        };

    await pool.query('INSERT INTO orden_Status set ?', [data]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=4 WHERE idOrdenTrabajo = ?', [orden]);
    res.redirect('/ordenesatendidasT')
})

router.get('/ordenesatendidasT', isLoggedIn, async (req, res) => {
    const idUser = ([req.user.iduser][0]);
    const tecnicosDatosOrdenAtendida = await pool.query('select * from bddnova.tecnicosOrden where iduser=? and idStatus=4 group by idOrdenTrabajo;', [idUser]);
    res.render('ordenes/tecnico/ordenesatendidas', {tecnicosDatosOrdenAtendida});
});


router.post('/finishTecnico', isLoggedIn, async (req, res) => {
    const {orden, status, comentarioTecnico} = req.body;
    const data =
        {
            idOrden: orden,
            idStatus: status,
            idUsuario: req.user.iduser,
            comentariosTecnico: comentarioTecnico
        };
    await pool.query('INSERT INTO orden_Status (idOrden, idStatus, idUsuario) values (?,?,?)', [orden, status, req.user.iduser]);
    await pool.query('INSERT INTO comentarios_orden (comentario, idOrden, idUser, idStatus) values (?,?,?,5)', [comentarioTecnico, orden, req.user.iduser ]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=5 WHERE idOrdenTrabajo = ?', [orden]);


    console.log(data);


    res.redirect('/ordenesatendidasT')
})


router.get('/porrevisar', isLoggedIn, async (req, res) => {
    const tecnicosDatosOrden = await pool.query('select * from ordenesStatus where idStatus=5;');
    res.render('ordenes/liderMantenimiento/ordenesporrevisar', {tecnicosDatosOrden})
})

router.post('/finishLiderplanificador', isLoggedIn, async (req, res) => {
    const {orden, status, comentarioLider} = req.body;
    const data =
        {
            idOrden: orden,
            idStatus: status,
            idUsuario: req.user.iduser,
            comentarioLider
        };

    await pool.query('INSERT INTO orden_Status (idOrden, idStatus, idUsuario) values (?,?,?)', [orden, status, req.user.iduser]);
    await pool.query('INSERT INTO comentarios_orden (comentario, idOrden, idUser, idStatus) values (?,?,?,6)', [comentarioLider, orden, req.user.iduser ]);
    await pool.query('UPDATE ordenTrabajo SET idStatus=6 WHERE idOrdenTrabajo = ?', [orden]);


    res.redirect('/dashboard')
})

router.get('/cerradas', isLoggedIn, permissions, async (req, res) => {
    const tecnicosDatosOrden = await pool.query('select * from ordenesStatus where idStatus=6;');
    res.render('ordenes/liderMantenimiento/ordenescerradas', {tecnicosDatosOrden})
})

router.get('/externas', isLoggedIn, permissions, async (req, res) => {
    const dataOrden = await pool.query('select * from ordenesStatus where idStatus=7;');
    res.render('ordenes/liderMantenimiento/externas', {dataOrden});
})


//Rutas add x cosa


router.get('/addtecnico/:id', async (req, res) => {
    res.render('ordenes/liderMantenimiento/addRecursos/tecnico');
});


router.post('/addtecnico/:id', async (req, res) => {
    const users = await pool.query('select * from usuario');
    const {nameTec} = req.body;
    await pool.query('insert into tecnico set ?');
    res.render('ordenes/')
});


router.get('/addmaquina', isLoggedIn, permissions, async (req, res) => {
    const area = await pool.query('select * from area')
    //console.log(area);
    res.render('ordenes/liderMantenimiento/addRecursos/maquina', {area});

    //console.log(req.body);
});

router.post('/addmaquina', async (req, res) => {
    //console.log(req.body)
    const {idArea, nameMaquina} = req.body;
    const dataMaquina = {
        nameMaquina: nameMaquina.replace(/\b\w/g, function (l) {
            return l.toUpperCase()
        }),
        idArea
    }
    await pool.query('insert into maquina set ?', [dataMaquina]);
    req.flash('success', 'Maquina agregada correctamente');
    res.redirect('/addmaquina')
})

router.get('/addarea', async (req, res) => {
    res.render('ordenes/liderMantenimiento/addRecursos/areas');
    //console.log(req.body);
})


router.post('/addarea', async (req, res) => {
    const {nameArea} = req.body;
    const dataArea = {
        nameArea: nameArea.replace(/\b\w/g, function (l) {
            return l.toUpperCase()
        })
    }
    await pool.query('insert into area set ?', [dataArea]);
    req.flash('success', 'Area agregada correctamente');
    res.redirect('/addarea')

})
router.get('/addproducto', async (req, res) => {
    res.render('ordenes/liderMantenimiento/addRecursos/producto');
    //console.log(req.body);
})
router.post('/addproducto', async (req, res) => {
    const {nameProducto, descripcionProducto} = req.body;
    const dataProducto = {
        nameProducto: nameProducto.replace(/\b\w/g, function (l) {
            return l.toUpperCase()
        }),
        DetallesProducto: descripcionProducto.replace(/\b\w/g, function (l) {
            return l.toUpperCase()
        })
    }
    await pool.query('insert into producto set ?', [dataProducto]);
    req.flash('success', 'Item agregado correctamente');
    res.redirect('/addproducto')

})

router.get('/addProveedor', async (req, res) => {
    res.render('ordenes/liderMantenimiento/addRecursos/proveedor');
})

router.post('/addProveedor', async (req, res) => {
    const {nameProveedor} = req.body;
    const dataProveedor = {
        nameProveedor: nameProveedor.replace(/\b\w/g, function (l) {
            return l.toUpperCase()
        })
    }
    await pool.query('insert into proveedor set ?', [dataProveedor]);
    req.flash('success', 'Proveedor agregado correctamente');
    res.redirect('/addProveedor')
})

router.get('/addsuministros', async (req, res) => {
    res.render('/liderMantenimiento/addRecursos/suministros');
    //console.log(req.body);
})

router.post('/addsuministros/:id', async (req, res) => {
    //const {nameSuministros} = req.body;
    const idOrden = req.params.id;
    const idUser = ([req.user.iduser][0]);
    const objo = Object.assign({}, req.body);
    const exmaple = {producto, cantidad} = objo;

    if (exmaple.producto.length<2){
        await pool.query('INSERT orden_producto (idOrden, idUser, idProducto, cantidad) VALUES (?,?,?,?)', [idOrden, idUser, producto,cantidad ]);
    }else {

        for (let i = 0; i < exmaple.producto.length; i++) {
            const idProducto = exmaple.producto[i];
            const cantidad = exmaple.cantidad[i];
            await pool.query('INSERT orden_producto (idOrden, idUser, idProducto, cantidad) VALUES (?,?,?,?)', [idOrden, idUser, idProducto,cantidad ]);

        }
    }
    req.flash('success', 'Item agregado correctamente a la orden '+ req.params.id);
    res.redirect('/suministro/'+idOrden)

})

router.post('/deleteItem/:id', isLoggedIn, permissions, async (req, res) => {
    const {id}= req.params;
    const {idOrden} = req.body;
    console.log(req.body)
    await pool.query('DELETE FROM orden_producto where idOrdenProducto=?', [id]);
    req.flash('error', 'Item eliminado correctamente');
    res.redirect('/suministro/'+idOrden);
});

router.get('/editrolusuario', isLoggedIn, permissions, async (req, res)=>{
    const usuario= await pool.query('select * from usuario');
    const roles= await pool.query('select * from rolusuario');
    res.render('ordenes/paneladmin/rolusuarios', {usuario, roles});
});

router.post('/editrolusuario/', isLoggedIn, permissions, async (req, res) => {
    const {idUser, idRol} = req.body;
    console.log(idUser, idRol);
    await pool.query('update usuario set rolusuario= ? where iduser=?;', [idRol, idUser]);
    req.flash('success', 'Usuario actualizado correctamente');
    res.redirect('/editrolusuario/');
});

router.get('/especialidadtecnico', isLoggedIn, permissions, async (req, res)=>{
    const usuario= await pool.query('select * from usuario where rolusuario=4');
    const especialidad= await pool.query('select * from especialidadtecnico');
    res.render('ordenes/paneladmin/especialidadtecnicos', {usuario, especialidad});
});

router.post('/especialidadtecnico/', isLoggedIn, permissions, async (req, res) => {
    const {idUser, idEspecialidad} = req.body;
    const datos={
        idUser,
        idEspecialidad
    }
    const probe = await pool.query('select * from tecnico where idUser=?', [idUser]);
    if(probe.length>0){
        await pool.query('update tecnico set idEspecialidad= ? where iduser=?;', [idEspecialidad, idUser]);
        req.flash('success', 'Especialidad Actualizada Correctamente');

    }else{
        await pool.query('insert into tecnico set ?;', [datos]);
        req.flash('success', 'Especialidad Asignada Correctamente');
    }
    res.redirect('/especialidadtecnico/');
});


router.get('/todosusuarios', permissions, isLoggedIn, async (req, res)=>{
   const dataUser= await pool.query('select * from dataUser');
   res.render('ordenes/paneladmin/todosusuarios', {dataUser})
});


router.post('/edituser', isLoggedIn, async (req, res)=>{
    const {fullName, sobremi, empresa, pais, direccion, telefono, email, twitter, instagram, linkedin, iduser}= req.body;
    const dataUser={
        fullname: fullName,
        sobreMi: sobremi,
        empresa,
        pais,
        direccion,
        telefono,
        username: email,
        twitterLink: twitter,
        igLink: instagram,
        inkedInLink: linkedin,
        iduser
    }
    console.log(dataUser);
    await pool.query('update usuario set ? where iduser=?', [dataUser, iduser]);
    res.redirect('/profile')
});


module.exports = router;