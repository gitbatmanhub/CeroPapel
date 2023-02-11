const express = require('express');
const router = express.Router();
const{isLoggedIn, isNotLoggedIn}=require('../lib/auth');

router.get('/', isLoggedIn, async (req, res) => {
    /*await pool.query('select u.fullname, u.username from tecnico inner join bddnova.usuario u on tecnico.idUser = u.iduser;');*/
    res.render("index")
})




module.exports = router;
