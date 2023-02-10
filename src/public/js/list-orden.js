
$(document).ready(function () {

    $('#table1, #table2, #table3').DataTable({
        scrollY: '100vh',
        scrollCollapse: true,
        responsive: true,
        paging: true,
        collapse:true,
        language: {
            url: 'https://cdn.datatables.net/plug-ins/1.13.1/i18n/es-MX.json'
        }
    });





});










const table3 = document.getElementById('table3');
table3.addEventListener('click', (e)=>{
    e.stopPropagation();
    const id=e.target.parentElement.parentElement.children[0].textContent.trim();
    //console.log(id);
    document.getElementById("tecnico").href="/tecnico/" + id;
    document.getElementById("suministros").href="/suministro/" + id;
    document.getElementById("trabajoExterno").href="/trabajoExterno/" + id;

});



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


