class CommentsController < ActionController::Base
  before_action :find_resource

  def create
    @comment = @resource.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :resource_id)
  end

  def find_resource
    @resource = if params[:question_id]
                  Question.find(params[:question_id])
                elsif params[:answer_id]
                  Answer.find(params[:answer_id])
                end
  end
end
