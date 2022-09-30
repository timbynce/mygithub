# frozen_string_literal: true

require 'rails_helper'

feature 'User can add award to question', "
  In order to get additional motivation
  As an authenticated user
  I'd like to be able to get award
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:badge) { create(:badge, question: question) }
  given!(:answer) { create(:answer, question: question, author_id: user.id) }

  scenario 'Authenticated user try to get award', js: true do
    sign_in user
    visit question_path(question)
    within ".answer-#{answer.id}" do
      click_on 'Mark Best'
    end

    within '.answers' do
      expect(page).to have_content answer.body
      expect(page).to have_content question.badge.name
    end
  end

  scenario 'Award not display withou best answer', js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content question.badge.name
    end
  end
end
