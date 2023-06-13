const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions, coordinadorCompras} = require('../lib/auth');
const {addCwdToWatchOptions} = require("browser-sync/dist/cli/transforms/addCwdToWatchOptions");
const {connect} = require("browser-sync/dist/utils");
const {errors} = require("browser-sync/dist/config");



router.get('/addrequerimientobodega', isLoggedIn, async (req, res)=>{
    const ordenes= await pool.query('select idOrdenTrabajo from ordentrabajo where idStatus !=7;')
    console.log(ordenes);
    res.render('bodegas/addrequerimientobodega', {ordenes});
})

router.get('/requerimientosbodega', isLoggedIn, async (req, res)=>{

    res.render('bodegas/requerimientosbodega');
})

router.get('/addproducto', isLoggedIn, coordinadorCompras, async (req, res) => {
    const productos = await pool.query('select * from producto');
    res.render('ordenes/liderMantenimiento/addRecursos/producto', {productos});
    //console.log(req.body);
})
router.post('/addproducto', coordinadorCompras, async (req, res) => {
    const {codigo, nameProducto, unidad,saldo, DetallesProducto} = req.body;
    const codigoValidar= req.body.codigo;
    const validarCodigo= await pool.query('select idProducto from producto where codigo=?;', [codigoValidar]);
    if (validarCodigo.length>0){
        const idProducto= validarCodigo[0].idProducto;
        req.flash('error', 'Item ya existe, buscalo con el id '+idProducto);
    }else {
        const dataProducto = {
            codigo: codigo.toUpperCase(),
            nameProducto: nameProducto.toUpperCase(),
            unidad,
            saldo,
            DetallesProducto: DetallesProducto.toUpperCase()

        }
        req.flash('success', 'Item agregado correctamente con el coddigo '+ codigo );
        await pool.query('insert into producto set ?', [dataProducto]);
    }
    res.redirect('/addproducto')

})



router.post('/verificar-codigo',isLoggedIn, async (req, res)=>{
    const codigo= req.body.codigo;
    console.log(req.body)
    console.log(codigo)
    const verificarCodigo=  pool.query('select count(*) as vf from producto where codigo=?', [codigo], (error, results)=>{
        if(error){
            console.log("Error al consultar la base de datos", error);
            res.status(500).json({error: 'Error al consultar la base de datos'});
        }else {
            const vf=results[0].vf;
            const existe= vf>0;
            res.json({existe:existe})
        }
    })
    });
    //connection.query(verificarCodigo, [codigo], (error, results)=> {





module.exports = router;