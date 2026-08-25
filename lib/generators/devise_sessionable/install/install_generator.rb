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
        return if skip_user_sessions_migration?

        migration_template(
          "create_user_sessions.rb.tt",
          "db/migrate/create_user_sessions.rb"
        )
      end

      private

      def migration_version
        "[#{ActiveRecord::Migration.current_version}]"
      end

      def skip_user_sessions_migration?
        if user_sessions_table_exists?
          say_status :skip, "user_sessions table already exists", :yellow
          true
        elsif user_sessions_migration_exists?
          say_status :skip, "create_user_sessions migration already exists", :yellow
          true
        else
          false
        end
      end

      def user_sessions_table_exists?
        ActiveRecord::Base.connection.data_source_exists?(:user_sessions)
      rescue ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished
        false
      end

      def user_sessions_migration_exists?
        Dir.glob(File.join(destination_root, "db/migrate/*_create_user_sessions.rb")).any?
      end
    end
  end
end
