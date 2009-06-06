require 'Menu'
require 'Menu/EditChooseLevelMenu'

module OperationLambda
  module Menu
    class NewLevelsetInfoMenu < TextFieldMenu
      def initialize(parent)
        super()
        @parent = parent
        
        @font = ImageManager.font(:menu,40)
        @field_font = ImageManager.font(:basic,40)

        @name_f = TextFieldMenuItem.new("Name: ",@field_font,"NewLevelset")
        @title_f = TextFieldMenuItem.new("Title: ",@field_font,"New Levelset")
        @author_f = TextFieldMenuItem.new("Author: ",@field_font,"Your Name")

        @items_array = [@name_f,@title_f,@author_f,
          MenuItem.new("Create") do
            l = Levelset.create_levelset(@name_f.text,@title_f.text,@author_f.text)
            if l
              MainWindow.current_screen = EditChooseLevelMenu.new(@parent,l)
            else
              MainWindow.current_screen = MessageDialog.new(self,"Message")
            end
          end,
          BackItem.new(self,"Cancel")       
        ]
      end #def initialize
      
    end #class NewLevelsetInfoMenu
  end #module Menu
end #module OperationLambda