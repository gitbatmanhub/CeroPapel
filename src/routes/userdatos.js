const express = require('express');
const router = express.Router();

const pool = require('../database');
const{isLoggedIn, isNotLoggedIn}=require('../lib/auth');






module.exports = router;

/*
router.get('/profile', isLoggedIn, async (req, res) => {
    const datos = await pool.query('Select * from users where user_id = ?', [req.user.id]);
    console.log(datos);
    res.render('/profile', {datos});

});

 */



