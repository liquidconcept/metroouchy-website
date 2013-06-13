$(function() {
  $('.new_event').on('click', function() {
    event.preventDefault();

    $.ajax({
      url: 'events',
      type: 'POST'
    });
  });

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

  $('.edit').on('click', function() {
    $(this).parent('.agenda').find('.edit-form').toggle();
    $(this).parent('.agenda').find('.table').toggle();
  });
});