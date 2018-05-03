var ready = function() {
  $(document).on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).show();
  });
};

$(document).on('turbolinks:load', ready);

