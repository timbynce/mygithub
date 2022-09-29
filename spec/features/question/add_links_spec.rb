# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to get additional info to question
  As an authenticated user
  I'd like to be able to add links
" do

  given(:user) { create(:user) }
  given(:gist_url) {  'https://gist.github.com/timbynce/2583f0ce3b9d2027ae2370a2b0c022ec' }


  scenario 'User adds link when asks question', js: true do 
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'tesxt text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist'
  end


end
