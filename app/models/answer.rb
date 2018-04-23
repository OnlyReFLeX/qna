class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def select_best
    old_best = question.answers.find_by(best: true)

    transaction do
      old_best.update!(best: false) unless old_best.nil?
      self.update!(best: true)
    end
  end
end
