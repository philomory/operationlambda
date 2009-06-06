require 'Platform'
require 'Settings'
require 'Menu'

module OperationLambda
  module Menu
    module SettingsMenus
      class AudioSettingsMenu < BasicMenu
        def initialize(parent)
          super()
          @parent = parent
          
          @font = ImageManager.font(:menu,30)
          @items_array = [
            ToggleSettingMenuItem.new("Music",:music),
            NumberSettingMenuItem.new(lambda{"\tVolume: #{Settings[:volume]}"},:volume,(0..10)),
            BackItem.new(self)
          ]
        end
      end
    end
  end
end
          
          