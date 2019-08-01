# frozen_string_literal: true

class BlacklistedDomainPolicy < ApplicationPolicy
  def index?
    true
  end

  def search?
    true
  end

  def create?
    return false unless user_signed_in?
    return true if user_global_moderator?

    sub_context? ? user_sub_moderator? : false
  end

  alias new? create?

  def destroy?
    return false unless user_signed_in?
    return true if user_global_moderator?

    sub_context? ? user_sub_moderator? : false
  end

  def permitted_attributes_for_create
    [:domain]
  end
end
