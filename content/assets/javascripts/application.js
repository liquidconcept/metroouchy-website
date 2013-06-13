//= require jquery
//= require underscore
//= require modernizr
//= require h5validate
//= require slider
//= require admin
//= require jquery-ui
//= require modernizr

// Overlay
var overlayToggle = function(el, options) {
  options = _.defaults(options || {}, {
    loader: true
  });

  el = $(el);
  if (el.has('.overlay').length === 0) {
    el.css('position', 'relative');
    var overlay = $('<div class="overlay"><div class="background" /></div>');
    if (options.loader) {
      overlay.append('<div class="loader" />');
    }
    overlay.appendTo(el).fadeIn();
  } else {
    el.children('.overlay').fadeOut(function() {
      $(this).remove();
    });
  }
}

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

  // display overlay
  overlayToggle($('article.form'));

  // send command
  $.ajax({
    type: 'POST',
    url: $(this).attr('action'),
    data: $(this).serialize(),
    success: function(data, status, xhr) {
      $('article.form').css('height', $('article.form').height());
      $('article.form > section > form').fadeOut(function() {
        $('article.form').addClass('success');
        $('<p class="message_validate">Formulaire envoyé avec succès</p>').hide().appendTo($('article.form')).fadeIn();
        overlayToggle($('article.form'));
      });

      // _gaq.push(['_trackPageview', '/command']);
    },
    error: function(xhr, status, error) {
      overlayToggle($('article.form'));
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
  $('article.form > section >form').on('submit', sendForm);

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
