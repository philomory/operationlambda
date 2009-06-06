require 'Menu'
require 'Menu/NewLevelsetInfoMenu'
require 'Menu/EditChooseLevelsetMenu'
require 'Menu/CloneChooseLevelsetMenu'

module OperationLambda
  module Menu
    class LevelBuilderMenu < BasicMenu
      def initialize(parent)
        super()
        @parent = parent
        
        #@font = ImageManager.font(File.join(Platform::ApplicationMediaDir,:menu),20)
        @items_array = [
          MenuItem.new("New Levelset") {MainWindow.current_screen = NewLevelsetInfoMenu.new(self)},
          MenuItem.new("Edit Levelset") {MainWindow.current_screen = EditChooseLevelsetMenu.new(self)},
          MenuItem.new("Clone Levelset") {MainWindow.current_screen = CloneChooseLevelsetMenu.new(self)},
          #MenuItem.new("Delete Levelset") {MainWindow.current_screen = LevelBuilder::DeleteExistingLevelsetScreen.new(self)},
          BackItem.new(self)
        ]
      end
    end
  end
end