require_relative "../features_helper"

feature 'Create answers', %q{
  That people know the best answer
  As the author of the question
  I want to choose the best question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'The author chooses the best question', js: true do
    sign_in(user)

    visit question_path(question)

    within ".answer_#{answer.id}" do
      click_link "Choose best"
      expect(page).to_not have_link "Choose best"
    end
  end

  scenario 'Not the author of the question tries to choose the best question' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link "Choose best"
  end

  scenario 'Not the auth tries to choose the best question' do
    visit question_path(question)

    expect(page).to_not have_link "Choose best"
  end
end
