# frozen_string_literal: true

require 'rails_helper'

feature 'User can open question page to delete answers', "
  In order to get answer from community
  As an authenticated user
  I'd like to be able to delete answers for question
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user', js: true do
    scenario 'edit question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit Body'
      fill_in 'question_body', with: 'edited question'
      click_on 'Save Question'

      expect(page).to have_content 'edited question'
    end

    scenario 'add files to question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit Body'

      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save Question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_content 'Edit Body'
  end

  scenario 'Another tries to edit question' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Edit Body'
  end
end
