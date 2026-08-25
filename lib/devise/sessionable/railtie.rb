# frozen_string_literal: true

module Devise
  module Sessionable
    class Railtie < Rails::Railtie
      initializer "devise-sessionable.locales" do |app|
        locale_path = File.expand_path("../../../config/locales", __dir__)
        app.config.i18n.load_path += Dir[File.join(locale_path, "*.{rb,yml}")]
      end
    end
  end
end
