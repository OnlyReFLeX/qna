require_relative "../features_helper"

feature 'Show index all questions', %{
  In order to be able show all questions
  As a simple user
  I want to go to the page with questions
} do

  given(:user) { create(:user) }

  scenario 'Index questions' do
    questions = create_list(:question, 2, user: user)
    visit questions_path
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end
end
