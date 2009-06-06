require 'Screen'
require 'ImageManager'
require 'Constants'

module OperationLambda
  module Info
    class HelpScreen < Screen
      Pages = 2

      def initialize(parent)
        super()
        @parent = parent
        @current_page = 1
      end

      def draw
        ImageManager.image("Help-#{@current_page}").draw(0,0,ZOrder::Splash)
      end

      def button_down(id)
        if @current_page < Pages
          @current_page += 1
        else
          MainWindow.current_screen = @parent
        end
      end

    end
  end
end