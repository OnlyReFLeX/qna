require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user
  let!(:resource) { create(:question, user: @user) }

  describe 'POST #create' do
    context 'Passing with valid parameters' do
      it 'stores comment in DB' do
        expect { post :create, params: { question_id: resource, comment: attributes_for(:comment) }, format: :js }.to change(resource.comments, :count).by(1)
      end

      it 'comment is associated with the user' do
        expect { post :create, params: { question_id: resource, comment: attributes_for(:comment) }, format: :js }.to change(@user.comments, :count).by(1)
      end
    end

    context 'Passing with non-valid parameters' do
      it 'comment is not saved' do
        expect { post :create, params: { question_id: resource, comment: attributes_for(:invalid_comment) }, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
