import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    this.perform('subscribed');
  },
  
  received(data) {
    console.log(data)
    
    //$('.table').append(data);
  }
});
