# frozen_string_literal: true

require 'rails_helper'

feature 'Anonymus user can sign up', %q{
  In order to give answer
  As an authenticated user
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  describe "Unregistered user" do
    scenario 'tries to sign up with correct params' do
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: '123456a'
      fill_in 'Password confirmation', with: '123456a'
      click_on 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'tries to sign up with uncorrect params' do
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: '123456a'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  describe "Registered user" do
    given(:user) { create(:user) }

    scenario "user try to register again" do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '123456a'
      fill_in 'Password confirmation', with: '123456a'
      click_on 'Sign up'
      expect(page).to have_content "Email has already been taken"
    end

    scenario 'Authenticated user tries to sign up' do
      sign_in(user)  
      visit new_user_registration_path  
      expect(page).to have_content 'You are already signed in.'
    end
  end
end
