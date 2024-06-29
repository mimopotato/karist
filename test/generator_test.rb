# frozen_string_literal: true

require "test_helper"

class GeneratorTest < Test::Unit::TestCase
  include Karist

  test "files are copied to specified directory" do
    Generator.copy_to_path!("./tmp")

    %w(
      ./tmp/templates
      ./tmp/templates/stateless
      ./tmp/templates/stateless/manifests
      ./tmp/templates/stateless/manifests/deployment.yml
      ./tmp/environments
      ./tmp/environments/development
      ./tmp/environments/development/nginx
      ./tmp/environments/development/nginx/custom.yml
      ./tmp/environments/development/releases.yml
    ).each do |path|
      assert File.exist?(path)
    end
  
    FileUtils.rm_f("./tmp")
  end
end
