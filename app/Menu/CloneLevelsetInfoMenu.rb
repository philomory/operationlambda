require 'Menu'
require 'Menu/EditChooseLevelMenu'

module OperationLambda
  module Menu
    class CloneLevelsetInfoMenu < TextFieldMenu
      def initialize(parent,levelset_being_cloned)
        super()
        @parent = parent
        @levelset_being_cloned = levelset_being_cloned
        
        @font = ImageManager.font(:menu,40)
        @field_font = ImageManager.font(:basic,40)
        old_meta = @levelset_being_cloned.metadata
        old_name = old_meta['levelset']
        old_title = old_meta['title']
        @name_f = TextFieldMenuItem.new("Name: ",@field_font,"NewLevelset")
        @name_f.text="#{old_name} copy"
        
        @title_f = TextFieldMenuItem.new("Title: ",@field_font,"New Levelset")
        @title_f.text="#{old_title} copy"
        
        @author_f = TextFieldMenuItem.new("Author: ",@field_font,"Your Name")

        @items_array = [@name_f,@title_f,@author_f,
          MenuItem.new("Create") do
            l = Levelset.clone_levelset(@levelset_being_cloned,@name_f.text,@title_f.text,@author_f.text)
            if l
              MainWindow.current_screen = EditChooseLevelMenu.new(@parent.parent,l)
            else
              MainWindow.current_screen = MessageDialog.new(self,"Message")
            end
          end,
          MenuItem.new("Cancel") {MainWindow.current_screen = @parent}        
        ]
      end #def initialize
      
    end #class NewLevelsetInfoMenu
  end #module Menu
end #module OperationLambda