# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote an question or answer', "
  In order to get impact of question or answer
  As an authenticated user
  I'd like to be able to add like or dislike
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question: question, author_id: user.id) }

  describe 'Authenticated user', js: true do
    scenario 'likes the question' do
      sign_in(another_user)
      visit questions_path

      click_on 'Like'
      within '.rating' do
        expect(page).to have_content 1
      end
    end

    scenario 'likes the owned question' do
      sign_in(user)
      visit questions_path

      expect(page).to_not have_content 'Like'
    end

    scenario 'try to like the question twice' do
      sign_in(another_user)
      visit questions_path

      click_on 'Like'
      click_on 'Like'
      expect(page).to have_content 'Error on Like Action'
    end

    scenario 'change his opinion about question and dislike after' do
      sign_in(another_user)
      visit questions_path

      click_on 'Like'
      within '.rating' do
        expect(page).to have_content 1
      end

      click_on 'Dislike'
      within '.rating' do
        expect(page).to have_content 0
      end

      click_on 'Dislike'
      within '.rating' do
        expect(page).to have_content(-1)
      end
    end

    scenario 'likes the answer' do
      sign_in(another_user)
      visit question_path(question)

      click_on 'Like'
      within '.rating' do
        expect(page).to have_content 1
      end
    end

    scenario 'likes the owned question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content 'Like'
    end

    scenario 'try to like the answer twice' do
      sign_in(another_user)
      visit question_path(question)

      click_on 'Like'
      click_on 'Like'
      expect(page).to have_content 'Error on Like Action'
    end

    scenario 'change his opinion about answer and dislike after' do
      sign_in(another_user)
      visit question_path(question)

      click_on 'Like'
      within '.rating' do
        expect(page).to have_content 1
      end

      click_on 'Dislike'
      within '.rating' do
        expect(page).to have_content 0
      end

      click_on 'Dislike'
      within '.rating' do
        expect(page).to have_content(-1)
      end
    end
  end
end
