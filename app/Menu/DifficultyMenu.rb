require 'Menu'
require 'Game'

module OperationLambda
  module Menu
    class DifficultyMenu < BasicMenu
      def initialize(parent,levelset,level)
        super()
        @parent = parent
        create_new_game = lambda {|difficulty| MainWindow.current_screen = Game.new(levelset,level,difficulty)}
        
        @items_array = [
          MenuItem.new('Relaxed') {create_new_game.call(:relaxed)},
          MenuItem.new('Easy') {create_new_game.call(:easy)},
          MenuItem.new('Normal') {create_new_game.call(:normal)},
          MenuItem.new('Hard') {create_new_game.call(:hard)},
          BackItem.new(self)
        ]
      end
    end
  end
end