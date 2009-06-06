#!/usr/local/bin/ruby
require 'Platform'
require 'Settings'

require 'gosu'
#unless RUBY_VERSION < "1.9.0"
  require 'texplay'
#end
#require 'singleton'
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
    #include Singleton
    attr_accessor :current_screen
    attr_reader :main_menu

    private_class_method :new
    def self.instance
      unless @__instance__
        new
      end
      @__instance__
    end

    def initialize
      # Work around a weird Singleton recursion 'bug'. See http://www.ruby-forum.com/topic/179676
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
      #self.fade_to(screen)
      #@current_screen = screen
      #@current_screen.select_first if @current_screen.respond_to?(:select_first)
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
      @current_screen.draw
      self.caption = "Operation Lambda: #{@fps.fps} frames per second." 
      # TODO: Do cool caption stuff; give specific titles depending on current screen!
    end
    
    def button_down(id)
      @current_screen.button_down(id)
    end
    
    def button_up(id)
      @current_screen.button_up(id)
    end
    
    def quit
      close
    end
    
    (MainWindow.public_instance_methods - MainWindow.public_methods).each do |meth|
      (class << MainWindow; self; end).class_eval do
        define_method(meth) do |*args|
          MainWindow.instance.send(meth,*args)   
        end
      end   
    end
  end
end



