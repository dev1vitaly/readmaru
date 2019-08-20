# frozen_string_literal: true

class Post < ApplicationRecord
  include Paginatable
  include Removable
  include Reportable
  include Votable
  include Markdownable
  include Uploader::Attachment.new(:media)

  belongs_to :community, touch: true
  belongs_to :user, touch: true
  has_one :topic, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  belongs_to :approved_by, class_name: "User", foreign_key: "approved_by_id", touch: true, optional: true
  belongs_to :edited_by, class_name: "User", foreign_key: "edited_by_id", touch: true, optional: true

  markdown_attributes :text
  strip_attributes :title, squish: true
  strip_attributes :text

  before_create :normalize_url_on_create
  before_create :set_media_processing_attributes_on_media_cache
  before_update :reset_deletion_attributes_on_media_store
  after_create :create_topic_on_create
  before_create -> { approve(user) }, if: :auto_approve?
  before_update :undo_remove, if: :approving?
  before_update :undo_approve, if: :editing?

  validates :title, presence: true, length: { maximum: 350 }

  with_options if: ->(r) { r.text.present? } do
    validates :text, presence: true, length: { maximum: 10_000 }
    validates :url, absence: true
    validates :media, absence: true
  end

  with_options if: ->(r) { r.url.present? } do
    validates :url, presence: true, length: { maximum: 2048 }, url_format: true
    validates :text, absence: true
    validates :media, absence: true
  end

  with_options if: ->(r) { r.media.present? } do
    validates :media, presence: true
    validates :text, absence: true
    validates :url, absence: true
  end

  with_options if: -> (r) { r.text.blank? && r.url.blank? && r.media.blank? } do
    validates :media, presence: true
    validates :text, presence: true
    validates :url, presence: true
  end

  def youtube?
    @youtube ||= %w(youtube.com www.youtube.com youtu.be www.youtu.be).include?(URI(url).host)
  end

  def youtube_id
    @youtube_id ||= url.to_s.gsub(/(https?:\/\/)?(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/) do
      Regexp.last_match(4).to_s
    end
  end

  def image?
    media[:original].type == "image"
  end

  def video?
    media[:original].type == "video"
  end

  def gif?
    media[:original].type == "gif"
  end

  def cut_text_preview?
    text.length > 800
  end

  def cut_image_preview?
    _, height = image_content_dimensions
    height > 550
  end

  def image_content_dimensions
    variant = :desktop

    if media[variant].height > 550
      coefficient_by_max_height = 550 / media[variant].height.to_f
      width_calculated_with_coefficient_by_max_height = (media[variant].width * coefficient_by_max_height).round

      if width_calculated_with_coefficient_by_max_height < 350
        coefficient_by_min_width = 350 / media[variant].width.to_f

        [(media[variant].width * coefficient_by_min_width).round, (media[variant].height * coefficient_by_min_width).round]
      else
        [width_calculated_with_coefficient_by_max_height, (media[variant].height * coefficient_by_max_height).round]
      end
    else
      [media[variant].width, media[variant].height]
    end
  end

  def approve!(user)
    approve(user)
    save!
  end

  def approved?
    approved_at.present?
  end

  def edit(user)
    assign_attributes(edited_by: user, edited_at: Time.current)
  end

  def edited?
    edited_at.present?
  end

  private

  def approve(user)
    assign_attributes(approved_by: user, approved_at: Time.current)
  end

  def undo_approve
    assign_attributes(approved_by: nil, approved_at: nil)
  end

  def approving?
    approved_at.present? && approved_at_changed?
  end

  def auto_approve?
    context = Context.new(user, community)
    Pundit.policy(context, self).approve?
  end

  def editing?
    edited_at.present? && edited_at_changed?
  end

  def normalize_url_on_create
    return if url.blank?

    self.url = Addressable::URI.parse(self.url).normalize.to_s
  end

  def set_media_processing_attributes_on_media_cache
    return unless media.present? || (media_data_changed? && media_attacher.cached?)

    assign_attributes(removed_by: user, removed_at: Time.current)
  end

  def reset_deletion_attributes_on_media_store
    return unless media.present? || (media_data_changed? && media_attacher.stored?)

    reset_deletion_attributes
  end

  def create_topic_on_create
    create_topic!
  end
end