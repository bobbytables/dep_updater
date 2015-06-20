require 'spec_helper'
require 'fakefs/safe'

RSpec.describe DepUpdater::GemfileHandler do
  describe '#initialize' do
    it 'initializes with a file path' do
      handler = described_class.new(file_path: './Gemfile', gem_name: 'my-gem')

      expect(handler.file_path).to eq('./Gemfile')
      expect(handler.gem_name).to eq('my-gem')
    end
  end

  describe '#version' do
    context 'for a Gemfile that contains a github ref' do
      let(:ref) { "c3aa0776749aab615f52e55d1261242da0680e78" }
      let(:gemfile) do
        <<-GEMFILE
        gem "internal-gem", git: "git@github.com", ref: "#{ref}"
        GEMFILE
      end
      subject(:handler) { described_class.new(file_path: './Gemfile', gem_name: "internal-gem") }

      around {|e| FakeFS(&e) }

      before do
        File.open("./Gemfile", "w") {|f| f.write gemfile }
      end

      it 'returns the ref in the file for the gem' do
        returned = handler.version

        expect(returned).to eq(ref)
      end
    end
  end
end
