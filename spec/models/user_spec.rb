require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  describe "#author_of?(resource)" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "a test that the user is the author" do
      expect(user.author_of?(question)).to eq true
    end
    it "a test that the user is not the author" do
      expect(user2.author_of?(question)).to eq false
    end
  end
end
