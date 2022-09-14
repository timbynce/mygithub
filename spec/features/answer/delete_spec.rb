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

  scenario 'Authenticated user delete answer of question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete Answer'
    expect(page).to  have_content 'Answer was successfully deleted.'
  end

  scenario 'Unauthenticated user try to delete answer of question' do
    visit question_path(question)
    click_on 'Delete Answer'
    expect(page).to  have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user try to delete answer of some one else' do
    sign_in(another_user)
    visit question_path(question)
    click_on 'Delete Answer'
    expect(page).to  have_content 'Only author can delete it!'
  end
end
