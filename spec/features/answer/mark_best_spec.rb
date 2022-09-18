require 'rails_helper'

feature 'User can mark the best answer', "
  In order to get better solution
  As an author of question
  I'd like to be able to mark the best answer
  " do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question: question, author_id: user.id) }
  given!(:another_answer) { create(:answer, question: question, author_id: another_user.id) }


  describe 'Authenticated user', js: true do
    scenario 'try to mark answer' do
      sign_in user
      visit question_path(question)
      click_on "Mark Best"

      within '.best_answer' do
        expect(page).to have_content answer.body
      end
    end


  end

  describe 'Unauthenticated user' do
    scenario 'try to mark answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content "Mark Best"
      end
    end
  end
end
