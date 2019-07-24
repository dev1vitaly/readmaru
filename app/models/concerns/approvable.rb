# frozen_string_literal: true

module Approvable
  extend ActiveSupport::Concern

  included do
    belongs_to :approved_by, class_name: "User", foreign_key: "approved_by_id", optional: true

    before_create :approve_on_create
    before_update :undelete_on_approve
    after_update :update_comment_in_topic_on_approve

    def approvable?
      true
    end

    def approved?
      approved_at.present?
    end

    private

    def approving?
      approved_at_changed? && approved?
    end

    def auto_approve?
      user.moderator?(sub) || user.contributor?(sub)
    end

    def reset_approve_attributes
      assign_attributes(approved_by: nil, approved_at: nil)
    end

    def approve_on_create
      if auto_approve?
        assign_attributes(approved_by: user, approved_at: Time.current)
      end
    end

    def undelete_on_approve
      if approving?
        reset_deletion_attributes
      end
    end

    def update_comment_in_topic_on_approve
      return unless comment?
      return unless deleted_at_previously_changed?

      ActiveRecord::Base.connection.execute(
        "UPDATE topics SET branch = jsonb_set(branch, '{#{id}, deleted}', '#{deleted?}', false), updated_at = '#{Time.current.strftime('%Y-%m-%d %H:%M:%S.%N')}' WHERE post_id = #{post_id};"
      )
    end
  end
end