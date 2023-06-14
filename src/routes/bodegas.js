const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions, coordinadorCompras} = require('../lib/auth');




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
    //const codigoValidar= req.body.codigo;
    //const validarCodigo= await pool.query('select idProducto from producto where codigo=?;', [codigoValidar]);
    const dataProducto = {
        codigo: codigo.toUpperCase(),
        nameProducto: nameProducto.toUpperCase(),
        unidad,
        saldo,
        DetallesProducto: DetallesProducto.toUpperCase()

    }
    req.flash('success', 'Item agregado correctamente con el codigo '+ codigo );
    await pool.query('insert into producto set ?', [dataProducto]);
    const accion={
        idAcciones:1,
        idUsuario:req.user.iduser
    }

    res.redirect('/addproducto')

})



router.post('/verificar-codigo',isLoggedIn, async (req, res)=>{
    const codigo= req.body.codigo;
    //console.log(req.body)
    //console.log(codigo)
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


router.post('/datos-producto',isLoggedIn, async (req, res)=>{
    const idProducto= req.body.idProducto;
    //console.log(req.body)
    //console.log(idProducto)
    try {
        const producto = await pool.query('SELECT * FROM producto WHERE idProducto = ?', [idProducto]);
        //console.log(producto);
        if (producto.length > 0) {
            res.json({producto: producto[0] });
        } else {
            res.json({producto: null });
        }
    } catch (error) {
        console.error('Error al consultar la base de datos', error);
        res.status(500).json({ error: 'Error al consultar la base de datos' });
    }
});


router.post('/update-producto', isLoggedIn, async (req, res)=>{
    console.log(req.body);
    const {saldo, idProducto}= req.body;
    const dataUpdate ={
      saldo,
      idProducto
    };
    await pool.query('update producto set saldo=? where idProducto=?;', [saldo, idProducto]);
    req.flash('success', 'Producto actualizado correctamente');
    res.redirect('/addproducto');
})



module.exports = router;