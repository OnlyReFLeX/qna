var voteBind = function() {
  $('.vote').bind('ajax:success', function(e) {
    [data, status, xhr] = e.detail;
    parentClass = ".rating_" + data.klass + "_" + data.id;
    afterVote(parentClass, data.rating);
  });
  function afterVote(parent, rating) {
    $(parent + " .votes-sum").html(rating);
    $(parent + ' .votes').toggleClass('has-vote');
  };
};

$(document).on('turbolinks:load', voteBind);

