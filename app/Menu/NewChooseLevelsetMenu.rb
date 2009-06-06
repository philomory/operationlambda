require 'Menu/ChooseLevelsetMenu'
require 'Menu/PlayChooseLevelMenu'
require 'Settings'

module OperationLambda
  module Menu
    class NewChooseLevelsetMenu < ChooseLevelsetMenu
      def selected(levelset)
        Settings[:levelset] = levelset.key
        MainWindow.current_screen = DifficultyMenu.new(self,levelset,1)
      end
    end
  end
end