const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const pool= require('../database');
const helpers= require('../lib/helpers');
passport.use('local.registrarse', new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password',
    passReqToCallback: true
}, async (req, username, password, done) => {
    const {fullname} = req.body;
        const newUser={
            username,
            password,
            fullname
        };
        newUser.password= await helpers.encryptPassword(password);
        const result= await pool.query('insert into users SET ?', [newUser]);
        newUser.id = result.insertId;
        return done(null, newUser);
}));

passport.serializeUser((user, done)=>{
    done(null, user.id);

});

passport.deserializeUser(async(id, done)=>{
    const rows= await pool.query('select * from users where id = ?', [id]);
    done(null, rows[0]);
})
