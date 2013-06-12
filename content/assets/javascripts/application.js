//= require jquery
//= require underscore
//= require slider
//= require jquery-ui
//= require modernizr

// Fixed navbar onScroll action
$(window).bind('load', function() {

  var nav_position = $('#scroll_menu').offset().top;

  var sticky_navbar = function(){
    var position = $(document).scrollTop();

    if (nav_position < position) {
      $('#scroll_menu').addClass('navfixed');
    } else {
      $('#scroll_menu').removeClass('navfixed');
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

  // menu toggle institut
  $('.care, .care_2').find('li').on('click', function() {
    event.preventDefault();

    var that = $(this);
    var item = $('.care, .care_2').find('li');
    var container = $('div.container');

    if (item.hasClass('active')) {
      item.removeClass('active');
      item.animate({height: '20px'})
    } else if (item.hasClass('active') === that) {
      that.removeClass('active');
      that.animate({height: '20px'});
    } else {
      if (!that.hasClass('active')) {
        that.addClass('active');
        that.animate({'height': '100%'});
        // that.find(container).slideDown('slow');
      } else {
        that.removeClass('active');
        that.animate({height: '20px'});
      }
    }
  });

  // init slider
  var slider = window.slider = new Slider();
  slider.start();
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