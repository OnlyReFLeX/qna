require "rails_helper"

feature 'Create answers', %q{
  In order to be able to answer for question
  As a simple user
  I want to be able create answer
} do

  given(:user) { create(:user) }

  scenario 'Create answer' do
    sign_in(user)
    @question = create(:question, user: user)

    visit question_path(@question)

    fill_in 'Body', with: 'Answer text'
    click_on 'Create Answer'

    expect(page).to have_content 'Answer create successfully'
    expect(page).to have_content 'Answer text'
  end

  scenario 'Create answer with invalid attributes' do
    sign_in(user)
    @question = create(:question, user: user)

    visit question_path(@question)

    fill_in 'Body', with: ''
    click_on 'Create Answer'

    expect(page).to have_content "Body can't be blank"
  end
end