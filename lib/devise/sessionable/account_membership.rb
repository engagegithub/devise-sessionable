module Devise
  module Sessionable
    module AccountMembership
      extend ActiveSupport::Concern

      def invalidate_session!
        update_column(:session_token, SecureRandom.hex)
      end

      def session_matches?(captured_token)
        session_token.blank? || session_token == captured_token
      end
    end
  end
end
