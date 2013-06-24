$(window).load(function () {
  // Drag & drop events
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

  $('.new_event').on('click', function() {
    $(this).parents('.header').find('.event_form').toggle();
    $(this).attr("disabled", "disabled");
  });

  $('#add_event_form').submit(function(event) {

    event.preventDefault();
    var that = $(this);

    // send command
    $.ajax({
      type: 'POST',
      url: $(this).attr('action'),
      data: $(this).serialize(),
      success: function(data, status, xhr) {
        that.append(data);

        that.toggle();
        that.parents('.header').find('.new_event').removeAttr("disabled");
      },
      error: function(xhr, status, error) {
        that.toggle();
        that.parents('.header').find('.new_event').removeAttr("disabled");
      },
      dataType: 'html'
    });
  });

  $(document).on('click', '.edit', function() {
    event.preventDefault();

    $(this).parents('.agenda').find('.edit-form').toggle();
    $(this).parents('.agenda').find('.action').toggle();
  });

  $(document).on('submit', '.edit-form', function() {

    event.preventDefault();
    var that = $(this);

    // send command
    $.ajax({
      type: 'POST',
      url: $(this).attr('action'),
      data: $(this).serialize(),
      success: function(data, status, xhr) {
        that.toggle();
        that.parents('.agenda').find('.action').toggle();
        that.parents('.agenda').replaceWith(data);
      },
      error: function(xhr, status, error) {
        that.toggle();
        that.parents('.agenda').find('.action').toggle();
      },
      dataType: 'html'
    });
  });

});
