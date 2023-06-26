const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions, coordinadorCompras} = require('../lib/auth');
const {logger} = require("browser-sync/dist/logger");


router.post('/agregar-tula', isLoggedIn, async (req, res)=>{
        const {peso, idReferencial, idColor, idOrdenFabricacion, idProceso, idMaterial, idTipoMaterial, idTipoTicket}= req.body;
        const DataSalida ={
            peso,
            idReferencial,
            idColor,
            idOrdenFabricacion,
            idProceso,
            idMaterial,
            idTipoMaterial,
            idTipoTicket
            };
        await pool.query('insert into tula set ?', [DataSalida])
    res.redirect('/detallesofoperador/'+idOrdenFabricacion);
req.flash('succes', "Listo Calisto")
    //console.log(data);
})

router.get('/agregar-procesos-materiales', isLoggedIn, async (req, res)=>{

    res.send("Jelou")
})



module.exports = router;