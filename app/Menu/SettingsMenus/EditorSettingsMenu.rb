require 'Platform'
require 'Settings'
require 'Menu'

module OperationLambda
  module Menu
    module SettingsMenus
      class EditorSettingsMenu < BasicMenu
        def initialize(parent)
          @parent = parent
          @font = ImageManager.font(:menu,30)
          @items_array = [
            
          ]
        end
      end
    end
  end
end