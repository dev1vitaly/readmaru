# frozen_string_literal: true

module Cleanup
  class BansService
    def call
      BansQuery.new.stale.in_batches.each_record(&:destroy)
    end
  end
end
