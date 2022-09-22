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
    req.flash('success', 'Orden agregada correctamente');
    res.redirect('/orden');
});


router.get('/', async (req, res)=>{
    const ordenes = await pool.query('Select * from ordenesTrabajo');
    console.log(ordenes);
    res.render('ordenes/listOrden', {ordenes});
});

router.get('/delete/:id', async(req, res)=>{
    const {id}= req.params;
    await pool.query('DELETE FROM ordenesTrabajo where id=?', [id]);
    req.flash('error', 'Orden eliminada correctamente');
    res.redirect('/orden');
});

router.get('/edit/:id', async(req, res)=>{
    const {id} = req.params;
   const ordenes =  await pool.query('SELECT * FROM ordenesTrabajo WHERE id=?', [id]);
    res.render('ordenes/edit', {orden: ordenes[0]});
});





router.post('/edit/:id', async(req, res)=>{
    const {id} = req.params;
    const {area, descripcion}= req.body;
    const newOrden = {
        area,
        descripcion
    }
    await pool.query('UPDATE ordenesTrabajo set ? WHERE id = ?', [newOrden, id]);
    req.flash('success', 'Orden actualizada correctamente');
    res.redirect('/orden');
})








module.exports = router ;