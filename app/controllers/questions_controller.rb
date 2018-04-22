class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :find_question, only: [:show, :destroy, :update]

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
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Question successfully deleted'
    else
      flash[:alert] = "You can not delete someone else's question"
    end
    redirect_to questions_path
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      redirect_to question_params, alert: "You can not delete someone else's question"
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
