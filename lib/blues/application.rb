module Blues
  class Application < Sinatra::Base

    configure do
      Blues.configure_engine!
    end

    get "/" do
      haml :index
    end

    post "/launch" do
      RuoteKit.engine.launch( IO.read( File.dirname(__FILE__) + '/blues_process.rb' ) )
    end

  end
end
