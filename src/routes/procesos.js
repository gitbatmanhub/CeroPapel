const express = require('express');
const router = express.Router();

const pool = require('../database');
const {isLoggedIn, permissions, coordinadorCompras} = require('../lib/auth');






module.exports = router;