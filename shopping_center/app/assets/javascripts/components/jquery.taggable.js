(function($) {
  $.taggable = function(element, options) {
    var defaults = {
      tags: [],
      current_text: true, // Add the current text of the tag box to the tags array.
      delimiter: ";", // The delimiter between tags.
      editable: true, // Let the user click tags to edit them. (Requires the input box.)
      destination: "<span />" // The elment where tags will land after being parsed. Defaults to a span directly right of the input box.
    }

    var plugin = this;
    plugin.settings = {};

    var $element = $(element); //jquery element on dom
    var $ui_element = $element.clone();
    var element = element; //scoping actual element on dom;

    plugin.init = function() {
      plugin.settings = $.extend({}, defaults, options)

			if ($element.hasClass("tag-input-box")) return true;
			$element.addClass("tag-input-box");

			if (plugin.settings.current_text) {
				var tmp_tags_arr = $element.val().split(plugin.settings.delimiter);
				$.merge(plugin.settings.tags, tmp_tags_arr);
				unique_check();
				update_val();
			}

      //we clone the text-field because we need one text field for the ui interaction
      //andn we need another to submit that actual form data. both text-fields get submitted
      //but only the original, or the one the caller placed, is populated with the data from all the tags
      var input_box = $ui_element.val("").keydown(function(e){
        if ((e.keyCode == 13 && !e.shiftKey) || (e.keyCode == 186 && !e.shiftKey)) {
          add(input_box.val().split(plugin.settings.delimiter));
          input_box.val("");
          return false;
        }
      }).blur(function(){
        if (input_box.val() != "") {
          add(input_box.val().split(plugin.settings.delimiter));
          input_box.val("");
        }
      });
      if(input_box.attr("id"))
        input_box.attr("id", input_box.attr("id") + '__taggable');
      if(input_box.attr("name"))
        input_box.attr("name", input_box.attr("name") + '__taggable');
      $element.parent().prepend(input_box);
      $element.css("display", "none");

      plugin.tag_container = $(plugin.settings.destination);
      update_tags();
    }

    var add = function(textorarray){
      $.merge(plugin.settings.tags, (typeof textorarray == "string" ? [textorarray] : textorarray));
      unique_check();
      update_val();
      update_tags();
    };

    var remove = function(textorarray){
      $.each((typeof textorarray == "string" ? [textorarray] : textorarray), function(){
        var i = $.inArray(""+this, plugin.settings.tags);
        if (i > -1)
          plugin.settings.tags.splice(i, 1);
      });
      update_val();
      update_tags();
    };

    var remove_all = function(){
      plugin.settings.tags = [];
      update_val();
      update_tags();
    };

    var unique_check = function(){
      for (var i = 0; i < plugin.settings.tags.length; i++) {
        if ($.inArray(plugin.settings.tags[i], plugin.settings.tags) < i || plugin.settings.tags[i] == "") {
          plugin.settings.tags.splice(i, 1);
          i--;
        }
      }
    };

    var update_val = function(){
      var oldval = $element.val();
      var newval = plugin.settings.tags.join(plugin.settings.delimiter);
      if (oldval != newval)
      	$element.val(newval).change();
    };

    var update_tags = function(){
      //we clear tags because we refresh it completely, not just a diff
      plugin.tag_container.empty();

      $.each(plugin.settings.tags, function(i, val){
        var tag_box = $("<li />").addClass("tag");

        tag_box.append($("<a href=\"#\" />").addClass("tag-text").html(val).click(function(){
          var text = tag_box.children().first().text();
          $ui_element.val(text).focus().select();
          remove(text);

          return false;
        }));

        plugin.tag_container.append(tag_box);
      });
    };

    plugin.val = function() {
      return plugin.settings.tags;
    }

    plugin.init();
  }

  $.fn.taggable = function(options) {
    return this.each(function() {
      if(undefined == $(this).data('taggable')) {
        var plugin = new $.taggable(this, options);
        $(this).data('taggable', plugin);
      }
    });
  }
})(jQuery);
