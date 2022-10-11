# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to get additional info to answer
  As an authenticated user
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:gist_url) {  'https://gist.github.com/timbynce/2583f0ce3b9d2027ae2370a2b0c022ec' }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question: question, author_id: user.id) }

  describe 'Authenticated user', js: true do
    scenario 'adds link when answer the question' do
      sign_in(user)
      visit question_path(question)
      click_on 'New answer'
      click_on 'Add links'

      fill_in 'Answer', with: 'answer text text'

      fill_in 'Link Name', with: 'My gist'
      fill_in 'Link Url', with: gist_url
      click_on 'Send answer'
      within '.answers' do
        expect(page).to have_link 'Жуткий вопрос 1'
      end
    end

    scenario 'tries to add wrong link when answer the question' do
      sign_in(user)
      visit question_path(question)
      click_on 'New answer'
      click_on 'Add links'

      fill_in 'Answer', with: 'answer text text'
      fill_in 'Link Url', with: 'ololo'

      click_on 'Send answer'

      expect(page).to_not have_content 'ololo'
    end

    scenario 'tries to add correct link when edit answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        click_on 'add link'
        fill_in 'Link Name', with: 'My gist'
        fill_in 'Link Url', with: gist_url

        click_on 'Save Answer'

        expect(page).to have_link 'Жуткий вопрос 1'
      end
    end

    scenario 'tries to add incorrect link when edit answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        click_on 'add link'
        fill_in 'Link Url', with: 'ololo'

        click_on 'Save Answer'
      end

      expect(page).to have_content 'Links url is not a valid URL'
      expect(page).to have_content "Links name can't be blank"
    end

    scenario 'tries to delete link of answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        click_on 'add link'
        fill_in 'Link Name', with: 'My gist'
        fill_in 'Link Url', with: gist_url

        click_on 'Save Answer'

        click_on 'Remove'

        expect(page).to_not have_link 'My gist'
      end
    end
  end
end
