const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions} = require('../lib/auth');
const {logger} = require("browser-sync/dist/logger");
const {es} = require("timeago.js/lib/lang");
const Console = require("console");
const {response} = require("express");

//Rutas de admin

router.get('/agregarof', isLoggedIn, async (req, res) => {
    const userId = req.user.iduser;
    const maquinarias = await pool.query('select * from maquinaria');
    const material = await pool.query('select * from material');

    res.render('produccion/addordenfabricacion', {maquinarias, material})
});

router.post('/agregarof', isLoggedIn, permissions, async (req, res) => {
    const {idMaquinaria, idMaterial} = req.body;
    let fecha = new Date();
    let hora = fecha.getHours();
    if (hora >= 7 && hora < 19) {
        const ordenfabricacion = {
            idMaquinaria,
            idMaterial,
            idUser: req.user.iduser,
            idTurno: 1
        }
        await pool.query('INSERT INTO ordenFabricacion set ? ', [ordenfabricacion]);
    } else {
        const ordenfabricacion = {
            idMaquinaria,
            idMaterial,
            idUser: req.user.iduser,
            idTurno: 2
        }
        await pool.query('INSERT INTO ordenFabricacion set ?', [ordenfabricacion]);
        req.flash('success', 'Orden de fabricacion agregada correctamente');
    }
    const id = await pool.query('SELECT idOrdenFabricacion FROM ordenFabricacion where idUser=? and date_format(create_at, "%Y-%m-%d")=curdate() ORDER BY idOrdenFabricacion DESC LIMIT 1;', [req.user.iduser]);
    const idOrden = id[0].idOrdenFabricacion;
    console.log(idOrden);
    await pool.query('insert into operador (idtipoOperador, idUsuario, idOrdenFabricacion, idTipoMarca) values ( ?, ?, ?, ?);', [1, req.user.iduser, idOrden, 1]);
    //console.log(idOrden)
    res.redirect('/ordenesfabricacion')

});


router.get('/ordenesfabricacion', isLoggedIn, async (req, res) => {
    const userId = req.user.iduser;
    const datosof = await pool.query('select * from datosof where iduser=? and idStatus=1', [userId]);
    res.render('produccion/ordenesfabricacion', {datosof})

});

router.get('/ordenesfabricacionTerminadas', isLoggedIn, async (req, res) => {
    const userId = req.user.iduser;
    const datosofCerradas = await pool.query('select * from datosof where iduser=? and idStatus=2', [userId]);
    res.render('produccion/operadores/ofterminadas', {datosofCerradas})

});

router.get('/ordenesfabricacioncreadas', isLoggedIn, async (req, res) => {
    const userId = req.user.iduser;
    const datosOfCreadas = await pool.query('select * from datosof where idStatus=1');
    res.render('produccion/operadores/ofCreadas', {datosOfCreadas})

});


router.get('/tipoOperador', isLoggedIn, permissions, async (req, res) => {
    const operadores = await pool.query('select * from usuario where rolusuario=5;')
    const tipoOperador = await pool.query('select * from tipoOperador');
    res.render('ordenes/paneladmin/tipooperador', {operadores, tipoOperador})
});


router.post('/edittipoOperador/', isLoggedIn, permissions, async (req, res) => {
    const {idUser, idTipoOperador} = req.body;
    //console.log(idUser, idTipoOperador);
    const idUserdb = await pool.query('select * from operador where idUsuario=?', [idUser])
    if (idUserdb.length > 0) {
        await pool.query('update operador set idtipoOperador=? where idUsuario=?;', [idTipoOperador, idUser]);
        req.flash('success', 'Operador actualizado correctamente')
    } else {
        await pool.query('insert into operador (idtipoOperador, idUsuario) values (?, ?);', [idTipoOperador, idUser]);
        req.flash('success', 'Operador Designado correctamente')
    }

    res.redirect('/tipoOperador/');
});


router.get('/detallesof/:id', permissions, isLoggedIn, async (req, res) => {
    const userId = req.user.iduser;
    const ordenid = req.params.id;
    const datosof = await pool.query('select * from datosof where idOrdenFabricacion=?', [ordenid]);
    const tipoPara = await pool.query('select * from tipoPara');
    const datosPara = await pool.query('select * from datosPara where idOrdenFabricacion=?', [ordenid]);
    const horasPara = await pool.query('select sec_to_time(sum(time_to_sec(horasPara))) as horasPara, idOrdenFabricacion from horasPara where idOrdenFabricacion=?', [ordenid])
    const horasOrden = await pool.query('select * from horasordenfabricacion where idOrdenFabricacion=?', [ordenid]);
    const horasOrdenT = await pool.query('select sec_to_time(sum(time_to_sec(horasOf))) as horasOrdenT, idOrdenFabricacion from horasOf where idOrdenFabricacion=?;', [ordenid]);
    const userOrden = await pool.query('select idtipoOperador, idUsuario, idTipoMarca from operador where idOrdenFabricacion=? and idUsuario=? ORDER BY idTipoMarca DESC LIMIT 1', [ordenid, userId]);
    const ayudantesOrden = await pool.query('select idUsuario, idtipoOperador, idTipoMarca, u.fullname from operador inner join usuario u on operador.idUsuario=u.iduser where idtipoOperador=2 and idOrdenFabricacion=? and idTipoMarca=1;', [ordenid]);

    const operadoresOrden = await pool.query('select idUsuario, idtipoOperador, idTipoMarca, idOrdenFabricacion, u.fullname from operador inner join usuario u on operador.idUsuario=u.iduser where idOrdenFabricacion=? and idTipoMarca=1;', [ordenid]);

    const dataOperadores= await pool.query('select * from dataOperadores where IdOrden=?', [ordenid]);
    const dataOperadorPrincipal= await pool.query('select * from dataOperadores where IdOrden=? and IdTipoOperador=1 group by IDUsuario;', [ordenid])
    const dataOperadorAyudante= await pool.query('select * from dataOperadores where IdOrden=? and IdTipoOperador=2 group by IDUsuario;', [ordenid])
    console.log(dataOperadorAyudante)



    res.render('produccion/detallesof', {
        datosof: datosof[0],
        tipoPara,
        datosPara,
        horasPara: horasPara[0],
        horasOrden: horasOrden[0],
        horasOrdenT: horasOrdenT[0],
        userOrden: userOrden[0],
        ayudantesOrden,
        dataOperadores,




        operadoresOrden,
        dataOperadorPrincipal: dataOperadorPrincipal[0],
        dataOperadorAyudantes: dataOperadorAyudante[0],
        dataOperadorAyudante
    })
});


//A partir de aquí las rutas de los tecnicos


router.post('/operadormaquina/:id', isLoggedIn, async (req, res) => {
    const idOrdenFabricacion = req.params;
    const userId = req.user.iduser;
    const {idtipoOperador, idTipoMarca} = req.body;
    const operador = {
        idOrdenFabricacion: idOrdenFabricacion.id,
        idUsuario: userId,
        idtipoOperador,
        idTipoMarca,
    }
    const prueba = await pool.query('select * from operador where idUsuario=? and idOrdenFabricacion=?', [userId, idOrdenFabricacion.id]);
    if (prueba.length > 0) {
        req.flash('success', 'Esta persona ya existe en esta orden');
        res.redirect('/detallesofoperador/' + idOrdenFabricacion.id);
    } else {
        await pool.query('insert into operador set ?;', [operador]);
        req.flash('success', 'Operador Asignado con exito');
        res.redirect('/detallesofoperador/' + idOrdenFabricacion.id);
    }

});

router.post('/salirof/:id', isLoggedIn, async (req, res) => {
    const idOrdenFabricacion = req.params;
    const userId = req.user.iduser;
    const {idtipoOperador, idTipoMarca} = req.body;
    const operador = {
        idOrdenFabricacion: idOrdenFabricacion.id,
        idUsuario: userId,
        idtipoOperador,
        idTipoMarca,
    }
    console.log(operador);
    await pool.query('insert into operador set ?;', [operador]);
    res.redirect('/detallesofoperador/'+operador.idOrdenFabricacion);
});


router.get('/detallesofoperador/:id', permissions, isLoggedIn, async (req, res) => {
    const userId = req.user.iduser;
    const ordenid = req.params.id;
    const datosof = await pool.query('select * from datosof where idOrdenFabricacion=?', [ordenid]);
    const tipoPara = await pool.query('select * from tipoPara');
    const datosPara = await pool.query('select * from datosPara where idOrdenFabricacion=?', [ordenid]);
    const horasPara = await pool.query('select sec_to_time(sum(time_to_sec(horasPara))) as horasPara, idOrdenFabricacion from horasPara where idOrdenFabricacion=?', [ordenid])
    const horasOrden = await pool.query('select * from horasordenfabricacion where idOrdenFabricacion=?', [ordenid]);
    const horasOrdenT = await pool.query('select sec_to_time(sum(time_to_sec(horasOf))) as horasOrdenT, idOrdenFabricacion from horasOf where idOrdenFabricacion=?;', [ordenid]);
    const userOrden = await pool.query('select idtipoOperador, idUsuario, idTipoMarca from operador where idOrdenFabricacion=? and idUsuario=? ORDER BY idTipoMarca DESC LIMIT 1', [ordenid, userId]);

    const ayudantesOrden = await pool.query('select idUsuario, idtipoOperador, idTipoMarca, u.fullname from operador inner join usuario u on operador.idUsuario=u.iduser where idtipoOperador=2 and idOrdenFabricacion=? and idTipoMarca=1;', [ordenid]);
    //console.log(ayudantesOrden);

    //console.log(horasMaquina);
    res.render('produccion/operadores/detallesofT', {
        datosof: datosof[0],
        tipoPara,
        datosPara,
        horasPara: horasPara[0],
        horasOrden: horasOrden[0],
        horasOrdenT: horasOrdenT[0],
        userOrden: userOrden[0],
        ayudantesOrden

    })

});


router.post('/agregarPara', isLoggedIn, async (req, res) => {
    const {idTipoPara, horaInicio, horaFinal, comentario, idOrdenFabricacion} = req.body;
    const horas_Para = {
        idTipoPara,
        horaInicio,
        horaFinal,
        comentario,
        idOrdenFabricacion
    };
    /*
     const horaInicios=(horaInicio).split(":");
     const horaFinals=(horaFinal).split(":");
     const h1=new Date();
     const h2=new Date();
     //console.log(h1, h2);
     h1.setHours(horaInicios[0], horaInicios[1]);
     h2.setHours(horaFinals[0], horaFinals[1]);
     h1.setHours(h1.getHours()-h2.getHours(), h1.getMinutes()-h2.getMinutes());
     console.log("La diferencia es de: " + (h1.getHours() ? h1.getHours() + (h1.getHours() > 1 ? " horas" : " hora") : "") + (h1.getMinutes() ? ", " + h1.getMinutes() + (h1.getMinutes() > 1 ? " minutos" : " minuto") : ""));

     */
    await pool.query('insert into horasParaS set ?', [horas_Para]);
    res.redirect('detallesofoperador/' + idOrdenFabricacion)
});


router.post('/cerrarof/:id', isLoggedIn, async (req, res) => {
    const ordenid = req.params.id;
    const userId = req.user.iduser;
    const {idMaterial, pesoKg, horaInicio, horaFinal, idtipoOperador, idTipoMarca} = req.body;
    const data = {
        idMaterial,
        pesoKg,
        horaInicio,
        horaFinal
    }

    await pool.query('insert into kgMaterial (kg, idOrdenFabricacion) values (?,?)', [pesoKg, ordenid]);
    await pool.query('insert into horasOrdenFabricacion(horaInicio, horaFinal, idOrdenFabricacion) values (?, ?, ?)', [horaInicio, horaFinal, ordenid]);
    await pool.query('insert into operador (idtipoOperador, idUsuario, idOrdenFabricacion, idTipoMarca) values ( ?, ?, ?, ?);', [idtipoOperador, userId, ordenid, idTipoMarca]);
    await pool.query('update ordenFabricacion set idstatus=2 where idOrdenFabricacion=?;', [ordenid]);

    const operadores= await pool.query('select idUsuario, idTipoMarca from operador where idOrdenFabricacion=? group by idUsuario;', [ordenid]);
    for (let i = 0; i < operadores.length; i++) {
        const idOperador = operadores[i].idUsuario;
        const previs = await pool.query('select idUsuario, idOrdenFabricacion, idTipoMarca from operador where idUsuario=? and idOrdenFabricacion=?', [idOperador, ordenid]);
        if(previs.length>1){
            console.log('el operador con el id', +idOperador, "Ya se fue")
        }else {
            console.log('el operador con el id', +idOperador, "Solo entró")
            await pool.query('insert into operador (idtipoOperador, idUsuario, idOrdenFabricacion, idTipoMarca)  values (?,?,?,?);', [2, idOperador, ordenid, 2]);
        };
    }
    //const operadoresSalieron= await pool.query('select idUsuario, idTipoMarca from operador where (idOrdenFabricacion=? and idTipoMarca=2) and idUsuario=?;',[ordenid, 11]);
    //console.log(operadoresSalieron);
    res.redirect('/detallesofoperador/' + ordenid)
});


router.post('/ayudanteof', isLoggedIn, async (req, res) => {
    console.log(req.body)
    res.redirect('/detallesof/')
});

module.exports = router;