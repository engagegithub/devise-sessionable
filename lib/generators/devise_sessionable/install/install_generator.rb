# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module DeviseSessionable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      class_option :skip_user_sessions,
                   type: :boolean,
                   default: false,
                   desc: "Skip the user_sessions migration"

      desc "Creates migrations for user_sessions and account_users.session_token"

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def copy_migrations
        copy_user_sessions_migration unless options[:skip_user_sessions]
        copy_account_users_session_token_migration
      end

      private

      def migration_version
        "[#{ActiveRecord::Migration.current_version}]"
      end

      def copy_user_sessions_migration
        return if skip_user_sessions_migration?

        migration_template(
          "create_user_sessions.rb.tt",
          "db/migrate/create_user_sessions.rb"
        )
      end

      def copy_account_users_session_token_migration
        return if skip_account_users_session_token_migration?

        migration_template(
          "add_session_token_to_account_users.rb.tt",
          "db/migrate/add_session_token_to_account_users.rb"
        )
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

      def skip_account_users_session_token_migration?
        if account_users_session_token_column_exists?
          say_status :skip, "account_users.session_token column already exists", :yellow
          true
        elsif account_users_session_token_migration_exists?
          say_status :skip, "add_session_token_to_account_users migration already exists", :yellow
          true
        else
          false
        end
      end

      def account_users_session_token_column_exists?
        return false unless ActiveRecord::Base.connection.data_source_exists?(:account_users)

        ActiveRecord::Base.connection.column_exists?(:account_users, :session_token)
      rescue ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished
        false
      end

      def account_users_session_token_migration_exists?
        Dir.glob(File.join(destination_root, "db/migrate/*_add_session_token_to_account_users.rb")).any?
      end
    end
  end
end
