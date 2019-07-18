# frozen_string_literal: true

class ModeratorPolicy < ApplicationPolicy
  def index?
    true
  end

  alias search? index?

  def create?
    user_signed_in? && context.user.moderator?(context.sub)
  end

  alias new? create?
  alias confirm? create?
  alias destroy? create?
end
