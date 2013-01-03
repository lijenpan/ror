function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  var p = $(link).prev();
  $(link).prev().append(content.replace(regexp, new_id));
  $('[data-datepicker]').datepicker();
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest('.fields').hide();
}
