var ready = function () {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('Connected questions!');
      this.perform('follow');
    },

    received: function(data) {
      $('.questions-index').append(JST["templates/question"](data));
    }
  });
}

$(document).on('turbolinks:load', ready);
