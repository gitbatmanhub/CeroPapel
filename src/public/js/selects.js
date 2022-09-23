



let $area= document.getElementById('areas');
let $maquina= document.getElementById('maquinas');

let areas= ['Edificio', 'Compactadora', 'Equipos Auxiliares', 'Maquinas', 'PTAR', 'Garita', 'Molinos', 'Subestacion', 'Montacargas'];
let maquinaEdificio= ['Administrativo', 'Financiero', 'Producción', 'Logistica/BodegaPT'];
let maquinaCompactadora= ['Compactadora'];
let maquinaEquiposAuxiliares= ['Compresor JAGUAR I', 'Compresor JAGUAR II', 'Falta1', 'Falta2'];
let maquinaMaquinas= ['Pelletizadora 1', 'Pelletizadora 2' ,'Pelletizadora 3', 'Lavado Film', 'PET', 'Lavado Hogar', 'Lavado Zuncho', 'Clasificadora de colores'];
let maquinasPTAR=['PTAR'];
let maquinasGarita=['Garita', 'Puerta'];
let maquinasMolino=['Zuncho', 'Hogar', 'Film', 'PET', 'Trituradora'];
let maquinasSubestacion=['Transformador Inatra 250 KVA', 'Transformador Inatra 750 KVA'];
let maquinasMontacargas=['Montacargas 1 - 2.5T', 'Montacargas 2 - 2.5T', 'Montacargas 3 - 3T', 'Montacargas 4 - 3T'];


function mostrarAreas(arreglo, lugar){
    let elementos = '<option selected disabled>--Seleccine--</option>'
    for (let i = 0; i<arreglo.length; i++){
        elementos += '<option value="'+arreglo[i]+'" ">' +arreglo[i]+'</option>'
    }
    lugar.innerHTML=elementos;
}
mostrarAreas(areas, $area);

function recortar(array, lugar){
    let recortar= array;
    mostrarAreas(recortar, lugar);
}

$area.addEventListener('change', function () {
    let valor = $area.value;
    switch (valor){
        case 'Edificio':
            recortar(maquinaEdificio, $maquina);
            break
        case 'Compactadora':
            recortar(maquinaCompactadora, $maquina);
            break
        case 'Equipos Auxiliares':
            recortar(maquinaEquiposAuxiliares, $maquina);
            break
        case 'Maquinas':
            recortar(maquinaMaquinas, $maquina);
            break
        case 'PTAR':
            recortar(maquinasPTAR, $maquina);
            break
        case 'Garita':
            recortar(maquinasGarita, $maquina);
            break
        case 'Molinos':
            recortar(maquinasMolino, $maquina);
            break
        case 'Subestacion':
            recortar(maquinasSubestacion, $maquina);
            break
        case 'Montacargas':
            recortar(maquinasMontacargas, $maquina);
            break
    }
});

$area.addEventListener('change', function (){
    let valor = $area.value


})





/* const $area = document.getElementById('area');
const $maquina = document.getElementById('maquina');

let areas= ['Edificio', 'Compactadora', 'Equipos Auxiliares', 'Maquinas', 'PTAR', 'Garita', 'Molinos', 'Subestación', 'Montacargas'];
let maquinaEdificio= ['Administrativo', 'Financiero', 'Producción', 'Logistica/BodegaPT'];
let maquinaCompactadora= ['Compactadora'];
let maquinaEquiposAuxiliares= ['Compresor JAGUAR I', 'Compresor JAGUAR II', 'Falta1', 'Falta2'];
let maquinaMaquinas= ['Pelletizadora 1', 'Pelletizadora 2' ,'Pelletizadora 3', 'Lavado Film', 'PET', 'Lavado Hogar', 'Lavado Zuncho', 'Clasificadora de colores'];
let maquinasPTAR=['PTAR'];
let maquinasGarita=['Garita', 'Puerta'];
let maquinasMolino=['Zuncho', 'Hogar', 'Film', 'PET', 'Trituradora'];
let maquinasSubestacion=['Transformador Inatra 250 KVA', 'Transformador Inatra 750 KVA'];
let maquinasMontacargas=['Montacargas 1 - 2.5T', 'Montacargas 2 - 2.5T', 'Montacargas 3 - 3T', 'Montacargas 4 - 3T'];

function mostarAreas(arreglo, lugar){
    let elementos = '<option selected disabled>--Seleccione--</option>'

    for(let i = 0; i< arreglo.length; i++){
        elementos += '<option value="" '+arreglo[i]+'">' +arreglo[i]+'</option>'
    }
    lugar.innerHTML= elementos;
}
mostarAreas(areas, $area);






$area.addEventListener('change', function (){
    let valor = $area.value

    switch (valor){
        case 'Edificio':
            let recorte= maquinaEdificio.slice(0, 3);
            mostarAreas(recorte, $maquina);
            break
        case  'Compactadora':
            let recorte2= maquinaCompactadora.slice(0, 3);
            mostarAreas(recorte, $maquina);
            break
        case  'Equipos Auxiliares':
            break
        case  'Maquinas':
            break
        case  'PTAR':
            break
        case  'Garita':
            break
        case  'Molinos':
            break
        case  'Subestación':
            break
        case  'Montacargas':
            break

    }
})

 */