class AttachmentsController < ApplicationController
  before_action :find_attachment

  authorize_resource

  def destroy
    @attachment.destroy if current_user.author_of?(@attachment.attachable)
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
