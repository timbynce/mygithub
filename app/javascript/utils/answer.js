$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.answer-edit-button', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('.new-answer').on('click', '.new-answer-button', function(e){
    let blockClass = $('div#new-answer-block').attr("class");
    if (blockClass == 'hidden') {
      $('div#new-answer-block').removeClass('hidden');
    } else {
      $('div#new-answer-block').addClass('hidden');
    }
  })

  $('.new-answer-links').on('click', '.new-answer-links-button', function(e){
    let linksBlockClass = $('div#new-answer-links-block').attr("class");
    if (linksBlockClass == 'hidden') {
      $('div#new-answer-links-block').removeClass('hidden');
    } else {
      $('div#new-answer-links-block').addClass('hidden');
    }
  })

  $('.answers').on('click', '.answer-comment-button', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#comment-answer-' + answerId).removeClass('hidden');
  })
});
