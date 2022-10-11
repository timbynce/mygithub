$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.question-edit-body-button', function(e){
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  })

  $('.question').on('click', '.question-new-comment-button', function(e){
    let blockClass = $('div#question-new-comment').attr("class");
    if (blockClass == 'hidden') {
      $('div#question-new-comment').removeClass('hidden');
    } else {
      $('div#question-new-comment').addClass('hidden');
    }
  })
});
