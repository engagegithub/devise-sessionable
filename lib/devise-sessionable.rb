# frozen_string_literal: true

require "devise"
require "active_record"
require "active_job"

require "devise/sessionable/version"
require "devise/sessionable/user_session"
require "devise/models/sessionable"
require "devise/sessionable/account_membership"
require "devise/sessionable/controllers/session_trackable"
require "devise/sessionable/controllers/account_session_trackable"
require "devise/sessionable/purge_expired_job"
require "devise/sessionable/railtie" if defined?(Rails::Railtie)

module Devise
  module Sessionable
  end
end

Devise.add_module :sessionable, model: "devise/models/sessionable"
