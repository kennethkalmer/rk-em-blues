require 'rake'

require './lib/blues'

task :worker do
  EM.run {
    EM.error_handler{ |e|
      puts "Error raised during event loop: #{e.message}"
    }

    Blues.configure_worker!
  }
end
