import consumer from "./consumer"

consumer.subscriptions.create({ channel:"CommentsChannel", question_id: gon.question_id }, {
  connected() {
    this.perform('subscribed');
  },

  received(data) {
    var type = data.commentable_type
    var id = data.commentable_id
    if (type == 'question') {
      $('.question-comments').append(data.partial);
    } else {
      $(".answer-"+id+"-comments").append(data.partial);
    }
  }
});
