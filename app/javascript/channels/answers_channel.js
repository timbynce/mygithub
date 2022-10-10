import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    this.perform('subscribed');
  },
  
  received(data) {
    $('.common_answers').append(data);
  }
});
