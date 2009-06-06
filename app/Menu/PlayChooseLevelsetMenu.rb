require 'Menu/ChooseLevelsetMenu'
require 'Menu/DifficultyMenu'
require 'Settings'

module OperationLambda
  module Menu
    class PlayChooseLevelsetMenu < ChooseLevelsetMenu
      def selected(levelset)
        Settings[:levelset] = levelset.key
        MainWindow.current_screen = PlayChooseLevelMenu.new(self,levelset)
      end
    end
  end
end