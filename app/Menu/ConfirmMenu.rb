require 'Menu'
require 'ImageManager'
require 'Constants'

module OperationLambda
  module Menu
    class ConfirmMenu < BasicMenu
      def initialize(parent,message,&action)
        super()
        @parent, @action = parent, action
        @message_font = ImageManager.font(:basic,30)
        @lines = self.wordwrap(message,Sizes::WindowWidth-80,@message_font)
        @y_offset = @lines.size * @message_font.height
        @items_array = [
          MenuItem.new('Yes') {self.confirm},
          MenuItem.new('No') {self.deny}
        ]
      end
      
      def draw
        super
        @lines.each_with_index do |line,index|
          height = 25 + (index * @font.height)
          @message_font.draw(line,40,height,0)
        end
      end
      
      def confirm
        @action.call
        MainWindow.current_screen = @parent
      end
      
      def deny
        MainWindow.current_screen = @parent
      end
    end
  end
end