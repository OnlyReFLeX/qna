FactoryBot.define do
  factory :answer do
    body "MyAnswersText"
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
