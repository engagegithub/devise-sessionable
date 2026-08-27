# frozen_string_literal: true

module Devise
  module Sessionable
    class UserSession < ActiveRecord::Base
      self.table_name = "user_sessions"

      SESSION_KEY = "user_session_token"
      LAST_SEEN_TTL = 5.minutes.to_i

      belongs_to :user, inverse_of: :user_sessions

      scope :active, -> { where(invalidated_at: nil) }
      scope :invalidated, -> { where.not(invalidated_at: nil) }
      scope :invalidated_before, ->(time) { invalidated.where(invalidated_at: ..time) }

      def active?
        invalidated_at.nil?
      end

      def invalidate!
        return unless active?

        update_column(:invalidated_at, Time.current)
      end

      def touch_last_seen_at
        return if last_seen_at.present? && last_seen_at > LAST_SEEN_TTL.seconds.ago

        update_column(:last_seen_at, Time.current)
      end
    end
  end
end
