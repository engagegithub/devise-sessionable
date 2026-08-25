# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module DeviseSessionable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      desc "Creates a migration for the user_sessions table"

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def copy_migration
        migration_template(
          "create_user_sessions.rb.tt",
          "db/migrate/create_user_sessions.rb"
        )
      end

      private

      def migration_version
        "[#{ActiveRecord::Migration.current_version}]"
      end
    end
  end
end
