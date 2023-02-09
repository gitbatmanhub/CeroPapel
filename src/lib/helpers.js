const bcryptjs = require('bcryptjs');

const helpers =  {};
const Handlebars = require('handlebars')

helpers.encryptPassword= async (password)=>{
    const salt= await bcryptjs.genSalt(10);
    const hash= await bcryptjs.hash(password, salt);
    return hash;
};

helpers.matchPassword =async (password, savedPassword)=>{
    try{
        return await bcryptjs.compare(password, savedPassword);
    } catch (e){
        console.log(e);
    }

}

Handlebars.registerHelper( "when",function(operand_1, operator, operand_2, options) {
    const operators = {
        'eq': function(l,r) { return l == r; },
        'noteq': function(l,r) { return l != r; },
        'gt': function(l,r) { return Number(l) > Number(r); },
        'or': function(l,r) { return l || r; },
        'and': function(l,r) { return l && r; },
        '%': function(l,r) { return (l % r) === 0; }
    }
        , result = operators[operator](operand_1,operand_2);

    if (result) return options.fn(this);
    else  return options.inverse(this);
});




module.exports = helpers;
