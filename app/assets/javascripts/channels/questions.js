var ready = function () {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('Connected questions!');
      this.perform('follow');
    },

    received: function(data) {
      $('ul').append(JST["templates/question"](data));
    }
  });
}

$(document).on('turbolinks:load', ready);
