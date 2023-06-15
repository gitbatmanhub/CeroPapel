const express= require('express');
const morgan = require('morgan');
const exphbs= require('express-handlebars');
const path= require('path');
const flash= require('connect-flash');
const session =require('express-session');
const MySQLStore = require('express-mysql-session');
const {database} = require('./keys');
const passport= require('passport');

//Inicialisaciones

const app = express();
require('./lib/passport');


//Settings
app.set('port', process.env.PORT || 4000);
//app.set('port', process.env.PORT || 80);

app.set('views', path.join(__dirname, 'views'));
app.engine('.hbs', exphbs.engine({
    defaultLayout: 'main',
    layoutsDir: path.join(app.get('views'), 'layouts'),
    partialsDir: path.join(app.get('views'), 'partials'),
    extname: '.hbs',
    helpers: require('./lib/handlebars')

}));
app.set('view engine', '.hbs');


//Middlewares
app.use(session({
    secret: 'Holaquehace2.0',
    resave: false,
    saveUninitialized: false,
    store: new MySQLStore(database)

}));
app.use(flash());
app.use(morgan('dev'));
app.use(express.urlencoded({extended:false}));
app.use(express.json());
app.use(passport.initialize());
app.use(passport.session());


// Global Variables
app.use((req, res, next) => {
    app.locals.success =req.flash('success');
    app.locals.message =req.flash('message');
    app.locals.error =req.flash('error');
    app.locals.user = req.user;
    next();
});




// Routes
app.use(require('./routes/'));
app.use(require('./routes/authentication'));
app.use('/', require('./routes/ordenes'));
app.use('/', require('./routes/ordenfabricacion'));
app.use('/', require('./routes/bodegas'));
app.use('/', require('./routes/procesos'));



//Public
app.use(express.static(path.join(__dirname, 'public')));





//Starting the server
app.listen(app.get('port'), ()=>{
    console.log('Server on port', app.get('port'));
});
app.use(function(req, res, next) {
    res.status(404).redirect('/'); // Redirige a la página de error404
});
