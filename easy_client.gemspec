# frozen_string_literal: true

require_relative "lib/easy_client/version"

Gem::Specification.new do |spec|
  spec.name = "easy_client"
  spec.version = EasyClient::VERSION
  spec.authors = ["Ivan Vazquez"]
  spec.email = ["ivanvazquezweb@gmail.com"]

  spec.summary = "EasyBroker API Client for Property Management"
  spec.description = "A flexible Ruby client for the EasyBroker API, designed to interact with property resources and
    easily extendable to other API endpoints. Simplifies property data retrieval and management for real estate apps."
  spec.homepage = "https://github.com/baroque-works/easy_client"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.21.0"

  spec.metadata["rubygems_mfa_required"] = "true"
end
