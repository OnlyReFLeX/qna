class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :find_question, only: [:create, :new]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to @question, notice: 'Answer create successfully'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
