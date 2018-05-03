require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should have_many :attachments }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like "ratingable"

  describe "#select_best" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:best_answer) { create(:answer, question: question, user: user, best: true) }

    it "the old best question is not getting better" do
      answer.select_best
      best_answer.reload
      expect(best_answer).to_not be_best
    end

    it 'the chosen question becomes the best' do
      answer.select_best
      answer.reload
      expect(answer).to be_best
    end
  end

  it_behaves_like "ratingable"
end
