const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions} = require('../lib/auth');
const {el, de} = require("timeago.js/lib/lang");

//Rutas de admin

router.get('/agregarof', isLoggedIn, permissions, async (req, res)=>{
   //console.log(req.user);
   //const todasordenes = await pool.query('select * from ordenFabricacion');
   const maquinarias = await pool.query('select * from maquinaria');
   const turno = await pool.query('select * from turno');
   const operador =await pool.query('select u.fullname, t.nameTipoOperador, o.idOperador from operador o inner join usuario u on o.idUsuario=u.iduser inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador where t.idTipoOperador=1;')
   //console.log(todasordenes);
   res.render('produccion/addordenfabricacion', { maquinarias, turno, operador})
});

router.post('/agregarof', isLoggedIn, permissions, async (req, res)=>{
   const {fecha, idMaquinaria, idTurno, idOperador, idstatus}=req.body;
   //console.log(req.body);
   const ordenfabricacion={
      fecha,
      idMaquinaria,
      idTurno,
      idOperador,
      idstatus,
      idCreador: req.user.iduser
   }
   await pool.query('INSERT INTO ordenFabricacion set ?', [ordenfabricacion]);
   req.flash('success', 'Orden de fabricacion agregada correctamente');

   res.redirect('/ordenesfabricacion')

});



router.get('/ordenesfabricacion', isLoggedIn, permissions, async (req, res)=>{
   const todasordenes = await pool.query('select * from ordenFabricacionTodosDatos');

   res.render('produccion/ordenesfabricacion', {todasordenes})
});

router.get('/tipoOperador', isLoggedIn, permissions, async (req, res)=>{
   const operadores= await pool.query('select * from usuario where rolusuario=5;')
   const tipoOperador=await pool.query('select * from tipoOperador');
   res.render('ordenes/paneladmin/tipooperador', {operadores, tipoOperador})
});


router.post('/edittipoOperador/', isLoggedIn, permissions, async (req, res) => {
   const {idUser, idTipoOperador} = req.body;
   console.log(idUser, idTipoOperador);
   const idUserdb= await pool.query('select * from operador where idUsuario=?', [idUser])
   if (idUserdb.length>0){
      await pool.query('update operador set idtipoOperador=? where idUsuario=?;', [idTipoOperador, idUser]);
      req.flash('success', 'Operador actualizado correctamente')
   }else {
      await pool.query('insert into operador (idtipoOperador, idUsuario) values (?, ?);', [idTipoOperador, idUser]);
      req.flash('success', 'Operador Designado correctamente')
   }

   res.redirect('/tipoOperador/');
});


router.get('/detallesof/:id', permissions, isLoggedIn, async (req, res )=>{
   const detallesOrden= await pool.query('select * from ordenFabricacionTodosDatos where idOrdenFabricacion=?;', [req.params.id])
   console.log(detallesOrden);
   res.render('produccion/detallesof', {detallesOrden: detallesOrden[0]})
});




//A partir de aquí las rutas de los tecnicos



module.exports = router;