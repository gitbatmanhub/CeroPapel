const {format}= require('timeago.js');


const helpers={};

helpers.timeago = (timestamp)=>{
    return format(timestamp);

}




const timestamp= require('timestamp-to-date');
module.exports = helpers;



