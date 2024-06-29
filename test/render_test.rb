# frozen_string_literal: true

require "test_helper"

class RenderTest < Test::Unit::TestCase
  include Karist

  test "single manifest is rendered from examples" do
    manifest_path = "./lib/examples/templates/stateless/manifests/deployment.yml"
    custom_path = "./lib/examples/environments/development/nginx/custom.yml"

    # #safe_load and #load from YAML library always return keys as string.
    # we rely on symbols internally.
    # #transform_keys(&:to_sym) is not recursive.
    # only solution found at the moment is to copy code from Rails, with
    # #deep_symbolize_keys
    yaml_manifest = YAML.safe_load(File.read(manifest_path)).deep_symbolize_keys
    yaml_custom = YAML.safe_load(File.read(custom_path)).deep_symbolize_keys

    output = yaml_manifest.mutate(yaml_custom)
    assert_equal output[:metadata][:name], "nginx-deployment"
    assert_equal output[:spec][:selector][:matchLabels][:app], "nginx"
    assert_equal output[:spec][:template][:metadata][:labels][:app], "nginx"
    assert output[:spec][:template][:spec][:containers][0][:ports][0][:containerPort].instance_of?(Integer)
    pp output
  end
end