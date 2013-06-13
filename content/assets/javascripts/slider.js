/* Slider class */

var Slider = function() {
  this._initialize();
}
_.extend(Slider.prototype, {

  slideDuration: 800,
  slideInterval: 4500,

  items: [],

  _timer: null,
  _activeSlide: false,

  // init function
  _initialize: function() {
    // get all items & randomize
    this.items = $('#sliders > .slider > img');
    //$('#sliders > .slider').html(this.items);

    // get container width
    this.width = $('#sliders').outerWidth();

    // show only first item
    $(this.items).hide().first().show();

    // bind balls click
    var that = this;
    $('#sliders > .slider_balls > ul > li > a').on('click', function(event) {
      event.preventDefault();

      var index = $(this).parent().siblings().andSelf().index($(this).parent());

      var next_item = $('#sliders > .slider > img').slice(index, index + 1);

      that.moveTo(next_item);
    });

    // bind
    _.bindAll(this);
  },

  // start function
  start: function(startAfter) {
    var next = _.bind(function() {
      this._slide();
      this._timer = _.delay(next, this.slideInterval);
    }, this);

    this._timer = _.delay(next, startAfter || this.slideInterval);
  },

  // moveTo function
  moveTo: function(item) {
    item = $(item);

    var next = _.bind(function() {
      if (this._activeSlide) {
        _.delay(next, 100);
      } else {
        clearTimeout(this._timer);

        this._slide(item);
        this.start(this.slideDuration + this.slideInterval * 2);
      }
    }, this);

    next();
  },

  // slide function
  _slide: function(nextItem) {
    var that = this;

    this._activeSlide = true; // slide is active

    // get current item
    var visibleItem = $(this.items).filter(':visible');

    // get item following current item if not set
    if (nextItem === undefined) {
      nextItem = visibleItem.next();

      if (nextItem.length === 0) {
        nextItem = $(this.items).first();
      }
    // interupt slide if next item is already visible
    } else if (nextItem.is(':visible')) {
      this._activeSlide = false; // slide is no more active
      return;
    // else ensure next item is a jQuery collection
    } else {
      nextItem = $(nextItem);
    }

    // move next item at right of current item
    nextItem.css('left', this.width + 'px');

    // find index of balls for current & next item
    var visibleBallIndex = $(this.items).index(visibleItem);
    var nextBallIndex = $(this.items).index(nextItem);

    // animate balls
    _.each([$('#sliders .slider_balls .ball').slice(visibleBallIndex, visibleBallIndex + 1), $('#sliders .slider_balls .ball').slice(nextBallIndex, nextBallIndex + 1)], function(ball) {
      ball.toggleClass('active', this.slideDuration);
    }, this);

    // animate items
    _.each([visibleItem, nextItem], function(item) {
      item.show().animate({
        left:  '-=' + this.width + 'px'
      },
      this.slideDuration,
      function() {
        visibleItem.hide();         // ensure old current item is hidden
        that._activeSlide = false;  // slide is no more active
      });
    }, this);
  }
});