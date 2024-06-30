# frozen_string_literal: true

require "test_helper"
require "securerandom"

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
  end

  test "rendering environment" do
    
    path = "./tmp-#{SecureRandom.hex(3)}"
    begin
      Generator.copy_to_path!(path)
      renderer = Renderer.new("development", path)
      rendered = renderer.render

      assert rendered.instance_of?(Array)
      assert rendered[0].instance_of?(Release)
      assert rendered[0].results.instance_of?(Hash)

      assert_equal rendered[0].results["#{path}/templates/stateless/manifests/deployment.yml"][:metadata][:name], "nginx-deployment"

      FileUtils.rm_rf(path)
    rescue => e
      FileUtils.rm_rf(path)
      raise e
    end
  end

  test "it saves file to specific location" do
    path = "./tmp-#{SecureRandom.hex(3)}"
    begin
      Generator.copy_to_path!(path)
      renderer = Renderer.new("development", path)
      renderer.render
      renderer.save_to_path!("#{path}/output/development")

      eg_deployment = "#{path}/output/development/nginx/#{path}/templates/stateless/manifests/deployment.yml"
      eg_yaml = YAML.safe_load(File.read(eg_deployment))

      assert_equal eg_yaml["metadata"]["name"], "nginx-deployment"
      assert_equal eg_yaml["spec"]["selector"]["matchLabels"]["app"], "nginx"
      FileUtils.rm_rf(path)
    rescue => e
      FileUtils.rm_rf(path)
      raise e
    end
  end
end