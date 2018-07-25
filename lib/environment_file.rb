class EnvironmentFile

  OPTIONS = %w{
    graph
    network_watcher
  }

  def initialize(path)
    @file = File.new(path)
  end

  def synchronize(envs)
    to_delete = OPTIONS - envs
    unknown = envs - OPTIONS

    puts "The following options are not known #{unknown}. Please chose one of #{OPTIONS}." unless unknown.empty?

    (envs - unknown).each{ |key| set_var(key.upcase, 'true') }
    to_delete.each{ |key| remove_var(key.upcase) }
  end

  def set_var(key, value)
    found, new_content = replace_key(key, value) do |key, value|
      "export #{key}=#{value}\n"
    end

    new_content << "export #{key}=#{value}\n" unless found

    File.write(@file.path, new_content)
  end

  def remove_var(key)
    _, new_content = replace_key(key, nil) do |_key, _value|
      ""
    end

    File.write(@file.path, new_content)
  end

  def replace_key(key, value)
    new_content = ''
    found = false

    File.open(@file.path, 'r').each_line do |line|
      if line =~ /export #{key}=.*$/
        new_content << yield(key, value)
        found = true
      else
        new_content << line
      end
    end

    return found, new_content
  end
end
