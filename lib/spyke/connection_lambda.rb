# frozen_string_literal: true

# External Libraries
require "version_gem"
require "active_support/core_ext/class/attribute"
require_relative "connection_lambda/version"

# This Library

module Spyke
  # Decorates a Spyke model's class-level +connection+ with a configurable callable.
  # Works with both +include+ and +prepend+, on every supported ActiveSupport.
  module ConnectionLambda
    class << self
      # +include+: class methods sit above the including class, like ActiveSupport::Concern.
      def included(base)
        super
        define_connection_lambda(base)
        base.extend(ClassMethods)
      end

      # +prepend+: class methods sit in front of the class, so they wrap a +connection+
      # defined directly on it (matching ActiveSupport::Concern on ActiveSupport >= 6.1).
      def prepended(base)
        super
        define_connection_lambda(base)
        # Module#prepend (Ruby >= 2.0), not Array#prepend (Ruby >= 2.5).
        base.singleton_class.prepend(ClassMethods) # rubocop:disable Lint/LtsRuby/UnavailableMethod
      end

      private

      def define_connection_lambda(base)
        # Can be set to Proc.new {} or lambda {}
        base.class_attribute(:connection_lambda, instance_accessor: false)
      end
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
