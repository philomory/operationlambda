require 'Menu/ChooseLevelsetMenu'
require 'Menu/CloneLevelsetInfoMenu'

module OperationLambda
  module Menu
    class CloneChooseLevelsetMenu < ChooseLevelsetMenu
      
      def selected(levelset)
        MainWindow.current_screen = CloneLevelsetInfoMenu.new(self,levelset)
      end
      
    end
  end
end