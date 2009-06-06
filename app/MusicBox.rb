require 'gosu'
require 'singleton'
require 'Platform'
require 'Settings'

module OperationLambda
  class MusicBox
    include Singleton
    
    MusicDir = File.join(Platform::ApplicationMediaDir,"music")
    
    attr_reader :songs
    def initialize
      @songs = (Dir.entries(MusicDir) - ['.','..']).map do |file|
         begin
           Gosu::Song.new(MainWindow.instance,File.join(MusicDir,file))
         rescue
           puts "#{file} is not a music file."
           nil
         end
       end.compact
      @current = @songs[rand(@songs.size)]
    end

    def next!
      @current = (@songs - [@current])[rand(@songs.size-1)]
    end

    def play
      @current.play
    end

    def stop
      @current.stop
    end

    def playing?
      @current.playing?
    end

    def update
      if MainWindow.current_screen.should_play_music? and Settings[:music]
        unless self.playing?
          self.next!
          self.play
        end
      else
        self.stop
      end
    end
  end
end
