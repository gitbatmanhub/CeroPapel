const express = require('express');
const pool = require("../database");
const router = express.Router();

const passport = require('passport');
const{ isLoggedIn, isNotLoggedIn } = require('../lib/auth.js')

const {tr} = require("timeago.js/lib/lang");


router.get('/registrarse', isNotLoggedIn, async (req, res) => {
    res.render('authentication/registrarse');
});


router.post('/registrarse', passport.authenticate('local.registrarse', {
    successRedirect: '/profile',
    failureRedirect: '/registrarse',
    failureFlash: true
}))


router.get('/ingresar', isNotLoggedIn, async (req, res) => {
    res.render('authentication/ingresar');
});

router.post('/ingresar', async (req, res, next) => {
        passport.authenticate('local.ingresar', {
            successRedirect: '/profile',
            failureRedirect: '/ingresar',
            failureFlash: true

        })(req, res, next)
});


router.get('/profile', isLoggedIn, async (req, res) => {
    res.render('profile');
});


router.get('/salir', isLoggedIn, (req, res) => {
    req.logout(function(err) {
        if (err) { return next(err); }
        res.redirect('/ingresar');
    });
});

module.exports = router;