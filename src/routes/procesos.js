const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions, coordinadorCompras} = require('../lib/auth');


router.get('/agregar-tula', isLoggedIn, async (req, res)=>{


    res.send('funciona')
})

router.get('/agregar-procesos-materiales', isLoggedIn, async (req, res)=>{

    res.send("Jelou")
})



module.exports = router;