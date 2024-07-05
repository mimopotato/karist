# frozen_string_literal: true

require "test_helper"
require "karist"

class IfTest < Test::Unit::TestCase
  include Karist

  test "_in_is_implemented" do
    valid_cond = { key: { _if: [{ _in: ["a", ["a", "b", "c"]]}], subkey: "static"} }
    invalid_cond = { key: { _if: [{ _in: ["x", ["a", "b", "c"]]}], subkey: "static"} }

    valid_results = valid_cond.mutate({})
    assert_equal valid_results[:key][:subkey], "static"
    assert_false valid_results[:key].key?(:_if)

    invalid_result = invalid_cond.mutate({})
    assert_nil invalid_result[:key]
  end

  test "_null is implemented" do
    mutations = {test: "valid"}
    valid_cond = { key: { _if: [{_null: ["$test"]}], valid: true}}

    assert_nil valid_cond.mutate(mutations)[:key]
  end

  test "_present is implemented" do
    mutations = {test: "valid"}
    valid_cond = { key: { _if: [{_present: ["$test"]}], valid: true}}

    assert_equal valid_cond.mutate(mutations)[:key][:valid], true
  end

  test "_eq is implemented" do
    valid_cond = { key: { _if: [{_eq: [true, true]}], subkey: "value"}}
    invalid_cond = { key: { _if: [{_eq: [false, true]}], subkey: "value"}}

    assert_equal valid_cond.mutate({}), {key: {subkey: "value"}}
    assert_equal invalid_cond.mutate({}), {key: nil}
  end

  test "_ne is implemented" do
    invalid_cond = { key: { _if: [{_ne: [true, true]}], subkey: "value"}}
    valid_cond = { key: { _if: [{_ne: [false, true]}], subkey: "value"}}
    
    assert_equal valid_cond.mutate({}), {key: {subkey: "value"}}
    assert_equal invalid_cond.mutate({}), {key: nil}
  end

  test "_gt is implemented" do
    valid_cond = { key: {_if: [{_gt: [2, 1]}], subkey: true}}
    assert_equal valid_cond.mutate({})[:key][:subkey], true


    invalid_cond = { key: {_if: [{_gt: [1, 1]}], subkey: true}}
    assert_equal invalid_cond.mutate({})[:key], nil
  end

  test "_lt is implemented" do
    valid_cond = { key: {_if: [{_lt: [1, 2]}], subkey: true}}
    assert_equal valid_cond.mutate({})[:key][:subkey], true


    invalid_cond = { key: {_if: [{_lt: [2, 1]}], subkey: true}}
    assert_equal invalid_cond.mutate({})[:key], nil
  end

  test "_ge is implemented" do
    valid_cond = { key: {_if: [{_ge: [2, 2]}], subkey: true}}
    assert_equal valid_cond.mutate({})[:key][:subkey], true

    valid_cond = { key: {_if: [{_ge: [3, 2]}], subkey: true}}
    assert_equal valid_cond.mutate({})[:key][:subkey], true

    invalid_cond = { key: {_if: [{_ge: [1, 2]}], subkey: true}}
    assert_equal invalid_cond.mutate({})[:key], nil
  end

  test "_le is implemented" do
    valid_cond = { key: {_if: [{_le: [2, 2]}], subkey: true}}
    assert_equal valid_cond.mutate({})[:key][:subkey], true

    valid_cond = { key: {_if: [{_le: [1, 2]}], subkey: true}}
    assert_equal valid_cond.mutate({})[:key][:subkey], true

    invalid_cond = { key: {_if: [{_le: [3, 2]}], subkey: true}}
    assert_equal invalid_cond.mutate({})[:key], nil
  end

  test "_or is implemented" do
    valid_cond = {
      key: {
        _if: [
          { 
            _or: [
              {_eq: [1, 1]},
              {_eq: [1, 2]}
            ],
          },
          { _eq: ["test", "test"]}
        ],
        valid: true
      }
    }

    assert_equal valid_cond.mutate({}), {key: {valid: true}}
  end

  test "_unless is implemented" do
    valid_cond = {
      key: {
        _unless: [
          {_eq: [1, 2]},
          {_gt: [1, 2]}
        ],
        valid: true
      }
    }

    assert_equal valid_cond.mutate({}), {key: {valid: true}}
  end

  test "_else is implemented" do
    struct = {
      key: {
        _if: [{_eq: [1, 2]}],
        subkey: "value-if",
        _else: {
          subkey: "value-else"
        }
      }
    }

    assert_equal struct.mutate({}), {key: {subkey: "value-else"}}

    struct = {
      key: {
        _unless: [{_eq: [1, 1]}],
        subkey: "value-unless",
        _else: {
          subkey: "value-else"
        }
      }
    }

    assert_equal struct.mutate({}), {key: {subkey: "value-else"}}
  end
end

