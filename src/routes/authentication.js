const express = require('express');
const pool = require("../database");
const router = express.Router();

const passport = require('passport');

const {tr} = require("timeago.js/lib/lang");


router.get('/registrarse', async (req, res) => {
    res.render('authentication/registrarse');
});


router.post('/registrarse', passport.authenticate('local.registrarse', {
    successRedirect: '/profile',
    failureRedirect: '/registrarse',
    failureFlash: true
}))


router.get('/ingresar', async (req, res) => {
    res.render('authentication/ingresar');
});

router.post('/ingresar', async (req, res, next) => {
        passport.authenticate('local.ingresar', {
            successRedirect: '/profile',
            failureRedirect: '/ingresar',
            failureFlash: true

        })(req, res, next)
});


router.get('/profile', async (req, res) => {
    res.render('profile');
});


module.exports = router;