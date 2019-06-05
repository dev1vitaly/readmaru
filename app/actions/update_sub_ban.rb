# frozen_string_literal: true

class UpdateSubBan
  include ActiveModel::Model

  attr_accessor :ban, :current_user, :reason, :days, :permanent

  def save!
    @ban.update!(
      reason: @reason,
      days: @days,
      permanent: @permanent
    )
  rescue ActiveRecord::RecordInvalid => invalid
    errors.merge!(invalid.record.errors)

    raise ActiveModel::ValidationError.new(self)
  else
    CreateLogJob.perform_later(
      sub: @ban.sub,
      current_user: @current_user,
      action: "update_sub_ban",
      loggable: @ban.user,
      model: @ban
    )
  end

  def permanent=(value)
    @permanent = ActiveModel::Type::Boolean.new.cast(value)
  end
end
