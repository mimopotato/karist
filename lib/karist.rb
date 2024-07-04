# frozen_string_literal: true
require "fileutils"
require "yaml"
require "json"

require_relative "karist/version"
require_relative "karist/patch/array"
require_relative "karist/patch/hash"
require_relative "karist/patch/string"
require_relative "karist/patch/true_false"
require_relative "karist/patch/integer"

require_relative "karist/generator"
require_relative "karist/renderer"
require_relative "karist/release_file"
require_relative "karist/release"

module Karist
  class GenericError < StandardError; end
  class FunctionsError < GenericError; end
  class SyntaxError < GenericError; end
  class ParserError < GenericError; end
  class NotAHashError < ParserError; end
end