require "rails_helper"

feature 'Sign in', %{
  In order to be able full user
  As a simple user
  I want sign in
} do

  given(:user) { create(:user) }

  scenario "sign in" do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'

  end

end
