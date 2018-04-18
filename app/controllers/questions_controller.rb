class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_question, only: :show

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.build
  end

  def show
    @answer = @question.answers.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Question create successfully'
    else
      render :new
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
