require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  sign_in_user

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



  describe 'DELETE #destroy' do
    context 'User tries to delete his answer' do
      it 'delete answer' do
        answer

        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end


    context "User tries to remove someone else's answer" do
      before do
        @user2 = create(:user)
        @answer2 = create(:answer, user: @user2, question: question)
      end

      it 'Delete answer' do
        expect { delete :destroy, params: { id: @answer2 } }.to_not change(Answer, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: @answer2 }
        expect(response).to redirect_to question_path(@answer2.question)
      end
    end
  end

end
