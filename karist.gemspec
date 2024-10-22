# frozen_string_literal: true

require_relative "lib/karist/version"

Gem::Specification.new do |spec|
  spec.name = "karist"
  spec.version = Karist::VERSION
  spec.authors = ["Mimosao"]
  spec.email = ["mimosao@duck.com"]

  spec.summary = "Karist is a templating system for Kubernetes"
  spec.description = "Karist simplifies development of manifests and releases on Kubernetes by automating templating operations."
  spec.homepage = "https://github.com/mimosao/karist"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mimosao/karist"
  spec.metadata["changelog_uri"] = "https://github.com/mimosao/karist"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["karist"]
  #spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "fileutils", "~> 1.7"
  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end