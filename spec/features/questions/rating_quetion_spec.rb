require_relative "../features_helper"

feature 'Rating for question', %q{
  In order to to view the rating of the question
  As an authenticated user
  I want to vote for the question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: other_user) }

  before do
    sign_in(user)
  end

  scenario 'user votes for the positive side of the question', js: true do
    visit question_path(question)
    click_on 'Like'
    expect(page).to_not have_content 'Dislike'
    expect(page).to_not have_content 'Like'
    expect(page).to have_content 'Cancel'
    expect(page).to have_content '1'
  end

  scenario 'the user votes for the negative side of the question', js: true do
    visit question_path(question)
    within (".question_#{question.id}") do
      click_on 'Dislike'
    end
    expect(page).to_not have_content 'Dislike'
    expect(page).to_not have_content 'Like'
    expect(page).to have_content 'Cancel'
    expect(page).to have_content '-1'
  end

  scenario 'User cancels your vote', js: true do
    visit question_path(question)
    within (".question_#{question.id}") do
      click_on 'Dislike'
    end

    expect(page).to have_content '-1'
    expect(page).to have_content 'Cancel'

    click_on 'Cancel'

    expect(page).to have_content '0'
  end
end
