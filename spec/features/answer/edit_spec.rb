# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
  " do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question: question, author_id: user.id) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        fill_in 'answer_body', with: 'edited answer'
        click_on 'Save Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit answer with errors' do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        fill_in 'answer_body', with: ''
        click_on 'Save Answer'
      end

      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in another_user
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Edit'
      end
    end

    scenario 'tries to attach file to answer', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save Answer'
      end

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to deattach file to answer', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save Answer'
      end

      within '.answers' do
        click_on 'Remove'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to edit answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Edit'
      end
    end
  end
end
