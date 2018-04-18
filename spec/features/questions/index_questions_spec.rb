require "rails_helper"

feature 'Show index all questions', %{
  In order to be able show all questions
  As a simple user
  I want to go to the page with questions
} do

  scenario 'Index questions' do
    question = create(:question)
    visit questions_path
    expect(page).to have_content question.title
  end
end
