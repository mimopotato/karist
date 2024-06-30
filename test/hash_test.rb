# frozen_string_literal: true

require "test_helper"

class HashTest < Test::Unit::TestCase
  struct = {
    key_a: {
      key_b: {
        default: "kept",
        _merge: "mutation_merge"
      },
      key_c: {
        _concat: {
          items: ["a", "b", "$mutation_concat.concat_c"],
          sep: " "
        }
      },
      key_d: {
        _sum: [1, 2, 3]
      },
      key_e: {
        _sum: ["$mutation_sum.sum_a", 3]
      }
    }
  }

  mutations = {
    mutation_merge: {
      merge_a: true,
      merge_b: false
    },
    mutation_concat: {
      concat_c: "c"
    },
    mutation_sum: {
      sum_a: "$mutation_sum.sum_b",
      sum_b: "$mutation_sum.sum_c",
      sum_c: 2
    }
  }

  test "hashes gets mutated (_merge function)" do
    results = struct.mutate(mutations)
    assert results[:key_a][:key_b].key?(:default)
    assert_equal results[:key_a][:key_b][:default], "kept"
    assert_false results[:key_a][:key_b].key?(:_merge)
    assert results[:key_a][:key_b].key?(:merge_a)
    assert results[:key_a][:key_b].key?(:merge_b)
    assert_equal results[:key_a][:key_b][:merge_a], true
    assert_equal results[:key_a][:key_b][:merge_b], false
  end

  test "hashes get mutated (_concat function)" do
    results = struct.mutate(mutations)
    assert_equal results[:key_a][:key_c], "a b c"
  end

  test "hashes get mutated (_sum)(integers)" do
    results = struct.mutate(mutations)
    assert_equal results[:key_a][:key_d], 6
  end

  test "hashes get mutated (_sum)($var string call)" do
    results = struct.mutate(mutations)
    assert_equal results[:key_a][:key_e], 5
  end
end