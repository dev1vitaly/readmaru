# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :thing
end
