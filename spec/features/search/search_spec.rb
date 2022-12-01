require 'sphinx_helper'

feature 'User can search', "
  In order to find important information
  As an any role user
  I'd like to be able to searching records by keywords
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  before { visit questions_path }

  scenario 'User search within All data that is not present', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :body, with: 'trololo'
        click_on 'Search'
      end

      expect(page).to have_content 'No results'
    end
  end

  scenario 'User search within All data that is present', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        select 'All', from: :type
        fill_in :body, with: question.title
        click_on 'Search'
      end

      expect(page).to have_content question.title
    end
  end

  scenario 'User search within Question type that is present', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :body, with: question.title
        select 'Question', from: :type
        click_on 'Search'
      end

      expect(page).to have_content question.title
    end
  end
end
