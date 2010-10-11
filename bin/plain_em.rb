begin
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

require 'eventmachine'
require 'em-http'
require 'ruote'
require 'ruote/storage/hash_storage'
require 'ruote/storage/fs_storage'

engine = Ruote::Engine.new(
  Ruote::Worker.new(
    #Ruote::HashStorage.new
    Ruote::FsStorage.new( 'ruote_work2' )
  )
)

class Debug
  include Ruote::LocalParticipant

  def consume( workitem )
    p [ :em_running?, EM.reactor_running?, EM.reactor_thread? ]
    p [ :ping, :requested ]
    http = EM::HttpRequest.new('http://www.google.com/').get :timeout => 5
    http.callback {
      p [ :ping, :ok ]
      workitem.fields['ping'] = 'ok'
      reply_to_engine( workitem )
    }
    http.errback {
      p [ :ping, :failed ]
      workitem.fields['ping'] = 'failed'
      reply_to_engine( workitem )
    }
  end
end

engine.register_participant :debug, Debug
engine.register_participant :perform_exit do
  EM.stop
end

process = Ruote.process_definition :name => 'Blues' do
  sequence do
    debug
    perform_exit
  end
end

EM.run {
  EM.add_periodic_timer(0.1) { p [ :em_thread, EM.reactor_thread.status ] }
  wfid = engine.launch( process )
}
