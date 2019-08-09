# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password validations: false
  has_secure_token :forgot_password_token

  has_many :subs, dependent: :restrict_with_error
  has_many :follows, dependent: :destroy
  has_many :moderators, dependent: :destroy
  has_many :contributors, dependent: :destroy
  has_many :bans, dependent: :destroy
  has_many :posts, dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error
  has_many :bookmarks, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :rate_limits, dependent: :destroy

  def to_param
    username
  end
end
