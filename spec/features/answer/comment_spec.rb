# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comments to answer', "
	In order to leave additional information to answer
	As an authenticated
	I'd like to be able to add comments
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question: question, author_id: user.id) }

  scenario 'leave a comment to answer', js: true do
    page.driver.browser.manage.window.resize_to(1900, 1080)
    sign_in(user)
    visit question_path(question)
    within '.new-comment-form' do
      fill_in 'comment_body', with: 'New comment'
      click_on 'Add comment'
    end

    expect(page).to have_content('New comment')
  end
end
