# frozen_string_literal: true

require 'rails_helper'

feature 'Anonymus user can sign up', %q{
  In order to give answer
  As an authenticated user
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  scenario 'User tries to sign up with correct params' do
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '123456a'
    fill_in 'Password confirmation', with: '123456a'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with uncorrect params' do
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '123456a'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
