class Api::Communities::FollowsPolicy < ApplicationPolicy
  def create?
    user? && !exiled? && !follower?
  end

  def destroy?
    user? && !exiled? && follower?
  end

  private

  def follower?
    user.follows.any? { |follow| follow.followable_id == community.id }
  end
end
