require_relative "../features_helper"

feature 'Delete answer', %{
  In order to be able to delete answers
  As a auth user
  I want to delete the answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  scenario 'Deleting your answer' do
    sign_in(user)
    question = create(:question, user: user)
    answer = create(:answer, user: user, question: question)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Answer successfully deleted'
    expect(page).to have_no_content answer.body
  end

  scenario "Removing someone else's answer" do
    sign_in(user)
    question = create(:question, user: user2)
    answer = create(:answer, user: user2, question: question)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end

  scenario "unregister removing someone else's answer" do
    question = create(:question, user: user)
    answer = create(:answer, user: user, question: question)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end
end
