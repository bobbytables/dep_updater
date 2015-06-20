module DepUpdater
  # Handles the parsing and updating of version strings in a Gemfile.
  #
  # Usage:
  #
  #   Given there's a Gemfile that contains:
  #
  #   gem 'internal-gem', ref: '1234abcbd'
  #
  #   handler = GemfileHandler.new(file_path: './project/Gemfile', gem_name: 'internal-gem')
  #   handler.version
  #   # => 1234abcbd
  #
  class GemfileHandler
    attr_reader :file_path, :gem_name

    class Shim
      def method_missing(name, *args, &block)
        # no-op
      end

      def gem(name, *args)

      end
    end

    def initialize(file_path:, gem_name:)
      @file_path = file_path
      @gem_name = gem_name
    end

    # Retrieves the git version for the gem from the file
    #
    # @return [String]
    def version
      bundler_dsl = Bundler::Dsl.new
      bundler_dsl.eval_gemfile(file_path)

      dep = bundler_dsl.dependencies.find do |gem|
        gem.name == gem_name
      end

      FakeFS.deactivate!
      binding.pry

      dep.options
    end

    private

    def file_contents
      File.read(file_path)
    end
  end
end
