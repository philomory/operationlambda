module OperationLambda
  module Info
    class AboutOriginalScreen < Screen
      def initialize(parent)
        @parent = parent
      end
      def draw
        ImageManager.image('AboutOriginal').draw(0,0,0)
      end
      def button_down(id)
        MainWindow.current_screen = @parent
      end
    end
  end
end
