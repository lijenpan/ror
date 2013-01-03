$(document).ready ->
  $('#anchor-tenant-input').taggable
    delimiter: ';',
    destination: '.anchor-tenant-landing'

  $('#tenant-input').taggable
    delimiter: ';',
    destination: '.tenant-landing'

  $('.anchor-info').popover
    title: "How do I add an anchor tenant?",
    content: "Start typing an anchor tenant's name into the text box labeled 'Add Anchor Tenants'. When you're finished with one press ENTER or type a semicolon (;) and that tenant will be submitted."

  $('.tenant-info').popover
    title: "How do I add a tenant?",
    content: "Start typing a tenant's name into the text box labeled 'Add Tenants'. When you're finished with one press ENTER or type a semicolon (;) and that tenant will be submitted."
  });

  $(".best_in_place").best_in_place();
