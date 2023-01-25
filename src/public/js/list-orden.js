
$(document).ready(function () {

    $('#table1, #table2, #table3').DataTable({
        scrollY: '100vh',
        scrollCollapse: true,

        paging: true,
        collapse:true,
        language: {
            url: 'https://cdn.datatables.net/plug-ins/1.13.1/i18n/es-MX.json'
        }
    });





});



const table1 = document.getElementById('table1');
table1.addEventListener('click', (e)=>{
    e.stopPropagation();
    const id=e.target.parentElement.parentElement.children[0].textContent.trim();
    console.log(id);
    document.getElementById("viewBtn").href="/orden/view/" + id;
    document.getElementById("editBtn").href="/orden/edit/" + id;
    document.getElementById("deleteBtn").href="/orden/delete/" + id;

});




const table2 = document.getElementById('table2');
table2.addEventListener('click', (e)=>{
    e.stopPropagation();
    const id=e.target.parentElement.parentElement.children[0].textContent.trim();
    console.log(id);
    document.getElementById("accept").action="/orden/accept/"+id;
    document.getElementById("orden").value=id;

});

const table3 = document.getElementById('table3');
table3.addEventListener('click', (e)=>{
    e.stopPropagation();
    const id=e.target.parentElement.parentElement.children[0].textContent.trim();
    console.log(id);
    document.getElementById("tecnico").href="/orden/tecnico/" + id;
    document.getElementById("orden").value=id;

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


