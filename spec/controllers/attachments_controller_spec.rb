require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let(:other_user) { create(:user) }
  let(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    context 'User tries to delete his attachment' do
      it 'delete attachment' do
        attachment
        expect { delete :destroy, params: { id: attachment }, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end


    context "User tries to remove someone else's answer" do
      before do
        @user2 = create(:user)
        @question2 = create(:question, user: @user2)
        @attachment2 = create(:attachment, attachable: @question2)
      end

      it 'Delete answer' do
        expect { delete :destroy, params: { id: @attachment2 }, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end
