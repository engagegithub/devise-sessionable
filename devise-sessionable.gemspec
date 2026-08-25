# frozen_string_literal: true

require_relative "lib/devise/sessionable/version"

Gem::Specification.new do |spec|
  spec.name = "devise-sessionable"
  spec.version = Devise::Sessionable::VERSION
  spec.authors = ["Engage Consulting"]
  spec.email = ["support@engageconsulting.com"]

  spec.summary = "Devise extension for per-device session tracking and invalidation"
  spec.description = "Track, soft-invalidate, and purge Devise user sessions across devices."
  spec.homepage = "https://github.com/engagegithub/devise-sessionable"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/engagegithub/devise-sessionable"
  spec.metadata["changelog_uri"] = "https://github.com/engagegithub/devise-sessionable/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    Dir["{lib,config}/**/*", "LICENSE.txt", "Rakefile", "README.md", "devise-sessionable.gemspec"]
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "activejob", ">= 7.0"
  spec.add_dependency "activerecord", ">= 7.0"
  spec.add_dependency "devise", ">= 4.9"
  spec.add_dependency "railties", ">= 7.0"
end
