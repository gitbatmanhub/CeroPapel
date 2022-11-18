const express = require('express');
const router = express.Router();

const pool = require('../database');
const{isLoggedIn, isNotLoggedIn}=require('../lib/auth');

router.get('/agregarOrden',  isLoggedIn, async (req, res) => {
    const areas = await pool.query('select * from areas');
    const maquinas = await pool.query('select * from maquinas');
    res.render('ordenes/agregarorden', {areas, maquinas});
    //console.log(areas);
    //console.log(maquinas);

});

router.post('/agregarOrden', isLoggedIn, async (req, res) => {
    const {area, descripcion, prioridad, estado, maquina} = req.body;
    const newOrden = {
        area,
        descripcion,
        prioridad,
        estado,
        maquina,
        user_id : req.user.id

    };
    await pool.query('INSERT INTO ordenesTrabajo set ?', [newOrden]);
    req.flash('success', 'Orden agregada correctamente');
    res.redirect('/orden');
});



//////////////////////////////////
/*
router.get('/', isLoggedIn, async (req, res) => {
    const users = await pool.query('select * from users;', [req.user.idRol]);
    const idRol= ([req.user.idRol][0]);

    console.log(idRol);
    switch (idRol) {
        case 1:
            break;
        case 2:
            res.send('Supervisor');
            break;
        case 3:
            res.send("Lider Mantenimiento");
            break;
        case 4:
            res.send("Tecnico");
            break;
            case 5:
                res.redirect('/orden');
                break;

        default:
            res.send("No tienes asignado un rol");
            break;
    }





});


 */


//////////////////////////////////
router.get('/', isLoggedIn, async (req, res) => {
    const users = await pool.query('SELECT * from users', [req.user.idRol]);
    const idRol= ([req.user.idRol][0]);
    console.log(idRol);

    switch (idRol) {
        //Claudio
        case 5:
            const ordenes = await pool.query('SELECT ordenestrabajo.*, users.fullname  FROM novared.ordenestrabajo, novared.users where ordenestrabajo.user_id = users.id AND ordenestrabajo.idStatus=0', [req.user.id]);
            res.render('ordenes/listOrden', {ordenes});
            break;
            //Andres
        case 3:
            const ordenesAceptadas = await pool.query('SELECT ordenestrabajo.*, users.fullname FROM novared.ordenestrabajo inner join users on users.id=ordenestrabajo.id inner join statusorden on ordenestrabajo.id=statusorden.idStatus', [req.user.id]);
            res.render('ordenes/liderMantenimiento/listaOrdenLM', {ordenesAceptadas});
            break;
        case 4:
            res.send("Eres Esteban");
            break;
        case 1:
            res.send("Eres Admin");
            break;
        default:
            res.send("No tienes asignado un rol");
            break;
    }


});

/*

        router.get('/', isLoggedIn, async (req, res) => {
            const ordenes = await pool.query('SELECT ordenestrabajo.*, users.fullname FROM novared.ordenestrabajo, novared.users where ordenestrabajo.user_id = users.id', [req.user.id]);
            const idUser= ([req.user.id][0]);
            console.log(idUser);

                switch (idUser) {
                    case 1:
                        res.send('Eres Edwin');
                        break;
                    case 100:
                        res.render('ordenes/listOrden', {ordenes});
                        break;
                    case 3:
                        res.send("Eres Nathy");
                        break;
                    case 4:
                        res.send("Eres Esteban");
                        break;
                    default:
                        res.send("No tienes asignado un rol");
                        break;
                }


        });



router.get('/', isLoggedIn, async (req, res) => {
    const ordenes = await pool.query('SELECT ordenestrabajo.*, users.fullname FROM novared.ordenestrabajo, novared.users where ordenestrabajo.user_id = users.id', [req.user.id]);
    res.render('ordenes/listOrden', {ordenes});
});


*/




router.get('/delete/:id', async (req, res) => {
    const {id} = req.params;
    await pool.query('DELETE FROM ordenesTrabajo where id=?', [id]);
    req.flash('error', 'Orden eliminada correctamente');
    res.redirect('/orden');
});

router.get('/edit/:id', isLoggedIn, async (req, res) => {
    const {id} = req.params;
    const ordenes = await pool.query('SELECT * FROM ordenesTrabajo WHERE id=?', [id]);
    res.render('ordenes/edit', {orden: ordenes[0]});
});

router.get('/view/:id', isLoggedIn, async (req, res) => {
    const {id} = req.params;
    const ordenes = await pool.query('SELECT * FROM ordenesTrabajo WHERE id=?', [id]);
    res.render('ordenes/view', {orden: ordenes[0]});
});


router.post('/view/:id', isLoggedIn, async (req, res) => {
    /*
    console.log(req.body);
    res.send('received');

     */


    const {idOrden, idUserCreo, comentariosSupervisor} = req.body;
    const newOrdenAprobada = {
        idOrden,
        idUserCreo,
        idAprobo: req.user.id,
        comentariosSupervisor
    };
    await pool.query('INSERT INTO ordenesaprobadas set ?', [newOrdenAprobada]);
    //await pool.query('UPDATE orde SET sobreMi="Funciona" WHERE id = 1');
    req.flash('success', 'Orden Aprobada correctamente');
    res.redirect('/orden');


});





router.post('/edit/:id',  async (req, res) => {
    const {id} = req.params;
    const {area, descripcion, prioridad, estado, maquina} = req.body;
    const newOrden = {
        area,
        descripcion,
        prioridad,
        estado,
        maquina
    }
    await pool.query('UPDATE ordenesTrabajo set ? WHERE id = ?', [newOrden, id]);
    req.flash('success', 'Orden actualizada correctamente');
    res.redirect('/orden');
})






module.exports = router;