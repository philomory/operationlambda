require 'Menu'
require 'ImageManager'

module OperationLambda
  module Menu
    class PauseMenu < BasicMenu
      def should_play_music?
        true
      end
      
      def initialize(parent)
        super()
        @parent = parent
        
        @items_array = [
          BackItem.new(self,"Resume"),
          MenuItem.new("Restart Level") {parent.restart_level; MainWindow.current_screen = parent},
          ToggleSettingMenuItem.new("Music",:music),
          MenuItem.new("End Game") {@parent.game_over}
        ]
      end #def initialize
      
      def back
        @parent.timer.start
        MainWindow.current_screen = @parent
      end
      
    end #class PauseMenu
  end #module Menu
end #module OperationLambda