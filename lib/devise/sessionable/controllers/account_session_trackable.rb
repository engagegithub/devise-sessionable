# frozen_string_literal: true

module Devise
  module Sessionable
    module Controllers
      module AccountSessionTrackable
        extend ActiveSupport::Concern

        SESSION_TOKENS_KEY = "account_session_tokens"

        included do
          before_action :enforce_account_session!, if: :user_signed_in?
        end

        def sign_in(resource_or_scope, *args)
          options = args.extract_options!
          resource = args.last || resource_or_scope

          super(resource_or_scope, *args, options).tap do
            next if options[:store] == false

            capture_account_session_tokens!(resource)
          end
        end

        private

        def capture_account_session_tokens!(resource)
          return unless resource.respond_to?(:account_users)

          session[SESSION_TOKENS_KEY] =
            resource.account_users.pluck(:account_id, :session_token).to_h.transform_keys(&:to_s)
        end

        def enforce_account_session!
          return if devise_controller?
          return if impersonating_user?

          account_user = current_account_user_for_session_enforcement
          return unless account_user
          return if account_user.session_matches?(session.dig(SESSION_TOKENS_KEY, account_user.account_id.to_s))

          reject_invalid_account_session!
        end

        def current_account_user_for_session_enforcement
          Current.account_user if defined?(Current) && Current.respond_to?(:account_user)
        end

        def impersonating_user?
          respond_to?(:true_user, true) && true_user.present? && true_user != current_user
        end

        def reject_invalid_account_session!
          sign_out(current_user)
          redirect_to new_user_session_path,
                      alert: I18n.t("devise_sessionable.account_membership.session_invalidated")
        end
      end
    end
  end
end
