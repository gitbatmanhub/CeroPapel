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

