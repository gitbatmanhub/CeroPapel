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


/*
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


 */
const table = document.getElementById('table');



table.addEventListener('click', (e)=>{
    e.stopPropagation();
    const id=e.target.parentElement.parentElement.children[0].textContent.trim();
    document.getElementById("viewBtn").href="/orden/view/" + id;
    document.getElementById("editBtn").href="/orden/view/" + id;
    document.getElementById("deleteBtn").href="/orden/view/" + id;

})

/*
const ver= document.getElementById('viewBtn');
const actualizar= document.getElementById('editBtn');
const eliminar= document.getElementById('deleteBtn');



function myFunction() {
    var result = document.getElementById("SearchText").value;
    document.getElementById("result").innerHTML = result;
    document.getElementById("abc").href="http://arindam31.pythonanywhere.com/hello/" + result;
}

/*
const fillData =(data)=>{
    console.log(data);
}

 */

