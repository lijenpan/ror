$(document).ready ->
  #hide all except the first
  $(".pilled-content ul.items").children().hide()
  $(".pilled-content ul.items li:first").show()
  $(".pilled-content .nav-pills a").each (index, element) ->
    $(element).click ->
      clicked = $(element)
      #hide active section
      active = $(".pilled-content .nav li.active a")
      $(".pilled-content .nav li.active").removeClass
      active.removeClass ".active"
      id = active.data()["sectionId"]
      $("#" + id).slideUp "medium", ->
        id = clicked.data()["sectionId"]
        $("#" + id).slideDown "medium"
        clicked.parent().addClass "active"

$(".dataTable").dataTable
  sDom: "<'row'fr>t<'row'p>"
  bLengthChange: true
  bFilter: true
  bSort: true
  bInfo: true
  bPaginate: true
  sPaginationType: "bootstrap"

$.extend $.fn.dataTableExt.oStdClasses,
  sSortAsc: "header headerSortDown"
  sSortDesc: "header headerSortUp"
  sSortable: "header"
  sWrapper: "dataTables_wrapper form-inline"
