# frozen_string_literal: true

require 'rails_helper'

feature 'User can open question page to delete answers', "
  In order to get answer from community
  As an authenticated user
  I'd like to be able to delete answers for question
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question: question, author_id: user.id) }

  scenario 'Authenticated user delete answer of question', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete Answer'
    
    expect(page).to_not  have_content answer.body
  end

  scenario 'Unauthenticated user try to delete answer of question', js: true do
    visit question_path(question)

    expect(page).to_not  have_content 'Delete Answer'
  end

  scenario 'Authenticated user try to delete answer of some one else', js: true do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not  have_content 'Delete Answer'
  end
end
