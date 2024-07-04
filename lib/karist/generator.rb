# frozen_string_literal: true

module Karist
  class Generator
    def self.copy_to_path!(path)
      examples_dir = File.dirname(__dir__) + "/examples"
      FileUtils.cp_r(examples_dir, path, verbose: false)
    end
  end
end