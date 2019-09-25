$(document).ready(function() {
  $(document).on('ajax:success', '.rules__create-link', function(e) {
    $('.rules').append(e.detail[0].activeElement.innerHTML);
    $('.modal').modal('show');
  });

  $(document).on('ajax:success', '.rules__item-update-link', function(e) {
    $(this).closest('.rules__item').append(e.detail[0].activeElement.innerHTML);
    $('.modal').modal('show');
  });

  $(document).on('ajax:success', '.edit_update_rule_form', function (e) {
    var item = $(this).closest('.rules__item');
    $('.modal').modal('hide');
    item.replaceWith(e.detail[0].activeElement.innerHTML);
    format_datetime();
  });

  $(document).on('click', '.rules__item-delete-link', function(e) {
    var url = $(this).data("url");
    var modal = '<div class="modal" tabindex="-1" role="dialog">\n' +
      '  <div class="modal-dialog role="document">\n' +
      '    <div class="modal-content">\n' +
      '      <div class="modal-header">\n' +
      '        <h5 class="modal-title">Подтверждение удаления</h5>\n' +
      '        <button type="button" class="close" data-dismiss="modal" aria-label="Close">\n' +
      '          <span aria-hidden="true">&times;</span>\n' +
      '        </button>\n' +
      '      </div>\n' +
      '      <div class="modal-body text-right">\n' +
      '        <button type="button" class="btn btn-primary" data-dismiss="modal">Отменить</button>\n' +
      '        <a class="rules__item-confirm-deletion-link btn btn-primary" data-remote="true" rel="nofollow" data-method="delete" href="' + url + '">Подтвердить</a>\n' +
      '      </div>\n' +
      '    </div>\n' +
      '  </div>\n' +
      '</div>';

    $(this).closest('.rules__item').append(modal);
    $('.modal').modal('show');
  });

  $(document).on('ajax:success', '.rules__item-confirm-deletion-link', function() {
    var item = $(this).closest('.rules__item');
    $('.modal').modal('hide');
    item.remove();
  });

  $(document).on('click', '.rules__item-details-link', function() {
    $(this).closest('.rules__item').find('.rules__item-details').toggle();
  });
});