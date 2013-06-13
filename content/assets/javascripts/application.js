//= require jquery
//= require underscore
//= require modernizr
//= require h5validate
//= require slider
//= require admin
//= require jquery-ui
//= require modernizr


// Validation
var initValidation = function() {
  $('article.form > section >form').h5Validate({
    submit: false, // performed by custom handler
    keyup: true
  });
}

// Send form
var sendForm = function(event) {
  event.preventDefault();

  // check validity
  var allValid = $(this).h5Validate('allValid', { revalidate: true });
  if(allValid !== true) {
    return;
  }
  var that = $(this)

  // send command
  $.ajax({
    type: 'POST',
    url: $(this).attr('action'),
    data: $(this).serialize(),
    success: function(data, status, xhr) {
      that.fadeOut(function() {
        that.parent().find($('h5.message_validate')).append('Formulaire envoyée avec succès').fadeIn();
      })
    },
    error: function(xhr, status, error) {
      that.fadeOut(function() {
        that.parent().find($('h5.message_validate')).append("Le formulaire n'a pas été envoyée avec succès").fadeIn();
      })
    },
    dataType: 'text'
  });
}

// Sticky menu
var stickyMenuPosition;
var stickyMenu = function() {
  var position = $(document).scrollTop();

  if (stickyMenuPosition < position) {
    $('#scroll_menu').addClass('navfixed');
  } else {
    $('#scroll_menu').removeClass('navfixed');
  }
};

$(function() {

  // init slider
  var slider = new Slider();
  slider.start();

  // init sticky menu
  stickyMenuPosition = $('#scroll_menu').offset().top;
  stickyMenu();
  $(window).scroll(stickyMenu);

  // init validation
  initValidation();

  // init form
  $('article.form > section > form').on('submit', sendForm);

  // smooth scroll to anchor
  $('.legend > a').on('click', function(event) {
    event.preventDefault();

    $('html, body').animate({
      scrollTop: $($(this).attr('href')).offset().top - 80
    }, 500);
  });

  // menu toggle institut
  $('.care, .care_2').find('li').on('click', function() {
    event.preventDefault();

    var $this = $(this);

    if ($this.hasClass('active')) {
      $this.find('.container').slideUp('slow', function() {
        $this.removeClass('active');
      });
    } else {
      $('#institute li.active .container').slideUp('slow');
      $('#institute li.active').removeClass('active');
      $this.find('.container').slideDown('slow', function() {
        $this.addClass('active');
      });
    }
  });
});
