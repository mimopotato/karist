# frozen_string_literal: true

require "test_helper"

class StringTest < Test::Unit::TestCase
  struct = {
    key_a: "_ -> mutation_a",
    key_b: "_from mutation_b",
    sub_c: {
      key_a: "_ -> mutation_a",
      key_b: "_from mutation_c"
    }
  }

  mutations = {
    mutation_a: "result_a",
    mutation_b: "result_b",
    mutation_c: "_ -> mutation_d",
    mutation_d: "result_d"
  }

  test "strings get mutated (short)" do
    results = struct.mutate(mutations)
    assert_equal results[:key_a], "result_a"
    assert_equal results[:sub_c][:key_a], "result_a"
  end

  test "strings get mutated (long)" do
    results = struct.mutate(mutations)
    assert_equal results[:key_b], "result_b"
  end

  test "strings get mutated recursively (short)" do
    results = struct.mutate(mutations)
    assert_equal results[:sub_c][:key_b], "result_d"    
  end
end