//Validar AgregarOrden


const area = document.forms["formularioAgregar"]['area'].selectedIndex;
const maquina = document.forms["formularioAgregar"]['maquina'].selectedIndex;
const descripcionAO = document.getElementById('descripcionAO').value;
const errorA= document.getElementById('errorA');
const errorM= document.getElementById('errorM');
const errorD= document.getElementById('errorD');
//error.style.color= red;

const mensajeErrorA=[];
const mensajeErrorM=[];
const mensajeErrorD=[];


const form= document.getElementById('formAgregar');
form.addEventListener('submit', function(evt, ){
    evt.preventDefault();


    if (area == null || area == 0) {
        mensajeErrorA.push('Por favor selecciona un área para la orden');
        errorA.innerHTML= mensajeErrorA;

    }
    if (maquina == null || maquina == 0) {
        mensajeErrorM.push('Por favor selecciona una maquina para la orden');
        errorM.innerHTML= mensajeErrorM;


    }
    //Validar textarea
    if (descripcionAO.length === null || descripcionAO.length === 0) {
        mensajeErrorD.push('Por favor escribe una descripción para la orden');
        errorD.innerHTML= mensajeErrorD;


    }


    //error.innerHTML= mensajeError.join('');

});














/*


function validationAO() {
    const area = document.forms["formularioAgregar"]['area'].selectedIndex;
    const maquina = document.forms["formularioAgregar"]['maquina'].selectedIndex;
    const descripcionAO = document.getElementById('descripcionAO').value;

    if (area == null || area == 0) {
        alert('Por favor selecciona un área para la orden');
    }
    if (maquina == null || maquina == 0) {
        alert('Por favor selecciona una maquina para la orden');
    }
    //Validar textarea
    if (descripcionAO.length == '') {
        alert('Por favor escribe una descripción para la orden');
    }
}


 */

//Validar VerOrden
/*
    function validationVO(){

    const descripcionVO = document.getElementById('descripcionVO').value;
    if (descripcionVO.length == '') {

        alert('Por favor proporciona una descripción para la orden');

    }


    }


//Alto cajas de texto igual al contenido
let areas = document.querySelectorAll(".cajas-texto");

window.addEventListener("DOMContentLoaded", () => {
    areas.forEach((elemento) => {
        elemento.style.height = `${elemento.scrollHeight}px`
    })
});


 */
