# frozen_string_literal: true

class ThingPolicy < ApplicationPolicy
  def show?
    true
  end

  def actions?
    user?
  end
end