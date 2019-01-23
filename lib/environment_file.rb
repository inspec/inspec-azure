class EnvironmentFile
  OPTIONS = %w{
    graph
    network_watcher
    msi
    sql
  }.freeze

  def self.options(path)
    return [] unless File.readable?(path)

    EnvironmentFile.new(path).current_options
  end

  def initialize(path)
    @file = File.new(path)
  end

  def current_options
    OPTIONS.select { |option| key?(option.upcase) }
  end

  def synchronize(envs)
    raise "The following options are unknown: #{unknown(envs)}. Please use only: #{OPTIONS.join(',')}." unless unknown(envs).empty?

    add_vars(envs)
    remove_vars(OPTIONS - envs)
  end

  private

  def unknown(vars)
    vars - OPTIONS
  end

  def add_vars(vars)
    vars.each { |key| set_var(key.upcase) }
  end

  def remove_vars(vars)
    vars.each { |key| remove_var(key.upcase) }
  end

  def match_export_statement(key, text)
    /export #{key}=.*$/.match(text)
  end

  def export_statement(key, value)
    "export #{key}=#{value}\n"
  end

  def set_var(key, value = 'true')
    found, new_content = replace_key(key, value) do |k, v|
      export_statement(k, v)
    end

    new_content << export_statement(key, value) unless found

    File.write(@file.path, new_content)
  end

  def remove_var(key)
    _, new_content = replace_key(key) do |_key, _value|
      ''
    end

    File.write(@file.path, new_content)
  end

  def key?(key)
    File.open(@file.path, 'r').each_line do |line|
      if match_export_statement(key, line)
        return true
      end
    end

    false
  end

  # rubocop:disable Performance/RedundantBlockCall
  def replace_key(key, value = nil, &formatter)
    new_content = ''
    found       = false

    File.open(@file.path, 'r').each_line do |line|
      if match_export_statement(key, line)
        new_content << formatter.call(key, value)
        found = true
      else
        new_content << line
      end
    end

    [found, new_content]
  end
  # rubocop:enable Performance/RedundantBlockCall
end
