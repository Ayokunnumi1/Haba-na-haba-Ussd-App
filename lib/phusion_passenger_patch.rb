# Monkey patch for Windows compatibility with Passenger
require 'phusion_passenger' if defined?(PhusionPassenger)

# Wrapper module that matches the filename
module PhusionPassengerPatch
  # Your monkey patching of the PhusionPassenger module
  module_function
  
  def apply_patch
    # Replace PhusionPassenger's home_dir method
    PhusionPassenger.singleton_class.class_eval do
      define_method(:home_dir) do |respect_home_env = false|
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
  end
end

# Apply the patch if PhusionPassenger is defined
PhusionPassengerPatch.apply_patch if defined?(PhusionPassenger)
