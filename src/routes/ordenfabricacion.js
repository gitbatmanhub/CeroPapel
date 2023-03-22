const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions} = require('../lib/auth');

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
   //console.log(idUser, idTipoOperador);
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
   const operadores = await pool.query('select u.fullname, o.idOperador,t.nameTipoOperador from operador o inner join tipoOperador t on o.idtipoOperador = t.idTipoOperador inner join usuario u on o.idUsuario = u.iduser');
   res.render('produccion/detallesof', {detallesOrden: detallesOrden[0], operadores})
});




//A partir de aquí las rutas de los tecnicos

router.get('/ofsasignadas', isLoggedIn, async (req, res)=>{
   const userid=req.user.iduser;
   const misoft = await pool.query('select * from ordenFabricacionTodosDatos where iduser=?;', [userid]);
   //console.log(misoft);
   res.render('produccion/operadores/ofsasignadas', {misoft})
});

router.get('/detallesofoperador/:id', permissions, isLoggedIn, async (req, res )=>{
   const idOrdenF=req.params.id;
   const detallesOrden= await pool.query('select * from ordenFabricacionTodosDatos where idOrdenFabricacion=?;', [idOrdenF])
   const datosPara = await pool.query('select * from tipopara;');
   const horasPara = await pool.query('select hP.inicioPara, hP.finPara, hP.comentario, t.nameTipoPara from horas_Para hP inner join tipopara t on hP.idTipoPara = t.idTipoPara where idOrdenFabricacion=?', [idOrdenF]);
   const material = await pool.query('select * from material');
   const maquinaria_Material = await pool.query('select m.idMaterial,mM.idMaquinaria_Material, m.nameMaterial from maquinaria_Material mM inner join material m on mM.idMaterial = m.idMaterial where idOrdenFabricacion=?', [idOrdenF])
   const kg_Material = await pool.query('select kg.pesoKg, kg.horasTrabajadas, m.nameMaterial from kg_material kg inner join material m on m.idMaterial=kg.idMaterial where kg.idOrdenFabricacion=?;',[idOrdenF])
   res.render('produccion/operadores/detallesofT', {detallesOrden: detallesOrden[0], datosPara, horasPara, material, maquinaria_Material, kg_Material})

});



router.post('/agregarPara', isLoggedIn, async(req, res)=>{
   const { idTipoPara, comentario, inicioPara, finPara, idOrdenFabricacion}= req.body;
   const horas_Para ={
      idTipoPara,
      comentario,
      inicioPara,
      finPara,
      idOrdenFabricacion
   };
   console.log(horas_Para)
   await pool.query('insert into horas_Para set ?', [horas_Para]);
   //await pool.query('insert into horas_Para (idTipoPara, comentario, inicioPara, finPara, idOrdenFabricacion) values (?,?,?,?,?)', [idTipoPara, comentario, inicioPara, finPara, idOrdenFabricacion])
   res.redirect('detallesofoperador/'+idOrdenFabricacion)
});

router.post('/agregarMaterial', isLoggedIn, async(req, res)=>{
   const { idMaterial, idOrdenFabricacion}= req.body;
   const maquinaria_Material ={
      idMaterial,
      idOrdenFabricacion
   };
   console.log(maquinaria_Material)
   await pool.query('insert into maquinaria_Material set ?', [maquinaria_Material]);
   res.redirect('detallesofoperador/'+idOrdenFabricacion)
});

router.post('/agregarKg', isLoggedIn, async(req, res)=>{
   const { pesoKg, horasTrabajadas, idOrdenFabricacion, idMaterial}= req.body;
   const kg_Material ={
      pesoKg,
      horasTrabajadas,
      idOrdenFabricacion,
      idMaterial
   };

   await pool.query('insert into kg_Material set ?', [kg_Material]);
   res.redirect('detallesofoperador/'+idOrdenFabricacion)
});

router.post('/cerrarof/:id', isLoggedIn, async(req, res)=>{
   const idOrdenFabricacion= req.body.idOrdenFabricacion;
   await pool.query('UPDATE ordenFabricacion SET idstatus=? WHERE idOrdenFabricacion=?', [2, idOrdenFabricacion]);
   res.redirect('/ofsasignadas/')
});



router.post('/ayudanteof', isLoggedIn, async (req, res)=>{
   console.log(req.body)
   res.redirect('/detallesof/')
});

module.exports = router;