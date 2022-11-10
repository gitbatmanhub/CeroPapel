const express = require('express');
const router = express.Router();

const pool = require('../database');
const{isLoggedIn, isNotLoggedIn}=require('../lib/auth');


/*
router.get('/datos_selects', isLoggedIn, async (req, res) => {
    const ordenes = await pool.query('Select * from ordenesTrabajo where user_id = ?', [req.user.id]);
    res.render('ordenes/listOrden', {ordenes});
});
*/