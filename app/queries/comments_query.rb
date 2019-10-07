# frozen_string_literal: true

class CommentsQuery < ApplicationQuery
  def not_moderated
    relation.where(removed_at: nil, approved_at: nil)
  end

  def not_removed
    relation.where(removed_at: nil)
  end

  def reported
    relation.joins(:reports)
  end

  def created_after(datetime)
    relation.where("comments.created_at > ?", datetime)
  end

  def search_created_after(datetime)
    return relation if datetime.blank?

    created_after(datetime)
  end

  def bookmarked_by_user(user)
    relation.joins(:bookmarks).where(bookmarks: { user: user }).order("bookmarks.id desc")
  end
end
