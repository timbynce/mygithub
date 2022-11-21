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
    can :create, [Question, Answer, Comment, Subscription]
    can %i[update destroy], [Question, Answer, Comment, Subscription], author_id: user.id
    can %i[destroy], [Subscription], user_id: user.id
    can :destroy, Link, linkable: { author_id: user.id }
    can :update_best, Answer, question: { author_id: user.id }

    can [:like, :dislike], [Question, Answer] do |votable|
      votable.author_id != user.id
    end

    can :comment, [Question, Answer] do |commentable|
      votable.author_id != user.id
    end
  end
end
