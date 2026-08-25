# frozen_string_literal: true

module Devise
  module Sessionable
    class UserSession < ActiveRecord::Base
      self.table_name = "user_sessions"

      SESSION_KEY = "user_session_token"

      belongs_to :user, inverse_of: :user_sessions

      scope :active, -> { where(invalidated_at: nil) }
      scope :invalidated, -> { where.not(invalidated_at: nil) }
      scope :invalidated_before, ->(time) { invalidated.where(invalidated_at: ..time) }

      def active?
        invalidated_at.nil?
      end

      def invalidate!
        return unless active?

        update!(invalidated_at: Time.current)
      end

      def touch_last_seen_at
        return if last_seen_at.present? && last_seen_at > 5.minutes.ago

        update_column(:last_seen_at, Time.current)
      end
    end
  end
end
