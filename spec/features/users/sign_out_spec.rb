# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can sign out', %q{
  In order to keep safety
  As an unauthenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }
  
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign out' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    visit questions_path
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to find sign out button' do
    visit questions_path
    expect(page).to have_content 'Sign in'
  end
end
