class CommentsController < ActionController::Base
  before_action :find_resource, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @resource.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :resource_id)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast("comments_for_question_#{resource_question_id}", comment: @comment )
  end

  def resource_question_id
    @resource.is_a?(Answer) ? @resource.question_id : @resource.id
  end

  def find_resource
    @resource = if params[:question_id]
                  Question.find(params[:question_id])
                elsif params[:answer_id]
                  Answer.find(params[:answer_id])
                end
  end
end
