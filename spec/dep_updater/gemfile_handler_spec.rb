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

  describe 'Writing a new version' do
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

    describe '#git_sha' do
      context 'for a Gemfile that contains a git ref' do
        it 'returns the ref in the file for the gem' do
          returned = handler.git_sha

          expect(returned).to eq(ref)
        end

        context 'when the ref is keyed using a string' do
          let(:gemfile) do
            <<-GEMFILE
            gem "internal-gem", "git" => "git@github.com", "ref" => "#{ref}"
            GEMFILE
          end

          it 'returns the ref correctly' do
            returned = handler.git_sha

            expect(returned).to eq(ref)
          end
        end
      end
    end

    describe '#write_git_sha' do
      it 'replaces the current git sha with the new sha' do
        handler.write_git_sha("chickenbutt")
        expect(handler.git_sha).to eq('chickenbutt')
      end

      context 'when there is more than 1 occurence of the sha in the file' do
        let(:gemfile) { "#{super()}\n#{super()}"}

        it 'raises an ShaConflictError' do
          expect { handler.write_git_sha('whatever') }.to raise_error(DepUpdater::ShaConflictError)
        end
      end
    end
  end
end
