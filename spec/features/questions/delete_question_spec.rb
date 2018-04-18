require "rails_helper"

feature 'Delete question', %{
  In order to be able to delete questions
  As a auth user
  I want to delete the question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  scenario 'Deleting your question' do
    sign_in(user)
    question = create(:question, user: user)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Question successfully deleted'
    expect(page).to have_no_content question.title
  end

  scenario "Removing someone else's question" do
    sign_in(user)
    question = create(:question, user: user2)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content "You can not delete someone else's question"
    expect(page).to have_content question.title
  end
end
