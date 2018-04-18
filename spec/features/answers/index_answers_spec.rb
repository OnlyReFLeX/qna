require "rails_helper"

feature 'Show question answers', %q{
  In order to be able show question answers
  As a simple user
  I want go to the page question and show answers
} do

  scenario 'Question answers' do
    @question = create(:question)
    @answer = create(:answer, { question_id: @question.id })

    visit question_path(@question)
    expect(page).to have_content @question.title
    expect(page).to have_content @answer.body
  end

end
