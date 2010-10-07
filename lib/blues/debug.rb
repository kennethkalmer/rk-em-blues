require 'em-http'

module Blues
  class Debug

    include Ruote::LocalParticipant

    def do_not_thread; true; end

    def consume( workitem )
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
end
