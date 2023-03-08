module.exports = {

    isLoggedIn(req, res, next) {
        // Aquí la data de entrada
        //console.log(req.user);
        if (req.isAuthenticated()) {
            return next();
        }
        return res.redirect('/ingresar');

    },
    isNotLoggedIn(req, res, next) {
        if (!req.isAuthenticated()) {
            return next();

        }
        return res.redirect('/profile');
    },
    permissions(req, res, next) {
        const rolusuario=req.user.rolusuario;
        if( rolusuario === 4 && rolusuario === 3){
            return res.redirect('/');

        }else {
            return next();

        }


        /*
        switch (req.user.idRol) {
            case 5:
                return next();
            case 4:
                return res.redirect('/');
        }

         */
    }
}