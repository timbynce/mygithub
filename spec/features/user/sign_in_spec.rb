# frozen_string_literal: true

require 'rails_helper'

feature 'user can sign in', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
" do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  describe 'Registered user' do
    scenario 'tries to sign in' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'tries to sign in with bad params' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: ''
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
