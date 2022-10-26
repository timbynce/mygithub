# frozen_string_literal: true

require 'rails_helper'

feature 'Authorization from providers', %q{
  In order to have access to app
  As a user
  I want to be able to sign in with my social network accounts
} do

  given!(:user) { create(:user, email: 'new@user.com')}
  background { visit new_user_session_path }

  describe 'Sign in with Vkontakte', js: true do
    scenario 'sign in user' do
      mock_auth_hash(:vkontakte, 'new@user.com')

      click_on 'Sign in with Vkontakte'
      
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end
  end

  describe 'Sign in with GitHub', js: true do
    scenario 'sign in user' do
      mock_auth_hash(:github, 'new@user.com')
      click_on 'Sign in with GitHub'
      
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end
  end
end
