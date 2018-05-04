require_relative "../features_helper"

feature 'Add comment to question', %q{
  To make a comment to the question
  As an authenticated user
  I want to create a comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Create comment', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Comment', with: 'Comment text'
    click_on 'Create Comment'
    expect(page).to have_content 'Comment text'
  end

  scenario 'Create comment with invalid attributes', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Comment', with: ''
    click_on 'Create Comment'

    expect(page).to have_content "Body can't be blank"
  end
end
