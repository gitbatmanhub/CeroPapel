

/*
let $area= document.getElementById('areas');
$area.addEventListener('change', function () {
    let valor = $area.value;
    switch (valor){
        case 'Edificio':


            break
        case 'Compactadora':

            break
        case 'Equipos Auxiliares':

            break

    }
});


$area.addEventListener('change', function (){
    let valor = $area.value


})



 */

/*
funciona pero no valida
function ShowSelected() {

    var codArea = document.getElementById("area").value;
    console.log(codArea);
    return codArea;

}

 */

var areaSelect = document.getElementById('area');
areaSelect.addEventListener('change', function(){
        var areaseleccionada = this.options[areaSelect.selectedIndex];
        ////////Obtener el valor y el texto
        //console.log(selectedOption.value + ': ' + selectedOption.text);
        let variable = areaseleccionada.value;
        //console.log(variable);
        console.log(areaseleccionada.value);
        if (variable==1){
            console.log(areaSelect.value);
        }else if(variable==2){
            console.log(areaSelect.value);
        }


    });



var maquinaSelect = document.getElementById('maquina');
console.log(maquinaSelect.options);
