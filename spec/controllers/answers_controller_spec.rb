require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'Assigning a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render view new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'Passing with valid parameters' do
      it 'stores answer in DB' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'Redirect to show question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Passing with non-valid parameters' do
      it 'answer is not saved' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer)} }.to_not change(Answer, :count)
      end

      it 're-render view new' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end

end
