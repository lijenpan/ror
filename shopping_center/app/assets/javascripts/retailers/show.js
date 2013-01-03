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
});
