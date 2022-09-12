require 'rails_helper'

feature 'User can open question page with list of answers', %q{
  In order to get answer from community
  As an authenticated user
  I'd like to be able to list all answers for question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'list all answers of question' do
      sign_in(user)
      visit question_path(question)
      fill_in 'Answer', with: 'answer text text'
      click_on 'Send answer'
      expect(page).to  have_content 'Your answer successfully created.'
    end
  end
end
