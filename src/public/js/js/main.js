
/*
const btn_agregar = document.getElementById('agregar');

btn_agregar.addEventListener("click", function( ){
    //crear el div que contiene los 2 sub-divs
    const div_principal = D.create('div');
    //crear el div para el span e input del nombre
    const div_nombre = D.create('div');

    //crear el div para el span e input del apellido
    const div_apellido = D.create('div');

    //crear los span de nombre y apellido
    const span_nombre = D.create('span', { innerHTML: 'Nombre' } );
    const span_apellido = D.create('span', { innerHTML: 'Apellido' });

    //crear los inputs de nombre y apellido
    const input_nombre = D.create('input', { type: 'text', name: 'nombres', autocomplete: 'off', placeholder: 'Nombre del usuario' } );

    const input_apellido = D.create('input', { type: 'text', name: 'apellidos', autocomplete: 'off', placeholder: 'Apellido del usuario' });

    //crear un botoncito de eliminar este div
    const borrar = D.create('a', { href: 'javascript:void(0)', innerHTML: 'x', onclick: function( ){ D.remove(div_principal); } } );

    //agregar cada etiqueta a su nodo padre
    D.append(span_nombre, div_nombre);
    D.append(input_nombre, div_nombre);

    D.append([span_apellido, input_apellido], div_apellido);

    D.append([div_nombre, div_apellido, borrar], div_principal);

    //agregar el div del primer comentario al contenedor con id #container
    D.append(div_principal, D.id('divPrincipal') );
} );

 */


/*
const btn_agregar = document.getElementById('agregar');
btn_agregar.addEventListener("click", function( ){
    //crear el div que contiene los 2 sub-divs
    const div_principal = D.create('div');
    //crear el div para el span e input del nombre
    const div_nombre = D.create('div');

    //crear el div para el span e input del apellido
    const div_apellido = D.create('div');

    //crear los span de nombre y apellido
    const span_nombre = D.create('label', { innerHTML: 'Input primero' } );
    const span_apellido = D.create('label', { innerHTML: 'Input segundo' });

    //crear los inputs de nombre y apellido
    const input_nombre = D.create('select', { '<option value="{{iduser}}">{{fullname}}</option>'} );

    const input_apellido = D.create('select', { value: '{{iduser}}' , name: 'nombres'});

    //crear un botoncito de eliminar este div
    const borrar = D.create('a', { href: 'javascript:void(0)', innerHTML: 'x', onclick: function( ){ D.remove(div_principal); } } );

    //agregar cada etiqueta a su nodo padre
    D.append(span_nombre, div_nombre);
    D.append(input_nombre, div_nombre);

    D.append([span_apellido, input_apellido], div_apellido);

    D.append([div_nombre, div_apellido, borrar], div_principal);

    //agregar el div del primer comentario al contenedor con id #container
    D.append(div_principal, D.id('divPrincipal') );
} );

*/



/*

function ShowSelected()
{
    var cod = document.getElementById("tecnico").value;
    var combo = document.getElementById("tecnico");
    var selected = combo.options[combo.selectedIndex].text;

    document.getElementById("agregarTecnico").addEventListener("click", e => {

        const newElement = document.createElement("input");
        newElement.classList.add("tecnico");
        newElement.textContent = cod;
        newElement.value=selected;
        newElement.readOnly=true;
        document.querySelector(".este").appendChild(newElement);

    });
}

    document.getElementById("agregarTecnico").addEventListener("click", e => {
        const error2 = document.createElement('a',
            { href: 'javascript:void(0)', innerHTML: 'x', onclick: function( ){
                document.remove(newElement);
            }});
        const newElement = document.createElement("input");
        newElement.classList.add("tecnico");
        newElement.textContent = cod;
        newElement.value=selected;
        newElement.readOnly=true;

            document.querySelector(".este").appendChild(newElement);
            document.querySelector(".este").appendChild(error2);
    });

   //document.getElementById("prebis").value = selected;


 */





var fruits = ["Banana", "Orange", "Apple", "Mango"];


function AddItem() {

    var theBody = document.getElementById('tabla').getElementsByTagName('tbody')[0];
    var newRow = "<tr><td><select>";
    var theOptions = theOptions += `<option value="{{iduser}}">'{{fullname}}'</option>`;

    newRow += theOptions;
    newRow += "</select></td></tr>";

    theBody.insertAdjacentHTML('beforeend', newRow);


}













