# frozen_string_literal: true
require "yaml"
require "json"

require_relative "karist/version"
require_relative "karist/array"
require_relative "karist/hash"
require_relative "karist/string"
require_relative "karist/true_false"
require_relative "karist/integer"

module Karist
  class GenericError < StandardError; end
  class FunctionsError < GenericError; end
  class SyntaxError < GenericError; end
  class ParserError < GenericError; end
  class NotAHashError < ParserError; end
end