# frozen_string_literal: true

class Renderer
  def initialize(env, root_path=".")
    @env_path = "#{root_path}/environments/#{env}"
    @templates_path = "#{root_path}/templates"

    @release_file = File.read("#{@env_path}/releases.yml").then do |f|
      YAML.safe_load(f).then do |y|
        y.deep_symbolize_keys.then do |r|
          ReleaseFile.new(r, @env_path, @templates_path)
        end
      end
    end
  end

  def render
    @release_file.render_all
  end

  def display
    @release_file.display_all
  end

  def save_to_path!(path)
    begin
      FileUtils.mkdir_p(path)
      @release_file.releases.each do |release|
        FileUtils.mkdir_p("#{path}/#{release.name}")
        release.results.each do |filename, result|
          r_filename = filename.split("/")
          case r_filename
          in [*subpath, filename]
            result_path = "#{path}/#{release.name}/#{subpath.join("/")}"
            FileUtils.mkdir_p(result_path)
            File.open("#{result_path}/#{filename}", "a+") do |f|
              f.write(result.deep_stringify_keys.to_yaml)
            end
          end
        end
      end
      return true
    rescue => e
      raise e
      return false
    end
  end
end
    