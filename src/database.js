const mysql= require('mysql');
const {promisify} = require('util');

const {database} = require('./keys');

const pool= mysql.createPool(database);
pool.getConnection((err, connection)=>{
    if(err){
        if(err.code === 'PROTOCOL_CONECTION_LOST'){
            console.error("LA CONEXION CON LA BASE DE DATOS FUE CERRADA")
        }if(err.code === 'ER_CON_COUNT_ERROR'){
            console.error("LA BASE DE DATOS TIENE MUCHAS CONEXIONES")
        }if(err.code === 'ECONNREFUSED'){
            console.error("CONEXIÓN FUE RECHAZADA")
        }
    }
   if(connection) connection.release();
    console.log('DATABASE CONNECTED');
    return;
});
//Promisify Pool Query (convertir promesas antes callbacks)
pool.query = promisify(pool.query)
module.exports = pool;