# frozen_string_literal: true

require 'rails_helper'

feature 'User can open question page to create answers', "
  In order to get answer from community
  As an authenticated user
  I'd like to be able to create answers for question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  context 'muliple sessions' do
    scenario 'answer appears on other users page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'New answer'
        fill_in 'Answer', with: 'answer text text'
        click_on 'Send answer'
        expect(page).to have_content 'answer text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'answer text text'
      end
    end
  end
  describe 'Authenticated user', js: true do
    scenario 'create answer of question' do
      sign_in(user)
      visit question_path(question)
      click_on 'New answer'
      fill_in 'Answer', with: 'answer text text'
      click_on 'Send answer'
      expect(page).to have_content 'answer text text'
    end

    scenario 'create answer of question with errors' do
      sign_in(user)
      visit question_path(question)
      click_on 'New answer'
      click_on 'Send answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create answer of question with attached file', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'New answer'
      fill_in 'Answer', with: 'answer text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Send answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user answer a question' do
    visit question_path(question)
    click_on 'New answer'
    fill_in 'Answer', with: 'answer text text'
    click_on 'Send answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
