require 'Menu/ChooseLevelMenu'
require 'Levelbuilder/Editor'

module OperationLambda
  module Menu
    class EditChooseLevelMenu < ChooseLevelMenu
      
      def initialize(*args)
        super
        @last_level += 1
      end
      
      def set_preview(level)
        if level == 1
          @level_images[level] ||= ImageManager.image('LambdaFire')
        else
          @level_images[level] ||= @levelset.preview_for_level(level-1)
        end
      end
      
      def level_label(level)
        if level == 1
          "New Level"
        else
          super(level-1)
        end
      end
      
      def selected(levelset,level)
        if level == 1
          MainWindow.current_screen = LevelBuilder::Editor.create(self,levelset)
        else
          MainWindow.current_screen = LevelBuilder::Editor.load(self,levelset,level-1)
        end
      end
    
    end
  end
end