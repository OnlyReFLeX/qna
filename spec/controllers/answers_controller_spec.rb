require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:other_user) { create(:user) }

  describe 'POST #create' do

    context 'Passing with valid parameters' do
      it 'stores answer in DB' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'Render create teamplate to show question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end

      it 'answer is associated with the user' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(@user.answers, :count).by(1)
      end
    end

    context 'Passing with non-valid parameters' do
      it 'answer is not saved' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer)}, format: :js }.to_not change(Answer, :count)
      end

      it 'Render create teamplate to show question' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:answer)).to eq answer
    end

   it 'assigns th question' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'} }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
      expect(response).to render_template :update
    end

    context 'Other user' do
      let(:other_answer) { create(:answer, question: question, user: other_user) }

      it "User tries to edit someone else's answer" do
        expect { patch :update, params: { id: other_answer, question_id: question, answer: { body: 'new body'} }, format: :js }.to raise_exception(ActiveRecord::RecordNotFound)
        other_answer.reload
        expect(other_answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User tries to delete his answer' do
      it 'delete answer' do
        answer
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end


    context "User tries to remove someone else's answer" do
      before do
        @user2 = create(:user)
        @answer2 = create(:answer, user: @user2, question: question)
      end

      it 'Delete answer' do
        expect {
          expect { delete :destroy, params: { id: @answer2 }, format: :js }.to raise_exception(ActiveRecord::RecordNotFound)
        }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #select_best' do
    let!(:other_question) { create(:question, user: other_user) }
    let(:other_answer) { create(:answer, question: other_question, user: other_user) }

    it 'assigns answer to @answer' do
      patch :select_best, params: { id: answer }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'The author of the question tries to choose the best question' do
      patch :select_best, params: { id: answer }, format: :js
      answer.reload
      expect(answer).to be_best
    end

    it "User tries to choose the best answer of someone else's question" do
      patch :select_best, params: { id: other_answer }, format: :js
      expect(response.status).to eq 403
    end
  end

  let(:resource) { create(:answer, user: other_user, question: question) }
  let(:other_resource) { create(:answer, user: @user, question: question) }
  it_behaves_like 'ratinged'
end
