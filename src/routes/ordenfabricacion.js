const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions, operador, digitador} = require('../lib/auth');
const constants = require("constants");
//const {logger} = require("browser-sync/dist/logger");
//const {es, el} = require("timeago.js/lib/lang");
//const Console = require("console");
//const {response} = require("express");

//Rutas de admin

router.get('/agregarof', isLoggedIn, operador, async (req, res) => {
    //console.log(req.user.rolusuario);
    //const userId = req.user.iduser;
    const maquinarias = await pool.query('select * from maquinaria');
    const material = await pool.query('select * from material');

    res.render('produccion/addordenfabricacion', {maquinarias, material})
});

router.post('/agregarof', isLoggedIn, operador, async (req, res) => {
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
    //console.log(idOrden);
    await pool.query('insert into operador (idtipoOperador, idUsuario, idOrdenFabricacion, idTipoMarca) values ( ?, ?, ?, ?);', [1, req.user.iduser, idOrden, 1]);
    //console.log(idOrden)
    res.redirect('/detallesofoperador/'+idOrden)

});


router.get('/ordenesfabricacion', isLoggedIn, operador, async (req, res) => {
    const userId = req.user.iduser;
    const rolusuario = req.user.rolusuario;
    if (rolusuario===5){
        const datosof = await pool.query('select * from datosof where iduser=? and idStatus=1', [userId]);
        const ordenesAsignadasOPeradores = await pool.query('select * from dataAsignadas where iduser=? and idstatus=1;', [userId])
        const preba= await pool.query('select * from dataOperadores where Fecha between DATE_FORMAT(NOW(), "%e/%m/%y") and DATE_FORMAT(curdate() -1, "%e/%m/%y");')
        console.log(preba);
        res.render('produccion/ordenesfabricacion', {
            datosof,
            ordenesAsignadasOPeradores
        })
    }else {
        const datosof = await pool.query('select * from datosof where idStatus=1');
        res.render('produccion/ordenesfabricacion', {datosof})
    }



});

router.get('/ordenesfabricacionTerminadas', isLoggedIn, operador, async (req, res) => {
    const userId = req.user.iduser;
    const rolusuario = req.user.rolusuario;
    if(rolusuario===5){
        const datosofCerradas = await pool.query('select * from dataOperadores where IDUsuario=? group by idOrden;', [userId]);
        res.render('produccion/operadores/ofterminadas', {datosofCerradas, rolusuario})
    }else {
        const datosofCerradas = await pool.query('select * from datosof where idStatus=2', [userId]);
        res.render('produccion/operadores/ofterminadas', {datosofCerradas, rolusuario})
    }
});

router.get('/ordenesfabricacionabiertas', isLoggedIn, operador, async (req, res) => {
    //const userId = req.user.iduser;
    const rolusuario = req.user.rolusuario;
    const datosOfCreadas = await pool.query('select * from datosof where idstatus=1;');
    res.render('produccion/operadores/ofCreadas', {datosOfCreadas, rolusuario})
    //console.log(rolusuario);
});


router.get('/detallesof/:id', isLoggedIn, digitador,  async (req, res) => {
    //const userId = req.user.iduser;
    const ordenid = req.params.id;
    const rolusuario = req.user.rolusuario;
    const idUser= req.user.iduser;
    const datosHorasOperadores= await pool.query('select * from horasOperadoresCalcular where idOrden=?;', [ordenid]);
    const datosPara = await pool.query('select * from datosPara where idOrdenFabricacion=?', [ordenid]);
    const horasPara = await pool.query('select sec_to_time(sum(time_to_sec(horasPara))) as horasPara, idOrdenFabricacion from horasPara where idOrdenFabricacion=?', [ordenid])
    const ayudantesOrden = await pool.query("select * from horasOperadoresCalcular where idOrden=? group by idUsuario;", [ordenid]);
    //console.log(ayudantesOrden)
    const datosAyudantes=[];
    for (const ayudante of ayudantesOrden){
        const idUsuario= ayudante.idUsuario;
        const idOrden= ayudante.idOrden;
        const HoraEntrada= ayudante.HoraEntrada;
        const HoraSalida= ayudante.HoraSalida;
        const nameMaquinaria= ayudante.nameMaquinaria;
        const nameMaterial= ayudante.nameMaterial;
        const nameTipoOperador= ayudante.nameTipoOperador;
        const fullname= ayudante.fullname;
        //const TiempoTrabajado= ayudante.TiempoTrabajado;
        const nameTurno= ayudante.nameTurno;
        const resultadoSumaHoras= await pool.query('SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(TiempoTrabajado))) AS Hora FROM horasOperadoresCalcular WHERE idUsuario=? AND idOrden=?', [idUsuario, idOrden]);
        const horasTotales=resultadoSumaHoras[0].Hora;
        datosAyudantes.push({
            idUsuario,
            idOrden,
            horasTotales,
            HoraEntrada,
            HoraSalida,
            nameMaquinaria,
            nameMaterial,
            nameTipoOperador,
            nameTurno,
            fullname
        });
   }
    const dataOperadorPrincipal = await pool.query('select * from dataOperadores where IdOrden=? and IdTipoOperador=1 group by IDUsuario;', [ordenid])
    const dataOperadorAyudante = await pool.query('select * from dataOperadores where IdOrden=? and IdTipoOperador=2 group by IDUsuario;', [ordenid])
    const HorasTrabajadasMaquina = dataOperadorPrincipal[0].HorasTrabajadas;
    let HorasParas = horasPara[0].horasPara;
    const hora1 = (HorasTrabajadasMaquina).split(":");
    if(HorasParas===null){
        var hora2 = ("00:00:00").split(":");
        //console.log(hora2);
    }else {
        var hora2 = (HorasParas).split(":");
    }
    t1 = new Date(),
    t2 = new Date();
    t1.setHours(hora1[0], hora1[1], hora1[2]);
    t2.setHours(hora2[0], hora2[1], hora2[2]);
    t1.setHours(t1.getHours() - t2.getHours(), t1.getMinutes() - t2.getMinutes(), t1.getSeconds() - t2.getSeconds());
    var horasymin = t1.getHours()+":"+t1.getMinutes()+":"+t1.getSeconds();

    res.render('produccion/detallesof', {
        datosPara,
        horasPara: horasPara[0],
        //ayudantesOrden,
        dataOperadorPrincipal: dataOperadorPrincipal[0],
        dataOperadorAyudantes: dataOperadorAyudante[0],
        dataOperadorAyudante,
        horasymin,
        rolusuario,
        //HorasEntrada:HorasEntrada[0],
        datosHorasOperadores,
        datosAyudantes


        //horasEntrada
    })
    console.log(datosAyudantes);
});


router.get('/reportefechasoft', isLoggedIn, digitador, async (req, res)=>{
    res.render('produccion/reportesfechas')
})
router.post('/fechasreporte', isLoggedIn, async (req, res)=>{
    res.send("ok")
})

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
    //console.log(operador);

          await pool.query('insert into operador set ?;', [operador]);
          await pool.query('insert into horasEntradaOF set idUsuario=?, idTipoOperador=?, idOrden=?;', [userId, idtipoOperador, idOrdenFabricacion.id]);
       res.redirect('/detallesofoperador/' + idOrdenFabricacion.id);
       /*
       const personaOrden = await pool.query('select * from operador where idUsuario=? and idOrdenFabricacion=?', [userId, idOrdenFabricacion.id]);
       if (personaOrden.length > 0) {
           req.flash('success', 'Esta persona ya existe en esta orden');
           res.redirect('/detallesofoperador/' + idOrdenFabricacion.id);
       } else {
           await pool.query('insert into operador set ?;', [operador]);

           req.flash('success', 'Operador Asignado con exito');
           res.redirect('/detallesofoperador/' + idOrdenFabricacion.id);
       }




        */



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
    //console.log(operador);
    //console.log(idOrdenFabricacion);
    await pool.query('insert into operador set ?;', [operador]);
    const idPrevio = await pool.query('select idHoraEntradaOf from horasEntradaOF where idOrden=? and idUsuario=? order by create_at desc limit 1;', [idOrdenFabricacion.id, userId]);
    console.log(idPrevio[0].idHoraEntradaOf);
    await pool.query('insert into horasSalidaOF set idUsuario=?, idTipoOperador=?, idOrden=?,idHoraEntrada=? ;', [userId, idtipoOperador, idOrdenFabricacion.id, idPrevio[0].idHoraEntradaOf]);
    //await pool.query('insert into horasSalidaOF set idUsuario=?, idTipoOperador=?, idOrden=?;', [userId, idtipoOperador, idOrdenFabricacion.id]);

    res.redirect('/detallesofoperador/' + operador.idOrdenFabricacion);
});


router.get('/detallesofoperador/:id', permissions, isLoggedIn, async (req, res) => {
    const userId = req.user.iduser;
    const ordenid = req.params.id;
    const datosof = await pool.query('select * from datosof where idOrdenFabricacion=?', [ordenid]);
    const tipoPara = await pool.query('select * from tipoPara');
    const datosPara = await pool.query('select * from datosPara where idOrdenFabricacion=?', [ordenid]);
    const horasPara = await pool.query('select sec_to_time(sum(time_to_sec(horasPara))) as horasPara, idOrdenFabricacion from horasPara where idOrdenFabricacion=?', [ordenid])
    const horasOrden = await pool.query('select * from horasOrdenFabricacion where idOrdenFabricacion=?', [ordenid]);
    const horasOrdenT = await pool.query('select sec_to_time(sum(time_to_sec(horasOf))) as horasOrdenT, idOrdenFabricacion from horasOf where idOrdenFabricacion=?;', [ordenid]);
    const userOrden = await pool.query('select * from operador where idOrdenFabricacion=? and idUsuario=? order by create_at desc limit 1;', [ordenid, userId]);
    const ayudantesOrden = await pool.query('select idUsuario, idtipoOperador, idTipoMarca, u.fullname from operador inner join usuario u on operador.idUsuario=u.iduser where idtipoOperador=2 and idOrdenFabricacion=? and idTipoMarca=1 group by idUsuario;', [ordenid]);
    const HorasOperadoresOf= await pool.query("select * from horasOperadoresCalcular where idOrden=? and idUsuario=? ;", [ordenid,userId]);
    const tiempoOperador= await pool.query("select sec_to_time(sum(time_to_sec(TiempoTrabajado))) as Hora from horasOperadoresCalcular where idUsuario=? and idOrden=?;", [userId, ordenid])
    //console.log(tiempoOperador[0].Hora);
    res.render('produccion/operadores/detallesofT', {
        datosof: datosof[0],
        tipoPara,
        datosPara,
        horasPara: horasPara[0],
        horasOrden: horasOrden[0],
        horasOrdenT: horasOrdenT[0],
        userOrden: userOrden[0],
        ayudantesOrden,
        HorasOperadoresOf,
        tiempoOperador: tiempoOperador[0].Hora

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
    await pool.query('insert into horasParas set ?', [horas_Para]);
    res.redirect('detallesofoperador/' + idOrdenFabricacion)
});


router.post('/cerrarof/:id', isLoggedIn, async (req, res) => {
    const ordenid = req.params.id;
    const userId = req.user.iduser;
    const { pesoKg, horaInicio, horaFinal, idtipoOperador, idTipoMarca} = req.body;

    await pool.query('insert into kgMaterial (kg, idOrdenFabricacion) values (?,?)', [pesoKg, ordenid]);
    await pool.query('insert into horasOrdenFabricacion(horaInicio, horaFinal, idOrdenFabricacion) values (?, ?, ?)', [horaInicio, horaFinal, ordenid]);
    await pool.query('insert into operador (idtipoOperador, idUsuario, idOrdenFabricacion, idTipoMarca) values ( ?, ?, ?, ?);', [idtipoOperador, userId, ordenid, idTipoMarca]);
    await pool.query('update ordenFabricacion set idstatus=2 where idOrdenFabricacion=?;', [ordenid]);
    const operadores = await pool.query('select idUsuario, idTipoMarca from operador where idOrdenFabricacion=? and idtipoOperador=2 group by idUsuario;', [ordenid]);
    for (let i = 0; i < operadores.length; i++) {
        const idOperador = operadores[i].idUsuario;
        const previs = await pool.query('select idUsuario, idOrdenFabricacion, idTipoMarca from operador where idUsuario=? and idOrdenFabricacion=?', [idOperador, ordenid]);
        if (previs.length > 1) {
            console.log('el operador con el id', +idOperador, "Ya se fue")
        } else {
            console.log('el operador con el id', +idOperador, "Solo entró")
            await pool.query('insert into operador (idtipoOperador, idUsuario, idOrdenFabricacion, idTipoMarca)  values (?,?,?,?);', [2, idOperador, ordenid, 2]);
            const idHoraEntrada = await pool.query('select idHoraEntradaOf as id from horasEntradaOF where idOrden=? and idUsuario=? and idtipoOperador=2 order by create_at desc limit 1;', [ordenid, idOperador]);
            console.log(idHoraEntrada[0].id)
            await pool.query('insert into horasSalidaOF set idUsuario=?, idTipoOperador=?, idOrden=?,idHoraEntrada=? ;', [idOperador, 2, ordenid, idHoraEntrada[0].id]);
        }
    }

    res.redirect('/detallesofoperador/' + ordenid)
});
module.exports = router;