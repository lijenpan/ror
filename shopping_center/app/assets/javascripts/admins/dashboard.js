$(document).ready(function() {
    $('.dataTable').dataTable( {
        "sDom": "<'row'fr>t<'row'p>",
        "iDisplayLength": 40,
        "bLengthChange": true,
        "bFilter": true,
        "bSort": true,
        "bPaginate": true,
        "sPaginationType": "bootstrap"
        });

    $.extend($.fn.dataTableExt.oStdClasses, {
        "sSortAsc": "header headerSortDown",
        "sSortDesc": "header headerSortUp",
        "sSortable": "header",
        "sWrapper": "dataTables_wrapper form-inline"
        });
});
