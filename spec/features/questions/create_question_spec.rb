require_relative "../features_helper"

feature 'Create questions', %q{
  In order to be able to ask questions
  As a simple user
  I want to be able create question
} do

  given(:user) { create(:user) }

  scenario 'Create question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test text'
    click_on 'Create Question'

    expect(page).to have_content 'Question create successfully'
    expect(page).to have_content 'Test title'
    expect(page).to have_content 'Test text'
  end

  scenario 'Creating a question with errors' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create Question'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  context "mulitple sessions" do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        visit questions_path
        click_on 'Ask question'
        fill_in 'Title', with: 'Test title'
        fill_in 'Body', with: 'Test text'
        click_on 'Create Question'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test title'
      end
    end
  end
end
