# frozen_string_literal: true

require "test_helper"

module Spyke
  class TestConnectionLambda < Minitest::Test
    def test_connection_lambda_with_proc_get_request_from_class
      endpoint = stub_request(:get,
        "http://proc-sushi.com/api/v1/proc-recipes/recent").to_return_json(result: [{id: 1,
                                                                                     title: "Proc-Bread"}])
      recipes = ProcConnRecipe.all.as_json
      assert_equal(%w[Proc-Bread], recipes.map { |r| r["title"] })
      assert_requested endpoint
    end

    def test_connection_lambda_with_lambda_get_request_from_class
      endpoint = stub_request(:get,
        "http://lambda-sushi.com/api/v1/lambda-recipes/recent").to_return_json(result: [{id: 1,
                                                                                         title: "Lambda-Bread"}])
      recipes = LambdaConnRecipe.all.as_json
      assert_equal(%w[Lambda-Bread], recipes.map { |r| r["title"] })
      assert_requested endpoint
    end

    def test_connection_lambda_with_meth_get_request_from_class
      endpoint = stub_request(:get,
        "http://meth-sushi.com/api/v1/meth-recipes/recent").to_return_json(result: [{id: 1,
                                                                                     title: "Meth-Bread"}])
      recipes = MethConnRecipe.all.as_json
      assert_equal(%w[Meth-Bread], recipes.map { |r| r["title"] })
      assert_requested endpoint
    end

    def test_connection_lambda_with_symbol_get_request_from_class
      endpoint = stub_request(:get,
        "http://symbol-sushi.com/api/v1/symbol-recipes/recent").to_return_json(result: [{id: 1,
                                                                                         title: "Symbol-Bread"}])
      recipes = SymbolConnRecipe.all.as_json
      assert_equal(%w[Symbol-Bread], recipes.map { |r| r["title"] })
      assert_requested endpoint
    end
  end
end
