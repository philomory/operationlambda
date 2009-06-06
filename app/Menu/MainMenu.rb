require 'Menu'
require 'Menu/PlayMenu'
require 'Menu/InfoMenu'
require 'Menu/SettingsMenu'
require 'Menu/LevelBuilderMenu'
require 'HighScore/DisplayScreen'

module OperationLambda
  module Menu
    class MainMenu < BasicMenu
      def initialize
        super
        @parent = self
        
        @items_array = [
          MenuItem.new('Play') {MainWindow.current_screen = PlayMenu.new(self)},
          MenuItem.new('Info') {MainWindow.current_screen = InfoMenu.new(self)},
          MenuItem.new('High Scores') {MainWindow.current_screen = HighScore::DisplayScreen.new(self)},
          MenuItem.new('Settings') {MainWindow.current_screen = SettingsMenu.new(self)},
          MenuItem.new('Level Builder') {MainWindow.current_screen = LevelBuilderMenu.new(self)},
          MenuItem.new('Quit') {MainWindow.quit}
        ]
      end #def initialize
      
      def back
        MainWindow.quit
      end
      
    end # class MainMenu
  end # module Menu 
end # module OperationLambda