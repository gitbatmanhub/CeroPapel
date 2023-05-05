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






module.exports = router;