require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'Прохождение с валидными параметрами' do
      it 'Сохранение ответа в базе данных' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'Редирект на show вопроса после создания' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Прохождение с не валидными параметрами' do
      it 'Факт что ответ не сохраняется' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer)} }.to_not change(Answer, :count)
      end

      it 'Перерендер представления new' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end

end
