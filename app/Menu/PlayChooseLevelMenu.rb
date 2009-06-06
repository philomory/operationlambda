require 'Menu/ChooseLevelMenu'
require 'Menu/DifficultyMenu'

module OperationLambda
  module Menu
    class PlayChooseLevelMenu < ChooseLevelMenu
      def selected(levelset,level)
        MainWindow.current_screen = DifficultyMenu.new(self,levelset,level)
      end
    end
  end
end