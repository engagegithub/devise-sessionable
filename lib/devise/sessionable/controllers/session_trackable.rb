# frozen_string_literal: true

module Devise
  module Sessionable
    module Controllers
      module SessionTrackable
        extend ActiveSupport::Concern

        included do
          before_action :verify_tracked_user_session
        end

        def sign_in(resource_or_scope, *args)
          options = args.extract_options!
          resource = args.last || resource_or_scope

          super(resource_or_scope, *args, options).tap do
            track_session_creation(resource, options)
          end
        end

        def sign_out(resource_or_scope = nil)
          track_session_destruction
          super
        end

        private

        def track_session_creation(resource, options = {})
          return if options[:store] == false
          return unless resource.respond_to?(:create_user_session!)

          if (previous_token = session[Devise::Sessionable::UserSession::SESSION_KEY])
            resource.user_sessions.active.find_by(token: previous_token)&.invalidate!
          end

          user_session = resource.create_user_session!(request)
          session[Devise::Sessionable::UserSession::SESSION_KEY] = user_session.token
        end

        def track_session_destruction
          token = session[Devise::Sessionable::UserSession::SESSION_KEY]
          return if token.blank? || current_user.blank?

          current_user.user_sessions.active.find_by(token: token)&.invalidate!
          session.delete(Devise::Sessionable::UserSession::SESSION_KEY)
        end

        def verify_tracked_user_session
          return unless user_signed_in?

          token = session[Devise::Sessionable::UserSession::SESSION_KEY]
          if token.present?
            verify_active_session_token(token)
          else
            Rails.logger.warn("[Devise::Sessionable] missing session token; skipping verification")
          end
        end

        def verify_active_session_token(token)
          user_session = current_user.user_sessions.active.find_by(token: token)
          if user_session
            user_session.touch_last_seen_at
          else
            revoke_invalid_browser_session!
          end
        end

        def revoke_invalid_browser_session!
          sign_out(current_user)

          if request.format.html?
            redirect_to new_user_session_path,
                        alert: I18n.t("devise.failure.session_invalidated")
          else
            head :unauthorized
          end
        end
      end
    end
  end
end
