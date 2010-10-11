require 'rake'

require './lib/blues'

task :worker do
  EM.run {
    EM.error_handler{ |e|
      puts "Error raised during event loop: #{e.message}"
    }
    EM.add_periodic_timer(0.1) { p [ :em_thread, EM.reactor_thread.status ] }

    Blues.configure_worker!
  }
end

task :em_test do
  require 'em-http'
  EM.run {
    EM.add_periodic_timer( 2 ) {
      http = EM::HttpRequest.new('http://www.google.com/').get :timeout => 5
      http.callback {
        $stderr.write("+")
      }
      http.errback {
        $stderr.write("-")
      }
    }
  }
end
