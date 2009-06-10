#!/usr/local/bin/ruby
require 'Platform'
require 'Settings'

require 'gosu'
require 'texplay'
require 'helper'

require 'Constants'
require 'Screen'
require 'ImageManager'
require 'FadeSequence'
require 'Menu/MainMenu' 
require 'MusicBox'
require 'TitleSequence'

require 'Counter/FPSCounter'
require 'HighScore/Manager'

#Fonts - Lambda symbol: Symbol font
#   Main logo: 515pt Symbol
#Fonts - Main Title: Stencil?

module OperationLambda
  class MainWindow < Gosu::Window

    attr_accessor :current_screen
    attr_reader :main_menu


    # I'm implimenting Singleton here myself rather than using the Singleton
    # module in the Ruby Standard Library, because the Ruby Standard Library
    # version doesn't behave quite the way I need it to. For one of the things
    # it does 'wrong', see http://www.ruby-forum.com/topic/179676
    private_class_method :new
    def self.instance
      unless @__instance__
        new
      end
      @__instance__
    end

    def initialize
      # More Singleton stuff.
      self.class.instance_variable_set(:@__instance__,self)
       
      super(Sizes::WindowWidth, Sizes::WindowHeight,Settings[:fullscreen])
      self.caption = "Operation Lambda"
      ImageManager.load_images
      ImageManager.load_tileset(Settings[:tileset])
      @current_screen = TitleSequence.new
      @main_menu = Menu::MainMenu.new
      @music = MusicBox.instance
      @fps = Counter::FPSCounter.new
      @fading = false
      HighScore::Manager.init_high_scores
    end #def initialize
    
    def current_screen=(screen)
      @current_screen = FadeSequence.new(@current_screen,screen)
    end
    
    def immediate_set_screen(screen)
      @current_screen = screen
    end
    
    def update
      @fps.register_tick
      @music.update
      self.text_input = @current_screen.text_input
      @current_screen.update
    end
    
    def draw
      # Because draw is utterly without side-effects (in terms of game state;
      # obviously it has the 'side effect' of placing an image on the screen),
      # there should be no risk in silently catching and discarding exceptions
      # during the call to draw. Of course, it's better during development to
      # have them around so that they point out bugs, but for the user it's
      # better to have a single munged frame than to have the whole app crash
      # just because I passed bad arguments to some draw function.
      #
      # In the future, though, I hope to throw some intelligent crash-logging
      # into the picture.
      @current_screen.draw rescue nil
      self.caption = "Operation Lambda: #{@fps.fps} frames per second." 
      # TODO: Do cool caption stuff; give specific titles depending on current screen!
    end
    
    def button_down(id)
      @current_screen.button_down(id)
    end
    
    def button_up(id)
      @current_screen.button_up(id)
    end
    
    # This method seems a little stupid. Why aren't I just calling 'close'
    # directly? Frankly, I can't remember, and if I can't figure it out soon,
    # I'm going to ditch it.
    def quit
      close
    end
    
    # MainWindow is a singleton. This allows me to call methods on MainWindow
    # that I really want to sent to MainWindow.instance, cutting out a lot of
    # useless verbosity. And it avoids ill-performing method_missing hacks.
    (MainWindow.public_instance_methods - MainWindow.public_methods).each do |meth|
      (class << MainWindow; self; end).class_eval do
        define_method(meth) do |*args|
          MainWindow.instance.send(meth,*args)   
        end
      end   
    end
  end
end



