# frozen_string_literal: true

require 'rails_helper'

feature 'User can open question page to create answers', "
  In order to get answer from community
  As an authenticated user
  I'd like to be able to create answers for question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user' do
    scenario 'create answer of question' do
      sign_in(user)
      visit question_path(question)
      fill_in 'Answer', with: 'answer text text'
      click_on 'Send answer'
      expect(page).to have_content 'Your answer successfully created.'
    end

    scenario 'create answer of question with errors' do
      sign_in(user)
      visit question_path(question)
      click_on 'Send answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user answer a question' do
    visit question_path(question)
    fill_in 'Answer', with: 'answer text text'
    click_on 'Send answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
