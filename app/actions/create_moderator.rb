# frozen_string_literal: true

class CreateModerator
  include ActiveModel::Model

  attr_accessor :current_user, :sub, :username
  attr_reader :moderator

  validates :username, presence: true, username_format: true

  with_options if: ->(record) { record.errors.blank? } do
    validates :username, username_existence: true
    validates :username, user_not_banned: true
    validates :username, user_not_moderator: true
  end

  def save
    return false if invalid?

    @user = UsersQuery.new.where_username(@username).take!

    @moderator = @sub.moderators.create!(
      invited_by: @current_user,
      user: @user
    )
  rescue ActiveRecord::RecordInvalid => invalid
    errors.merge!(invalid.record.errors)

    return false
  end
end
