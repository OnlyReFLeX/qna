class Ability
  include CanCan::Ability

  def initialize(user)
    user ? user_abilities : guest_abilities
  end

  private

  def guest_abilities
  end

  def user_abilities
  end
end
