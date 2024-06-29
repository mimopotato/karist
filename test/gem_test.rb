# frozen_string_literal: true

require "test_helper"

class KaristTest < Test::Unit::TestCase
  test "Gem version is set" do
    assert do
      ::Karist.const_defined?(:VERSION)
    end
  end
end