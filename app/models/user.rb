class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  has_many :answers
  has_many :comments
  has_many :ratings

  def author_of?(resource)
    resource.user_id == self.id
  end

  def non_author_of?(resource)
    !author_of?(resource)
  end
end
