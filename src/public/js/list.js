

$(document).ready(function() {
    $("#search").on("keyup", function () {
        let value = $(this).val().toLowerCase();
        $("#tab tr").filter(function () {
            $(this).toggle($(this).text()
                .toLowerCase().indexOf(value) > -1)
        });
    });
});