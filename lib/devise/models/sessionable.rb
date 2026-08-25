# frozen_string_literal: true

module Devise
  module Models
    module Sessionable
      extend ActiveSupport::Concern

      included do
        has_many :user_sessions,
                 class_name: "Devise::Sessionable::UserSession",
                 dependent: :destroy,
                 inverse_of: :user
      end

      def create_user_session!(request)
        user_sessions.create!(
          token: Devise.friendly_token(32),
          user_agent: request.user_agent,
          ip_address: request.remote_ip,
          last_seen_at: Time.current
        )
      end

      def invalidate_all_sessions!
        now = Time.current
        user_sessions.active.update_all(invalidated_at: now, updated_at: now)

        return if user_sessions.invalidated.exists?

        user_sessions.create!(
          token: Devise.friendly_token(32),
          invalidated_at: now,
          last_seen_at: now
        )
      end
    end
  end
end
