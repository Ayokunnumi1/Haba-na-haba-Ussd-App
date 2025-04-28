# Monkey patch for Windows compatibility with Passenger
require 'phusion_passenger' if defined?(PhusionPassenger)

module PhusionPassenger
  # Override home_dir method to handle Windows systems
  def self.home_dir(respect_home_env = false)
    if respect_home_env && ENV['HOME'] && !ENV['HOME'].empty?
      ENV['HOME']
    elsif RUBY_PLATFORM =~ /mswin|mingw|cygwin/
      # Windows-specific logic
      ENV['USERPROFILE'] || ENV['HOME'] || ENV['HOMEPATH'] || '.'
    else
      # Original logic for Unix systems
      require 'etc' if !defined?(Etc)
      begin
        Etc.getpwuid(Process.uid).dir
      rescue ArgumentError
        ENV['HOME'] || '.'
      end
    end
  end
end