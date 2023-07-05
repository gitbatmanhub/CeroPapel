const express = require('express');
const router = express.Router();
const{isLoggedIn, isNotLoggedIn}=require('../lib/auth');
const pool = require('../database');
const {ca} = require("timeago.js/lib/lang");

router.get('/', isLoggedIn, async (req, res) => {
    /*await pool.query('select u.fullname, u.username from tecnico inner join bddnova.usuario u on tecnico.idUser = u.iduser;');*/
    res.render("index")
})



router.get('/dashboardreport', async(req, res)=>{

    const data1= await pool.query('select * from maquinaria;')
    //console.log(data1)
    res.render('dashboardReport/dashboardreport', {data1})
})


router.post('/peso-maquina', isLoggedIn, async (req, res)=>{
    //await pool.query("SET time_zone = '-05:00'");

    console.log(req.body);
    const {fechaInicial, fechaFinal}= req.body;
    const data = {
        fechaInicial,
        fechaInicial
    };
    console.log(fechaInicial)
    console.log(fechaFinal)

    const esteban = new Date();
    console.log(esteban);
    try{
        const peso = await pool.query("select sum(KgProcesados) from chartMaquinas where idMaquinaria=4 and FechaCompleta between ? and ?;", [fechaInicial, fechaFinal])
        if (peso != null){
            console.log(peso[0])
            res.json({peso: peso[0]})
        }else {
            res.json({peso: null})
        }
    }catch (error){
        console.log(error)
    }

})

module.exports = router;
