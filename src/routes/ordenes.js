const express = require('express');
const router = express.Router();

const pool= require('../database');


router.get('/agregarOrden',(req, res)=>{
    res.render('ordenes/agregarOrden');

    });

router.post('/agregarOrden', async (req, res)=>{
    const {  area, descripcion } = req.body;
    const newOrden={

        area,
        descripcion
    };
    await pool.query('INSERT INTO ordenesTrabajo set ?', [newOrden]);
    res.redirect('/orden');
});


router.get('/', async (req, res)=>{
    const ordenes = await pool.query('Select * from ordenesTrabajo');
    console.log(ordenes);
    res.render('ordenes/listOrden', {ordenes});
});



module.exports = router ;