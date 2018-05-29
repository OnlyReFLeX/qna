require 'rails_helper'

describe 'answers API' do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 5, user: user) }
  let(:question) { questions.first }
  let!(:answers) { create_list :answer, 5, question: question, user: user }

  describe 'GET #index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get '/api/v1/questions/', params: { format: :json, access_token: access_token.token } }

      it_behaves_like "response successful"
      it_behaves_like "return array size", 'questions', 5
      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let(:answer) { answers.first }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create(:user) }
      let!(:comments) { create_list :comment, 5, commentable: answer, user: user }
      let!(:attachments) { create_list :attachment, 5, attachable: answer }
      let(:comment) { comments.last }
      let(:attachment) { attachments.last }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it_behaves_like "response successful"
      it_behaves_like "return array size", 'comments', 5, 'comments'
      it_behaves_like "return array size", 'attachments', 5, 'attachments'

      it "attachments object contains file" do
        expect(response.body).to be_json_eql(attachment.file.to_json).at_path('attachments/0/file')
      end

      %w(id body created_at updated_at).each do |attr|
        it "comments object contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
        end
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      context 'with valid attributes' do
        it 'saves the new answer in the database' do
          expect { answer_create(:answer, question) }.to change(Answer, :count).by(1)
        end

        it 'answer is associated with the question' do
          expect { answer_create(:answer, question) }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { answer_create(:invalid_answer, question) }.to_not change(Answer, :count)
        end
      end
    end

    def answer_create(attribute, question)
      post "/api/v1/questions/#{question.id}/answers", params: { question_id: question, answer: attributes_for(attribute), format: :json, access_token: access_token.token }
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
