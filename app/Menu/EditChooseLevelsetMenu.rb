require 'Menu/ChooseLevelsetMenu'
require 'Menu/EditChooseLevelMenu'
require 'Constants'

module OperationLambda
  module Menu
    class EditChooseLevelsetMenu < ChooseLevelsetMenu
      
      def initialize(*args)
        super
        @category = :user
      end
      
      def button_down(id)
        super
        @category = :user
      end
    
      def draw_categories
        x = Sizes::WindowWidth / 2
        y = PreviewTopMargin / 2
        @category_font.draw_rel("Choose a levelset",x,y,ZOrder::Things,0.5,0)
      end
    
      def selected(levelset)
        MainWindow.current_screen = EditChooseLevelMenu.new(self,levelset)
      end
    
    end
  end
end