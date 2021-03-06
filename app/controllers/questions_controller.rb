class QuestionsController < ApplicationController
  include Ratinged

  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, only: :show
  before_action :find_current_user_question, only: [:destroy, :update]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.build
    @question.attachments.build
  end

  def show
    @answers = @question.answers.by_best
    @answer = @question.answers.build
    @answer.attachments.build
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
    @question.destroy
    redirect_to questions_path, notice: 'Question successfully deleted'
  end

  def update
    @question.update(question_params)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', question: @question)
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def find_current_user_question
    @question = current_user.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
