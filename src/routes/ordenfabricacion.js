const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions} = require('../lib/auth');
const {el} = require("timeago.js/lib/lang");



router.get('/agregarof', isLoggedIn, permissions, async (req, res)=>{
   console.log(req.user);
   const todasordenes = await pool.query('select * from ordenFabricacion');
   const maquinarias = await pool.query('select * from maquinaria');
   const turno = await pool.query('select * from turno');
   console.log(todasordenes);
   res.render('produccion/addordenfabricacion', {todasordenes, maquinarias, turno})
});

router.post('/agregarof', isLoggedIn, permissions, async (req, res)=>{

   res.redirect('produccion/ordenesfabricacion')
});



router.get('/ordenesfabricacion', isLoggedIn, permissions, async (req, res)=>{

   res.render('produccion/ordenesfabricacion')
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









module.exports = router;