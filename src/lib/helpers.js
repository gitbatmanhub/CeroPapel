const bcryptjs = require('bcryptjs');

const helpers =  {};

helpers.encryptPassword= async (password)=>{
    const salt= await bcryptjs.genSalt(10);
    const hash= await bcryptjs.hash(password, salt);
    return hash;
};

helpers.matchPassword =async (password, savedPassword)=>{
    try{
        await bcryptjs.compare(password, savedPassword);
    } catch (e){
        console.log(e);
    }

}



module.exports = helpers;
