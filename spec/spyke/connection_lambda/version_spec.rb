# frozen_string_literal: true

require "anonymous_loader"
require "spyke/connection_lambda"
RSpec.describe Spyke::ConnectionLambda::Version do
  it_behaves_like "a Version module", described_class

  it "returns the inherited connection when no lambda is configured" do
    target = Class.new do
      def self.connection
        :base
      end

      prepend Spyke::ConnectionLambda
    end

    expect(target.connection).to eq(:base)
  end

  it "passes the inherited connection to a callable lambda" do
    target = Class.new do
      def self.connection
        :base
      end

      prepend Spyke::ConnectionLambda
    end
    target.connection_lambda = ->(connection) { [:lambda, connection] }

    expect(target.connection).to eq([:lambda, :base])
  end

  it "passes the inherited connection to a named callback" do
    target = Class.new do
      def self.connection
        :base
      end

      def self.decorate(connection)
        [:method, connection]
      end

      prepend Spyke::ConnectionLambda
    end
    target.connection_lambda = :decorate

    expect(target.connection).to eq([:method, :base])
  end

  it "executes the version file for coverage without redefining constants" do
    paths = [
      File.expand_path("../../../lib/spyke/connection_lambda/version.rb", __dir__),
      File.expand_path("../../../lib/spyke/connection_lambda/version_gem.rb", __dir__)
    ].select { |path| File.file?(path) }
    anonymous_namespace = AnonymousLoader.load(files: paths)

    expect(anonymous_namespace::Spyke::ConnectionLambda::Version::VERSION).to eq(described_class::VERSION)
  end
end
