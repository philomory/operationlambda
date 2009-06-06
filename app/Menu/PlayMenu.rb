require 'Menu'
require 'Menu/PlayChooseLevelsetMenu'
require 'Menu/NewChooseLevelsetMenu'
require 'Menu/DifficultyMenu'

module OperationLambda
  module Menu
    class PlayMenu < BasicMenu
      def initialize(parent)
        super()
        @parent = parent
        
        @items_array = [
          MenuItem.new('Quick Resume') {
            levelset = Levelset.new(Settings[:levelset])
            level = Settings[:level]
            MainWindow.current_screen = DifficultyMenu.new(self,levelset,level)
          },
          MenuItem.new('New Game') {MainWindow.current_screen = NewChooseLevelsetMenu.new(self)},
          MenuItem.new('Select Level') {MainWindow.current_screen = PlayChooseLevelsetMenu.new(self)},
          BackItem.new(self)
        ]
      end
    end
  end
end