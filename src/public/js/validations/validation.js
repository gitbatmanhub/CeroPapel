//Validacion de datos y selects con datos


var select = document.getElementById('area');
select.addEventListener('change',
    function(){
        var selectedOption = this.options[select.selectedIndex];
        console.log(selectedOption.value + ': ' + selectedOption.text);
    });