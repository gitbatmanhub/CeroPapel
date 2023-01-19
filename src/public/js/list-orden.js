$(document).ready(function () {

    $('#table, #table2, #table3').DataTable({
        scrollY: '100vh',
        scrollCollapse: true,
        paging: true,
        language: {
            url: 'https://cdn.datatables.net/plug-ins/1.13.1/i18n/es-MX.json'
        }
    });

});



const area = document.getElementById('area');
area.addEventListener('change',
    function(){
        const selectedOption = this.options[area.selectedIndex];
        console.log(selectedOption.value + ': ' + selectedOption.text);
    });

const maquina = document.getElementById('maquina');
maquina.addEventListener('change',
    function (){
    const opcionseleccionada = this.options[maquina.selectedIndex];
console.log(opcionseleccionada.value + " "+ opcionseleccionada.text);
    });
