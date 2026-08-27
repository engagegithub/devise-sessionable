# frozen_string_literal: true

module Devise
  module Sessionable
    class PurgeExpiredJob < ActiveJob::Base
      queue_as :default

      def perform(before:)
        Devise::Sessionable::UserSession.invalidated_before(before).in_batches.delete_all
      end
    end
  end
end
