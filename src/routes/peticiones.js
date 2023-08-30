const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions, operador, digitador} = require('../lib/auth');
const {ca} = require("timeago.js/lib/lang");




router.post("/buscarMateriales", isLoggedIn, async (req, res)=>{
    const {idMaquinaria}=req.body;
    try{
        const materiales = await pool.query('select idMaterial, nameMaterial from MaquinariasMaterial where idMaquinaria=?;', [idMaquinaria]);
        //console.log(materiales)
        if (materiales){
            res.json({materiales})
        }else{
            res.json({materiales: "Lo siento no hay datos"})
        }
    }catch (error){
        console.log('Error al consultar la bbdd')
        res.status(500).json({error:"Error al consultar la bbdd"})
    }
})























module.exports = router;
