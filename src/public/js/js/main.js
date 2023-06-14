const btn_agregar = document.getElementById('agregar');
/*
btn_agregar.addEventListener("click", function () {
    //crear el div que contiene los 2 sub-divs
    const div_principal = D.create('div');
    //crear el div para el span e input del nombre
    const div_nombre = D.create('div');
    //crear el div para el span e input del apellido
    const div_apellido = D.create('div');
    //crear los span de nombre y apellido
    const span_nombre = D.create('span', {innerHTML: 'Nombre'});
    const span_apellido = D.create('span', {innerHTML: 'Apellido'});
    //crear los inputs de nombre y apellido
    const input_nombre = D.create('input', {
        type: 'text',
        name: 'nombres',
        autocomplete: 'off',
        placeholder: 'Nombre del usuario'
    });
    const input_apellido = D.create('input', {
        type: 'text',
        name: 'apellidos',
        autocomplete: 'off',
        placeholder: 'Apellido del usuario'
    });
    //crear un botoncito de eliminar este div
    const borrar = D.create('a', {
        href: 'javascript:void(0)', innerHTML: 'x', onclick: function () {
            D.remove(div_principal);
        }
    });
    //agregar cada etiqueta a su nodo padre
    D.append(span_nombre, div_nombre);
    D.append(input_nombre, div_nombre);
    D.append([span_apellido, input_apellido], div_apellido);
    D.append([div_nombre, div_apellido, borrar], div_principal);
    //agregar el div del primer comentario al contenedor con id #container
    D.append(div_principal, D.id('divPrincipal'));
});
*/
//var cantidad = 0;
function agregarHijo() {
    const nombre = document.getElementById('nombre').value;
    if (nombre.length != 0) {
       // cantidad++;
        var divpadre = document.createElement('div');
        divpadre.id = 'divPadre';
        divpadre.classList.add("divPadre")
        var nuevohijo = document.createElement('input');
        nuevohijo.value = nombre;
        nuevohijo.type = 'text';
        nuevohijo.name = 'nombre';
        nuevohijo.id = 'nombre';

        var clase = document.createElement("button");
        clase.innerText = "X"
        clase.type = 'button'
        clase.classList.add("btn", "btn-danger", "delete")

        document.getElementById('divTecnicos').appendChild(divpadre).appendChild(document.createElement("div").appendChild(nuevohijo)).after(clase);

        $(document).on('click', '.delete', function () {
            $(this).parent().remove();
            $(this).remove();

        });
    } else {
        alert("Ingresa el nombre del tecnico")
    }

}


/*

function ShowSelected() {

    var cod = document.getElementById("tecnicos").value;

    var combo = document.getElementById("tecnicos");
    var name = combo.options[combo.selectedIndex].text;
    //console.log(name);
    if (name.length !=0){
        cantidad++;
        const divpadre = document.createElement('div');
        divpadre.id = 'divPadre';
        divpadre.classList.add("divPadre")
        const nuevohijo = document.createElement('input');
        nuevohijo.innerHTML="";
        nuevohijo.placeholder = name;
        nuevohijo.name = 'nombre';
        nuevohijo.classList.add('nombre');
        const clase = document.createElement("button");
        clase.innerText = "X"
        clase.type = 'button'
        clase.classList.add("btn", "btn-danger", "delete")

        document.getElementById('divTecnicos').appendChild(divpadre).appendChild(document.createElement("div").appendChild(nuevohijo)).after(clase);

        $(document).on('click', '.delete', function () {
            $(this).parent().remove();
            $(this).remove();

        });
    }






}

 */










/*

function init() {

    let select = document.createElement("select");
    select.name="selectname";
    select.value="name";

    let option1 = document.createElement("option");
    option1.setAttribute("value", {{idUser}});
    let option1Texto = document.createTextNode("opcion 1");
    option1.appendChild(option1Texto);


    select.appendChild(option1);

const div =  document.getElementById('divTecnicos');
    div.appendChild(select);

}

*/


function duplicar1() {
    const itm = document.getElementById("divPadre");
    const cln = itm.cloneNode(true);

    const close = document.createElement("button");
    close.innerText = "X"
    close.type = 'button'
    close.classList.add("btn", "btn-danger", "delete")
    close.id="cerrar"

    document.getElementById("selectsTecnico").appendChild(cln).appendChild(close);



    $(document).on('click', '.delete', function () {
        $(this).parent().remove();
        $(this).remove();

    });
}


/*
function validate(){
    const select = document.getElementById('nombreTecnico');
    if (select.value=="null")
    {
        alert("Ey");

    }else{
        alert('No ey')
    }
}

 */
/*
$('#form').submit(function(event) {
    const select = document.getElementById('nombreTecnico');
    if (select.value=='null'){
    }else {
        alert("Good")
    }
    event.preventDefault();

    window.history.back();
});




const horaInicio= document.getElementById('horaInicio').value;
console.log(horaInicio);

 */


//Petición fetch para saber si existe el codigo en la BBDD

document.getElementById('codigo').addEventListener('input', function (){
    let codigo= this.value;
    fetch('/verificar-codigo',{
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({codigo:codigo})
    })
        .then(response=>response.json())
        .then(data=>{
            //console.log(data)
            if (data.existe) {
                // El código existe en la base de datos
                document.getElementById('codigo').classList.remove('is-valid');
                document.getElementById('codigo').classList.add('is-invalid');
                document.getElementById('invalid-feedback').textContent = 'El código ya existe en la base de datos';
                document.getElementById('sendCodigoPorducto').classList.add('disabled')
            } else {
                // El código no existe
                document.getElementById('codigo').classList.remove('is-invalid');
                document.getElementById('codigo').classList.add('is-valid');
                document.getElementById('sendCodigoPorducto').classList.remove('disabled')
                //document.getElementById('valid-feedback').textContent = 'El código es correcto';
            }
        })
        .catch(error=>{
            console.error("Error")
        })
})


const botones = document.querySelectorAll('.codigoProducto');
//console.log(botones);
botones.forEach(function (boton) {
    boton.addEventListener('click', function () {
        let idProducto = this.getAttribute('id');
        console.log(idProducto);
        fetch('/datos-producto', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({idProducto: idProducto})
        })
            .then(response => response.json())
            .then(data => {
                let DATA= data.producto;
                //console.log(DATA);
                const {idProducto, nameProducto, codigo, saldo, unidad, DetallesProducto}=DATA;
                const dataProducto={
                    idProducto: DATA.idProducto,
                    nameProducto: DATA.nameProducto,
                    codigo: DATA.codigo,
                    saldo: DATA.saldo,
                    unidad: DATA.unidad,
                    DetallesProducto: DATA.DetallesProducto
                }
                console.log(dataProducto);
                document.getElementById('exampleModalLabel').textContent=nameProducto;
                document.getElementById('idProducto').value=idProducto;
                document.getElementById('codigoProducto').value=codigo;
                document.getElementById('saldo').value=saldo;
                document.getElementById('unidad').value=unidad;
                document.getElementById('detalles').value=DetallesProducto;
            })
            .catch(error => {
                console.error("Error")
            })
    })
})


