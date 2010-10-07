begin
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

$:.unshift File.dirname(__FILE__)

require 'eventmachine'
require 'ruote-kit'
require 'ruote/storage/fs_storage'

module Blues
  autoload :Application, 'blues/application'
  autoload :Debug, 'blues/debug'

  class << self

    def configure_engine!
      # Engine and worker
      RuoteKit.engine = Ruote::Engine.new(
        Ruote::FsStorage.new('ruote_work')
      )

      RuoteKit.engine.register do
        participant :debug, Blues::Debug

        catchall
      end
    end

    def configure_worker!
      RuoteKit.run_worker( Ruote::FsStorage.new('ruote_work') )
    end
  end
end
