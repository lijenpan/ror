$(document).ready(function() {
    //hide all except the first
    $('.pilled-content ul.items').children().hide();
    $('.pilled-content ul.items li:first').show();

    $('.pilled-content .nav-pills a').each( function(index, element) {
      $(element).click( function() {
        var clicked = $(element);

        //hide active section
        var active = $('.pilled-content .nav li.active a');
        $('.pilled-content .nav li.active').removeClass('active');
        active.removeClass('.active');

        var id = active.data()['sectionId'];
        $('#' + id).slideUp('medium', function() {
          var id = clicked.data()['sectionId'];
          $('#' + id).slideDown('medium');

          clicked.parent().addClass('active');
        });
      });
    });

    $('.dataTable').dataTable( {
        "sDom": "<'row'fr>t<'row'p>",
        "bLengthChange": true,
        "bFilter": true,
        "bSort": true,
        "bInfo": true,
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
