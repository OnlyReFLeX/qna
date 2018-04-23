require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: @user) }

    before { get :index }

    it 'Get array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render view index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show template' do
      expect(response).to render_template :show
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
        expect(flash[:notice]).to eq 'Question create successfully'
      end

      it 'question is associated with the user' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User tries to delete his question' do
      it 'delete question' do
        question

        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end


    context "User tries to remove someone else's question" do
      before do
        @user2 = create(:user)
        @question2 = create(:question, user: @user2)
      end

      it 'Delete question' do
        expect {
          expect { delete :destroy, params: { id: @question2 } }.to raise_exception(ActiveRecord::RecordNotFound)
        }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested question to @question' do
      patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, params: { id: question, question: { body: 'new body'} }, format: :js
      question.reload
      expect(question.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
      expect(response).to render_template :update
    end

    context 'Other user' do
      let(:other_question) { create(:question, user: other_user) }

      it "User tries to edit someone else's question" do
        expect { patch :update, params: { id: other_question, question: { body: 'new body'} }, format: :js }.to raise_exception(ActiveRecord::RecordNotFound)
        other_question.reload
        expect(other_question.body).to_not eq 'new body'
      end
    end
  end
end
