class QuestionsController < ApplicationController
  before_action :find_question, only: :show

  def new
    @question = Question.new
  end

  def show
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end
end
