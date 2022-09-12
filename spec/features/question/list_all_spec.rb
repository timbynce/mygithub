require 'rails_helper'

feature 'User can open list of all questions', %q{
  In order to get answer from community
  As an authenticated user
  I'd like to be able to list all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author_id: user.id) }

  describe 'Authenticated user' do
    scenario 'list all questions' do
      sign_in(user)
      
      visit questions_path
      expected_content = questions.map(&:title)
      expect(page.all('.question').map(&:text)).to match_array(expected_content)
    end
  end

  describe 'Unauthenticated user' do      
    scenario 'list all questions' do    
      visit questions_path
      expected_content = questions.map(&:title)
      expect(page.all('.question').map(&:text)).to contain_exactly(*expected_content)
    end
  end
end
