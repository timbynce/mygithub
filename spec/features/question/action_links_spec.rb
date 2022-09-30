# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to get additional info to question
  As an authenticated user
  I'd like to be able to add links
" do

  given(:user) { create(:user) }
  given(:gist_url) {  'https://gist.github.com/timbynce/2583f0ce3b9d2027ae2370a2b0c022ec' }
  given!(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user', js: true  do
    scenario 'adds link when asks question' do 
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'tesxt text text'
      fill_in 'Link Name', with: 'My gist'
      fill_in 'Link Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist'
    end

    scenario 'tries to add wrong link when asks question' do 
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'tesxt text text'
      fill_in 'Link Url', with: "ololo"

      click_on 'Ask'

      expect(page).to have_content 'Links url is not a valid URL'
      expect(page).to have_content "Links name can't be blank"
    end

    scenario 'tries to add correct link when edit question' do 
      sign_in(user)
      visit question_path(question)
      click_on 'Edit Body'

      within '.question' do
        click_on 'add link'
        fill_in 'Link Name', with: 'My gist'
        fill_in 'Link Url', with: gist_url
        click_on 'Save Question'

        expect(page).to have_link 'My gist'
      end
    end

    scenario 'tries to add incorrect link when edit question' do 
      sign_in(user)
      visit question_path(question)
      click_on 'Edit Body'

      within '.question' do
        click_on 'add link'
        fill_in 'Link Url', with: "ololo"
        click_on 'Save Question'
      end

      expect(page).to have_content 'Links url is not a valid URL'
      expect(page).to have_content "Links name can't be blank"
    end

    scenario 'tries to delete link when edit question' do 
      sign_in(user)
      visit question_path(question)
      click_on 'Edit Body'

      within '.question' do
        click_on 'add link'
        fill_in 'Link Name', with: 'My gist'
        fill_in 'Link Url', with: gist_url
        click_on 'Save Question'

        within '.question_links' do
          click_on 'Remove'
          expect(page).to_not have_link 'My gist'
        end
      end
    end
  end
end
