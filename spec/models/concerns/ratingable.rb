shared_examples_for "ratingable" do
  it { should have_many(:ratings).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:resource) { create(:question, user: user) }

  describe '#vote_up(user)' do
    it 'adds a positive voice' do
      resource.vote_up(user)
      expect(resource.rating).to eq 1
    end

    it 'the voice became attached to him' do
      expect { resource.vote_up(user) }.to change(resource.ratings, :count).by(1)
    end
  end

  describe '#vote_down(user)' do
    it 'adds a negative voice' do
      resource.vote_down(user)
      expect(resource.rating).to eq -1
    end

    it 'the voice became attached to him' do
      expect { resource.vote_down(user) }.to change(resource.ratings, :count).by(1)
    end
  end

  describe '#vote_reset(user)' do
    it 'rating cleared from the base' do
      resource.vote_up(user)

      expect { resource.vote_reset(user) }.to change(resource.ratings, :count).by(-1)
    end
  end

  describe '#rating' do
    it 'returns the values ​​of the rating' do
      resource.vote_up(user)
      expect(resource.rating).to eq 1
    end
  end

  describe '#voted?(user)' do
    it 'user voted' do
      expect(resource.voted?(user)).to be false
    end

    it 'user not voted' do
      resource.vote_up(user)
      expect(resource.voted?(user)).to_not be false
    end
  end
end
