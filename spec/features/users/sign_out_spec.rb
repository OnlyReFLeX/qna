require "rails_helper"

feature 'log out', %{
  In order to be able simple user
  As a full user
  I want log out
} do

  scenario "Log out" do
    @user = create(:user)

    visit new_user_session_path

    fill_in "Email", with: @user.email
    fill_in "Password", with: "12345678"
    click_on 'Log in'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'

  end

end
