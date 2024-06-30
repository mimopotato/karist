# frozen_string_literal: true

class Release
  attr_reader :results, :name

  def initialize(release, release_file_obj)
    @release_file = release_file_obj
    @name = release.fetch(:name)
    @namespace = release.fetch(:namespace, "default")
    @template = release.fetch(:template)
    @results = {}
  end

  def render
    custom_file = "#{@release_file.env_path}/#{@name}/custom.yml"
    mutations = YAML.safe_load(File.read(custom_file)).deep_symbolize_keys

    manifests_path = "#{@release_file.templates_path}/#{@template}/manifests/**.yml"
    manifest_files = Dir.glob(manifests_path)
    manifest_files.each do |manifest_file|
      content = YAML.safe_load(File.read(manifest_file)).deep_symbolize_keys
      @results[manifest_file] = content.mutate(mutations)
    end
  end

  def marshal_all_yaml
    @results.map do |k, _|
      marshal_yaml(k)
    end
  end

  def marshal_yaml(k)
    @results[k].deep_stringify_keys.to_yaml
  end
end