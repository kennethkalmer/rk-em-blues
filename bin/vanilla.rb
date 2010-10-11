require File.expand_path('../../lib/blues', __FILE__)

EM.run {
  Blues.configure_engine!

  wfid = RuoteKit.engine.launch( IO.read( 'lib/blues/blues_process.rb' ) )

  Blues.configure_worker!
}
