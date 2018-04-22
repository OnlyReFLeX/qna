require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should validate_presence_of :body }

  describe "#select_best_answer" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:best_answer) { create(:answer, question: question, user: user, best: true) }

    it "updates the best answer for the question" do
      answer.select_best_answer
      expect(answer.best) == true
      expect(best_answer.best) == false
    end
  end
end
