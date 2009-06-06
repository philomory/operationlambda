require 'Menu'
require 'Info/HelpScreen'
require 'Info/AboutGameScreen'
require 'Info/AboutOriginalScreen'

module OperationLambda
  module Menu
    class InfoMenu < BasicMenu
      def initialize(parent)
        super()
        @parent = parent
        @font = ImageManager.font(:menu,30)
        
        @items_array = [
          MenuItem.new("How to Play") {MainWindow.current_screen = Info::HelpScreen.new(self)},
          MenuItem.new("About the Game") {MainWindow.current_screen = Info::AboutGameScreen.new(self)},
          MenuItem.new("About the Original") {MainWindow.current_screen = Info::AboutOriginalScreen.new(self)},
          BackItem.new(self)
        ]
      end
    end
  end
end
        