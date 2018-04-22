class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :find_question, only: :create

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = "Answer successfully deleted"
    else
      flash[:alert] = "You can not delete someone else's answer"
    end
    redirect_to @answer.question
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
