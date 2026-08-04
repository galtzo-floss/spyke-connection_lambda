# frozen_string_literal: true

# External Libraries
require "version_gem"
require "active_support/concern"
require "active_support/core_ext/class/attribute"
require_relative "connection_lambda/version"

# This Library

module Spyke
  module ConnectionLambda
    extend ActiveSupport::Concern

    prepended do
      # Can be set to Proc.new {} or lambda {}
      class_attribute :connection_lambda, instance_accessor: false
    end

    module ClassMethods
      def connection
        return super unless connection_lambda?

        # lambda, Proc, and method are handled here
        return connection_lambda.call(super) unless connection_lambda.is_a?(Symbol)

        # symbol is turned into a method and called here.
        method(connection_lambda).call(super)
      end
    end
  end
end

Spyke::ConnectionLambda::Version.class_eval do
  extend VersionGem::Basic
end
