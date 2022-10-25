# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilitites : user_abilitites
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilitites
    can :manage, :all
  end

  def user_abilitites
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], author_id: user.id 
  end
end