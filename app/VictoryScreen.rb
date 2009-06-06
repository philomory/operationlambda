require 'Screen'
require 'Constants'

# TODO: Make this suck less.
module OperationLambda
  class VictoryScreen < Screen
    def initialize
      @font = ImageManager.font(:basic,20)
      @message = "Congratulations! You finished the last level. Sadly, there's not a lot here right now. Move along."
      @prompt = "Press any key to continue."
      @margin = 40
      body_width = Sizes::WindowWidth - @margin
      @lines = wordwrap(@message,body_width,@font)
    end
    
    def draw
      @lines.each_with_index do |line,index|
        height = @margin + (index * @font.height)
        @font.draw(line,@margin,height,ZOrder::Splash)
      end
      @font.draw(@prompt,@margin,Sizes::WindowHeight-@margin,ZOrder::Splash)
    end
    
    def button_down(id)
      MainWindow.current_screen = MainWindow.main_menu;
    end
  end
end