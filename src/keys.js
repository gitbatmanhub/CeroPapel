const Process = require("process");
require('dotenv').config();

module.exports={



    database:{
        host: process.env.HOST,
        user: process.env.USER,
        password: process.env.PASSWORD,
        database: process.env.DATABASE
    }

};

//console.log(process.env.HOST)


