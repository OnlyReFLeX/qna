class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :find_question, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.build
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Question create successfully'
    else
      render :new
    end
  end

  def destroy
    if current_user.id == @question.user_id
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted'
    else
      redirect_to questions_path, alert: "You can not delete someone else's question"
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
