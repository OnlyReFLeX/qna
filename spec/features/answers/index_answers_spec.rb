require "rails_helper"

feature 'Show question answers', %q{
  In order to be able show question answers
  As a simple user
  I want go to the page question and show answers
} do

  given(:user) { create(:user) }

  scenario 'Question answers' do
    @question = create(:question, user: user)
    @answer = create(:answer, question: @question, user: user)

    visit question_path(@question)
    expect(page).to have_content @question.title
    expect(page).to have_content @answer.body
  end

end
