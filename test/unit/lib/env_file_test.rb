require 'tempfile'

require_relative '../test_helper'
require_relative '../../../lib/environment_file'

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

    it 'warns and ignores unknown keys' do
      @env_file.synchronize(['network_watcher', 'graph', 'unknown'])

      @tmp_file.open
      @tmp_file.read.must_equal @content
    end
  end

  it 'leaves existing properties' do
    @env_file.set_var('NETWORK_WATCHER', 'true')

    @tmp_file.open
    @tmp_file.read.must_equal @content
  end

  it 'removes a property' do
    @env_file.remove_var('NETWORK_WATCHER')

    @tmp_file.open
    @tmp_file.read.must_equal <<~CONTENT
      unrelated content

      export GRAPH=true

      unrelated content


      unrelated content
    CONTENT
  end

  it 'replaces property if the value is changes' do
    @env_file.set_var('NETWORK_WATCHER', 'one')

    @tmp_file.open
    @tmp_file.read.must_equal <<~CONTENT
      unrelated content

      export GRAPH=true

      unrelated content

      export NETWORK_WATCHER=one

      unrelated content
    CONTENT
  end
end
