# frozen_string_literal: true

require 'rails_helper'

feature 'User can add award to question', "
  In order to get additional motivation
  As an authenticated user
  I'd like to be able to add award
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  scenario 'tries to asks question with correct award', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Badge title', with: 'AWARD!'
    attach_file 'Image', "#{Rails.root}/123.jpg"
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'tries to asks question with incorrect award', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    attach_file 'Image', "#{Rails.root}/123.jpg"
    click_on 'Ask'

    expect(page).to have_content "Badge name can't be blank"
  end
end
