require 'rails_helper'

feature 'User can open question page with list of answers', %q{
  In order to get answer from community
  As an authenticated user
  I'd like to be able to list all answers for question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answers) { create_list(:answer, 5 , question: question, author_id: user.id) }

  describe 'Authenticated user' do
    scenario 'list all answers of question' do
      sign_in(user)
      visit question_path(question)
      
      expected_content = answers.map(&:body)
      expect(page.all('.answer').map(&:text)).to match_array(expected_content)      
    end
  end

  describe 'Unauthenticated user' do
    scenario 'list all answers of question' do
      visit question_path(question)

      expected_content = answers.map(&:body)
      expect(page.all('.answer').map(&:text)).to match_array(expected_content)      
    end
  end


end
