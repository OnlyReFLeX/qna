class CommentsController < ActionController::Base
  before_action :find_resource

  def create
    @comment = @resource.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      render_json_details
    else
      render_json_errors
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :resource_id)
  end

  def render_json_details
    render json: { comment: @comment.body, klass: @comment.commentable.class.to_s, id: @comment.commentable.id }
  end

  def render_json_errors
    render json: { error: @comment.errors.full_messages.join("\n"), klass: @comment.commentable.class.to_s, id: @comment.commentable.id  }, status: :unprocessable_entity
  end

  def find_resource
    @resource = if params[:question_id]
                  Question.find(params[:question_id])
                elsif params[:answer_id]
                  Answer.find(params[:answer_id])
                end
  end
end
