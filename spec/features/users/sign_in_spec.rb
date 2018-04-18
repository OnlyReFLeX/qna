require "rails_helper"

feature 'Sign in', %{
  In order to be able full user
  As a simple user
  I want sign in
} do

  scenario "sign in" do
    @user = create(:user)

    visit new_user_session_path

    fill_in "Email", with: @user.email
    fill_in "Password", with: "12345678"
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'

  end

end
