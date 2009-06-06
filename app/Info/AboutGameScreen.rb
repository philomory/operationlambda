module OperationLambda
  module Info
    class AboutGameScreen < Screen
      def initialize(parent)
        @parent = parent
      end
      def draw
        ImageManager.image('AboutGame').draw(0,0,0)
      end
      def button_down(id)
        MainWindow.current_screen = @parent
      end
    end
  end
end
