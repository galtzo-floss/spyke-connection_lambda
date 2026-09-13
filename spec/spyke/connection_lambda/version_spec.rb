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

  context "when included, as documented in the README" do
    let(:target) do
      parent = Class.new do
        def self.connection
          :base
        end
      end

      Class.new(parent) do
        include Spyke::ConnectionLambda

        def self.decorate(connection)
          [:method, connection]
        end
      end
    end

    it "returns the inherited connection when no lambda is configured" do
      expect(target.connection).to eq(:base)
    end

    it "passes the inherited connection to a callable lambda" do
      target.connection_lambda = ->(connection) { [:lambda, connection] }

      expect(target.connection).to eq([:lambda, :base])
    end

    it "passes the inherited connection to a named callback" do
      target.connection_lambda = :decorate

      expect(target.connection).to eq([:method, :base])
    end

    it "does not define an instance reader" do
      expect(target.new).not_to respond_to(:connection_lambda)
    end
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
