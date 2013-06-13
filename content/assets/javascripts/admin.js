$(function() {
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
    event.preventDefault();

    $(this).parents('.agenda').find('.edit-form').toggle();
    $(this).parents('.agenda').find('.action').toggle();
  });
});