const express = require('express');
const router = express.Router();

const pool = require('../database');
const{isLoggedIn, isNotLoggedIn}=require('../lib/auth');

router.get('/agregarOrden',  isLoggedIn, async (req, res) => {
    const areas = await pool.query('select * from areas');
    const maquinas = await pool.query('select * from maquinas');
    res.render('ordenes/agregarorden', {areas, maquinas});

});

router.post('/agregarOrden', isLoggedIn, async (req, res) => {
    const {area, descripcion, prioridad, estado, maquina} = req.body;
    const newOrden = {
        area,
        descripcion,
        prioridad,
        estado,
        maquina,
        user_id : req.user.id

    };
    await pool.query('INSERT INTO ordenesTrabajo set ?', [newOrden]);
    req.flash('success', 'Orden agregada correctamente');
    res.redirect('/orden');
});


router.get('/', isLoggedIn, async (req, res) => {
    const ordenes = await pool.query('SELECT ordenestrabajo.*, users.fullname FROM novared.ordenestrabajo, novared.users where ordenestrabajo.user_id = users.id', [req.user.id]);
    const areas = await pool.query('select * from areas');

    console.log(areas);

    res.render('ordenes/listOrden', {ordenes, areas});
});

/*
router.get('/agregarorden', isLoggedIn, async (req, res)=>{
    const areas = await pool.query('select * from areas');
    console.log(areas);
    res.render('ordenes/agregarorden', {areas});
})

 */







router.get('/delete/:id', async (req, res) => {
    const {id} = req.params;
    await pool.query('DELETE FROM ordenesTrabajo where id=?', [id]);
    req.flash('error', 'Orden eliminada correctamente');
    res.redirect('/orden');
});

router.get('/edit/:id', isLoggedIn, async (req, res) => {
    const {id} = req.params;
    const ordenes = await pool.query('SELECT * FROM ordenesTrabajo WHERE id=?', [id]);
    res.render('ordenes/edit', {orden: ordenes[0]});
});

router.get('/view/:id', isLoggedIn, async (req, res) => {
    const {id} = req.params;
    const ordenes = await pool.query('SELECT * FROM ordenesTrabajo WHERE id=?', [id]);
    res.render('ordenes/view', {orden: ordenes[0]});
});


router.post('/edit/:id',  async (req, res) => {
    const {id} = req.params;
    const {area, descripcion, prioridad, estado, maquina} = req.body;
    const newOrden = {
        area,
        descripcion,
        prioridad,
        estado,
        maquina
    }
    await pool.query('UPDATE ordenesTrabajo set ? WHERE id = ?', [newOrden, id]);
    req.flash('success', 'Orden actualizada correctamente');
    res.redirect('/orden');
})






module.exports = router;