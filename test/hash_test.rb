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
      },
      key_f: {
        _loop: {
          _items: "mutation_f.items",
          _block: {
            name: "$value",
            svcs: [
              { "port": "$port" }
            ]
          }
        }
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
    },
    mutation_f: {
      items: [
        { port: 80, value: "test_f_b" },
        { value: "test_f", port: 443 },
      ]
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

  test "hashes get mutated (_loop)" do
    results = struct.mutate(mutations)
    assert_equal results[:key_a][:key_f][0][:name], "test_f_b"
    assert_equal results[:key_a][:key_f][1][:name], "test_f"
    assert_equal results[:key_a][:key_f][0][:svcs][0][:port], 80
    assert_equal results[:key_a][:key_f][1][:svcs][0][:port], 80
  end

  test "hashes get mutated (_loop in _loop)" do
    local_struct = {
      key_a: {
        _loop: {
          _items: "items",
          _block: {
            value: "$value",
            sub_loop: {
              _loop: {
                _items: "items",
                _block: {
                  sub_value: "$sub_value" } } } } } } }

    local_mutations = {
      items: [
        { value: "v-1", sub_value: "sv-1" },
        { value: "v-2", sub_value: "sv-2" }
      ]
    }

    results = local_struct.mutate(local_mutations)
    assert_equal results[:key_a][0][:value], "v-1"
    assert_equal results[:key_a][0][:sub_loop][0][:sub_value], "sv-1"
    assert_equal results[:key_a][0][:sub_loop][1][:sub_value], "sv-2"
    assert_equal results[:key_a][1][:value], "v-2"
    assert_equal results[:key_a][1][:sub_loop][0][:sub_value], "sv-1"
    assert_equal results[:key_a][1][:sub_loop][1][:sub_value], "sv-2"
  end
end