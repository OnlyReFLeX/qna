class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :find_answer, only: [:destroy, :update, :select_best]
  before_action :find_question, only: :create

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      redirect_to @answer.question, alert: "You can not delete someone else's answer"
    end

  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      redirect_to @answer.question, alert: 'You do not have enough rights'
    end
  end

  def select_best
    if current_user&.author_of?(@answer.question)
      @answer.select_best_answer
      render :select_best
    else
      redirect_to @answer.question, alert: 'You are not the author of this question'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
