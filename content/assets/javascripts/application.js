//= require jquery
//= require jquery-ui
//= require modernizr

// Fixed navbar onScroll action
$(window).bind("load", function() {

  var nav_position = $("#scroll_menu").offset().top;

  var sticky_navbar = function(){
    var position = $(document).scrollTop();

    if (nav_position < position) {
      $("#scroll_menu").addClass("navfixed");
    } else {
      $("#scroll_menu").removeClass("navfixed");
    }
  };

  sticky_navbar();

  $(window).scroll(function() {
    sticky_navbar();
  });

  // smooth scroll to anchor
  $('.legend > a').on('click', function(){
    var height_navbar = "100px";

    $('html, body').animate({
      scrollTop: $( $.attr(this, 'href') ).offset().top
    }, 500);
    return false;
  });
});

$(function() {
 // Drag & drop website card
  $('.sortable').sortable({
    update: function(event, ui) {
      var position = ui.item.index();
      var event_id = ui.item.data('eventId');

      $.ajax({
        url: 'admin/events/' + event_id + '/position',
        type: 'PUT',
        data:{'position': (position)},
        dataType: 'JSON',
      });
    },
  });

  $('.edit').on('click', function() {
    $(this).parent('.agenda').find('.edit-form').toggle();
    $(this).parent('.agenda').find('.table').toggle();
  });
})();
