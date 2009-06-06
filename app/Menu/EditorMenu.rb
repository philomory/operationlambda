require 'Menu'
require 'Message'

module OperationLambda
  module Menu
    class EditorMenu < BasicMenu
      def initialize(parent)
        super()
        @parent, @editor = parent, parent
        
        @items_array    = [
          MenuItem.new('Resume') {MainWindow.current_screen = @parent},
          MenuItem.new('Save Level') {
            begin
              @editor.save
            rescue
              MainWindow.current_screen = Message.new("An error occurred while saving the level: #{$!}",self)
            else
              MainWindow.current_screen = Message.new("The level has been saved.",self)
              initialize(@parent)
            end
          }
        ]
        if @editor.has_file?
          @items_array += [
            MenuItem.new('Save a copy') {
              begin
                new_level_number = @editor.save_copy
              rescue
                MainWindow.current_screen = Message.new("An error occurred while saving the copy: #{$!}",self)
              else
                MainWindow.current_screen = Message.new("A copy has been saved as level #{new_level_number}. You are still working on level #{@editor.level}, not the copy.",self)
              end
            },
            MenuItem.new('Revert to Saved') {
              @editor.revert
            }
          ]
        end
        @items_array += [
          MenuItem.new('Save and Quit') {
            begin
              @editor.save
            rescue
              MainWindow.current_screen = Message.new("An error occurred while saving the level: #{$!}",self)
            else
              MainWindow.current_screen = Message.new("The level has been saved. Leaving the editor.",@parent.parent)
            end
          },
          MenuItem.new('Quit') {MainWindow.current_screen = @parent.parent}
        ]
      
      end
          
    end
  end
end