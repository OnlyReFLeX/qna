require_relative "../features_helper"

feature 'Create answers', %q{
  In order to be able to answer for question
  As a simple user
  I want to be able create answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Create answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'Answer text'
    click_on 'Create Answer'
    within '.answers' do
      expect(page).to have_content 'Answer text'
    end
  end

  scenario 'Create answer with invalid attributes', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: ''
    click_on 'Create Answer'

    expect(page).to have_content "Body can't be blank"
  end
end
