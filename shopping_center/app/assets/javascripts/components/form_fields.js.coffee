add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  p = $(link).prev()
  $(link).prev().append content.replace(regexp, new_id)
  $("[data-datepicker]").datepicker()

remove_fields = (link) ->
  $(link).prev("input[type=hidden]").val "1"
  $(link).closet(".fields").hide()
