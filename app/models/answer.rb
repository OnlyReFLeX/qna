class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def select_best_answer
    if question.answers.exists?(best: true)
      old_best_answer = question.answers.find_by(best: true)
      old_best_answer.update!(best: false)
    end
    self.update!(best: true)
  end
end
