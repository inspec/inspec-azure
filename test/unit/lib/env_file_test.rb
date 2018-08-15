require 'tempfile'

require_relative '../test_helper'
require_relative '../../../lib/environment_file'

# rubocop:disable Metrics/BlockLength
describe EnvironmentFile do
  before do
    @tmp_file = Tempfile.new('env')
    @content  = <<~CONTENT
      unrelated content

      export GRAPH=true

      unrelated content

      export NETWORK_WATCHER=true

      unrelated content
    CONTENT
    @tmp_file.write @content
    @tmp_file.close
    @env_file = EnvironmentFile.new(@tmp_file.path)
  end

  after do
    @tmp_file.unlink
  end

  describe 'no env file' do
    it 'returns no options' do
      assert_equal([], EnvironmentFile.options('fake/path'))
    end
  end

  describe 'env file' do
    it 'returns no options' do
      assert_equal(%w{graph network_watcher}, EnvironmentFile.options(@tmp_file.path))
    end
  end

  describe 'current configuration' do
    it 'gives the current options in file' do
      @env_file.current_options.must_equal %w{graph network_watcher}
    end

    it 'gives empty list if not options in file' do
      @env_file.synchronize([])

      @env_file.current_options.must_equal []
    end
  end

  describe 'synchronizing environment' do
    it 'adds given keys and removes missing keys' do
      @env_file.synchronize(['network_watcher'])

      @tmp_file.open
      @tmp_file.read.must_equal <<~CONTENT
        unrelated content


        unrelated content

        export NETWORK_WATCHER=true

        unrelated content
      CONTENT
    end

    it 'raises an error when unkown keys are given' do
      assert_raises RuntimeError do
        @env_file.synchronize(%w{network_watcher graph unknown})
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
