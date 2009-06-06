require 'Screen'
require 'Constants'
require 'ImageManager'

module OperationLambda
  class Message < Screen
    
    def initialize(message,destination,should_play=false)
      @message, @destination, @should_play = message, destination, should_play
      @prompt="Press any key to continue."
      @font = ImageManager.font(:basic,20)
      @margin = 40
      body_width = Sizes::WindowWidth - @margin
      @lines = wordwrap(@message,body_width,@font)
    end
    
    def draw
      ImageManager.image('Background').draw(0,0,ZOrder::Stars)
      @lines.each_with_index do |line,index|
        height = @margin + (index * @font.height)
        @font.draw(line,@margin,height,ZOrder::Splash)
      end
      @font.draw(@prompt,@margin,Sizes::WindowHeight-@margin,ZOrder::Splash)
    end
    
    def button_down(id)
      MainWindow.current_screen = @destination;
    end
    
    def should_play_music?
      @should_play
    end
    
  end
end
    