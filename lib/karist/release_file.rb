# frozen_string_literal: true

class ReleaseFile
  attr_reader :env_path, :templates_path, :releases

  def initialize(release_file, env_path, templates_path)
    @env_path = env_path
    @templates_path = templates_path

    @releases = release_file.fetch(:releases, []).map do |release|
      Release.new(release, self)
    end
  end

  def render_all
    @releases.each do |release|
      release.render
    end
  end

  def display_all
    @releases.map do |release|
      release.marshal_all_yaml
    end
  end
end