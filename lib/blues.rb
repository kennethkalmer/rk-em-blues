begin
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

Thread.abort_on_exception = true

$:.unshift File.dirname(__FILE__)

require 'eventmachine'
require 'ruote-kit'
require 'ruote/storage/fs_storage'
require 'redis'
require 'ruote-redis'
require 'ruby-debug'

module Blues
  autoload :Application, 'blues/application'
  autoload :Debug, 'blues/debug'

  class << self

    def configure_engine!
      # Engine and worker
      if defined?( Thin )
        p [ 'Thin detected, no need to run a worker']
        RuoteKit.engine = Ruote::Engine.new(
          Ruote::Worker.new(
            #Ruote::FsStorage.new('ruote_work')
            Ruote::Redis::RedisStorage.new(
              ::Redis.new( :db => 1, :thread_safe => true)
            )
          )
        )
      else
        p [ 'Thin absent, please run a worker with "rake worker"' ]
        RuoteKit.engine = Ruote::Engine.new(
          #Ruote::FsStorage.new('ruote_work')
          Ruote::Redis::RedisStorage.new(
            ::Redis.new( :db => 1, :thread_safe => true)
          )
        )
      end

      RuoteKit.engine.register do
        participant :debug, Blues::Debug

        catchall
      end
    end

    def configure_worker!
      #RuoteKit.run_worker( Ruote::FsStorage.new('ruote_work') )
      RuoteKit.run_worker(
        Ruote::Redis::RedisStorage.new(
          ::Redis.new( :db => 1, :thread_safe => true)
        )
      )
    end
  end
end
