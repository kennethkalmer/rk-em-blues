Thread.abort_on_exception = true

require File.expand_path('../../lib/blues', __FILE__)

EM.run {
  EM.error_handler { |e|
    puts "EM ERR: #{e.message}"
  }
  EM.add_periodic_timer(0.1) { p [ :em_thread, EM.reactor_thread.status ] }

  Blues.configure_engine!

  wfid = RuoteKit.engine.launch( eval IO.read( 'lib/blues/blues_process.rb' ) )

  Blues.configure_worker!
}
