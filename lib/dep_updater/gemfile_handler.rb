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

  # Raised when there are multiple occurences of the same
  # git sha in a file on write
  class ShaConflictError < StandardError; end

  class GemfileHandler
    attr_reader :file_path, :gem_name

    class Shim
      def method_missing(name, *args, &block)
        # no-op
      end

      def gem(name, *args)
        options = args.last.is_a?(Hash) ? args.pop.dup : {}
        version = args || [">= 0"]

        gems << [name, version, options]
      end

      def gems
        @gems ||= []
      end
    end

    def initialize(file_path:, gem_name:)
      @file_path = file_path
      @gem_name = gem_name
    end

    # Retrieves the git version for the gem from the file
    #
    # @return [String]
    def git_sha
      shim = Shim.new
      shim.instance_eval(file_contents)

      result = shim.gems.find do |gem|
        gem[0] == self.gem_name
      end

      result && (result[2][:ref] || result[2]['ref'])
    end

    # Sets the git sha of the gem to the new passed in value
    #
    # @raise ShaConflictError raised when there's more than 1 occurance of the sha in the Gemfile
    def write_git_sha(new_sha)
      check_sha_occurence

      new_contents = file_contents.sub(self.git_sha, new_sha)

      File.open(file_path, 'w') do |f|
        f.write(new_contents)
      end
    end

    private

    def file_contents
      File.read(file_path)
    end

    def check_sha_occurence
      raise ShaConflictError if file_contents.scan(git_sha).length > 1
    end
  end
end
