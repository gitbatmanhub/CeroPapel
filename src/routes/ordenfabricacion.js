const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions, tecnico, operador, admin, digitador} = require('../lib/auth');
const {logger} = require("browser-sync/dist/logger");
const {es, el} = require("timeago.js/lib/lang");
const Console = require("console");
const {response} = require("express");

//Rutas de admin

router.get('/agregarof', isLoggedIn, operador, async (req, res) => {
    //console.log(req.user.rolusuario);
    const userId = req.user.iduser;
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
    if (rolusuario==5){
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
    if(rolusuario==5){
        const datosofCerradas = await pool.query('select * from dataOperadores where IDUsuario=? group by idOrden;', [userId]);
        res.render('produccion/operadores/ofterminadas', {datosofCerradas, rolusuario})
    }else {
        const datosofCerradas = await pool.query('select * from datosof where idStatus=2', [userId]);
        res.render('produccion/operadores/ofterminadas', {datosofCerradas, rolusuario})
    }
});

router.get('/ordenesfabricacionabiertas', isLoggedIn, operador, async (req, res) => {
    const userId = req.user.iduser;
    const rolusuario = req.user.rolusuario;
    const datosOfCreadas = await pool.query('select * from datosof where idstatus=1;');
    res.render('produccion/operadores/ofCreadas', {datosOfCreadas, rolusuario})
    //console.log(rolusuario);




});






router.get('/detallesof/:id', isLoggedIn, digitador,  async (req, res) => {
    const userId = req.user.iduser;
    const ordenid = req.params.id;
    const rolusuario = req.user.rolusuario;

    const datosPara = await pool.query('select * from datosPara where idOrdenFabricacion=?', [ordenid]);
    const horasPara = await pool.query('select sec_to_time(sum(time_to_sec(horasPara))) as horasPara, idOrdenFabricacion from horasPara where idOrdenFabricacion=?', [ordenid])
    const ayudantesOrden = await pool.query("SELECT IF(dOH.HoraEntrada <= dOH.HoraSalida, TIME_FORMAT(TIMEDIFF(dOH.HoraSalida, dOH.HoraEntrada), '%H:%i:%s'), TIME_FORMAT(ADDTIME(TIMEDIFF('24:00:00', dOH.HoraEntrada), dOH.HoraSalida), '%H:%i:%s')) AS TiempoTrabajado, dOH.* FROM dataOperadoresHoras dOH WHERE IdOrden = ?;", [ordenid]);
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
        ayudantesOrden,
        dataOperadorPrincipal: dataOperadorPrincipal[0],
        dataOperadorAyudantes: dataOperadorAyudante[0],
        dataOperadorAyudante,
        horasymin,
        rolusuario
    })
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
    const personaOrden = await pool.query('select * from operador where idUsuario=? and idOrdenFabricacion=?', [userId, idOrdenFabricacion.id]);
    if (personaOrden.length > 0) {
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
    //console.log(operador);
    await pool.query('insert into operador set ?;', [operador]);
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
    const userOrden = await pool.query('select idtipoOperador, idUsuario, idTipoMarca from operador where idOrdenFabricacion=? and idUsuario=? ORDER BY idTipoMarca DESC LIMIT 1', [ordenid, userId]);
    const ayudantesOrden = await pool.query('select idUsuario, idtipoOperador, idTipoMarca, u.fullname from operador inner join usuario u on operador.idUsuario=u.iduser where idtipoOperador=2 and idOrdenFabricacion=? and idTipoMarca=1;', [ordenid]);

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
    await pool.query('insert into horasParas set ?', [horas_Para]);
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

    const operadores = await pool.query('select idUsuario, idTipoMarca from operador where idOrdenFabricacion=? group by idUsuario;', [ordenid]);
    for (let i = 0; i < operadores.length; i++) {
        const idOperador = operadores[i].idUsuario;
        const previs = await pool.query('select idUsuario, idOrdenFabricacion, idTipoMarca from operador where idUsuario=? and idOrdenFabricacion=?', [idOperador, ordenid]);
        if (previs.length > 1) {
            console.log('el operador con el id', +idOperador, "Ya se fue")
        } else {
            console.log('el operador con el id', +idOperador, "Solo entró")
            await pool.query('insert into operador (idtipoOperador, idUsuario, idOrdenFabricacion, idTipoMarca)  values (?,?,?,?);', [2, idOperador, ordenid, 2]);
        }
        ;
    }
    //const operadoresSalieron= await pool.query('select idUsuario, idTipoMarca from operador where (idOrdenFabricacion=? and idTipoMarca=2) and idUsuario=?;',[ordenid, 11]);
    //console.log(operadoresSalieron);
    res.redirect('/detallesofoperador/' + ordenid)
});

/*

//Ruta del formulario
router.get('/formularioInicial', async(req, res )=>{
   res.render('/la_vista_que_renderiza_el_formulario ')
});

router.get('/formularioFinal/:id', async(req, res )=>{
    const id = req.params; //Recojes el id de la orden que vienen en parametro de la url
    //Pasas el id que recojiste en el params
    const data = await pool.query('select * from nametable where id=?', [id])
    res.render('/la_vista_que_renderiza_el_segundo_formulario ', {data})//Renderizas los datos del formulario
});


router.post('/formularioInicial', async(req, res )=>{
    const {dato1, dato2, dato3}=req.body; //Recojo los datos
    const data= {
        dato1, dato2, dato3
    } //destructuring para pasarlo al query
    await pool.query('insert into name_tabla set ?', [data]); //Lo inserto en la bbdd
    //Buscas el ultimo id de la tabla insertado y lo recuperas en una variable
    const id = await pool.query('SELECT id_columna FROM name_table  ORDER BY idOrdenFabricacion DESC LIMIT 1;');
    res.redirect('/formularioFinal/'+id); //Rediriges a la segunda vista enviando como parametro el id de el ultimo insert
});

router.post('/formularioFinal/:id', async(req, res )=>{
    const id=req.params;
    const {dato1, dato2, dato3}=req.body; //Recojo los datos
    const data= {
        dato1, dato2, dato3
    } //destructuring para pasarlo al query
    await pool.query('update name_tabla set ? where id', [data, id]); //Lo inserto en la bbdd valiudando que el id sea el correcto
    res.redirect('/pantalla_succesfull'); //Rediriges a la vista mostrando que se hizo de manera correcta el insert o agradeciendo yo que se
});
 */

module.exports = router;