var ready = function() {
  $('.comment_form').bind('ajax:success', function(e) {
    [data, status, xhr] = e.detail;
    parentClass = ".comment_" + data.klass + "_" + data.id;
    $(parentClass).prepend('<p>' + data.comment + '</p>');
    $(parentClass).find('#comment_body').val('');
    $(parentClass).find('.errors').html('');
  }).bind('ajax:error', function(e) {
    [data, status, xhr] = e.detail;
    parentClass = ".comment_" + data.klass + "_" + data.id;
    $(parentClass).find('.errors').html(data.error)
  })
};

$(document).on('turbolinks:load', ready);

