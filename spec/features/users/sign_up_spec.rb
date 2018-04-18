require "rails_helper"

feature 'Sign up', %{
  up order to be able full user
  As a simple user
  I want sign up
} do

  scenario "sign up" do
    visit new_user_registration_path

    fill_in "Email", with: 'user@email.com'
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'

  end

end
