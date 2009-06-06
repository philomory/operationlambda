require 'Platform'
require 'Settings'
require 'Menu'

module OperationLambda
  module Menu
    module SettingsMenus
      class GraphicsSettingsMenu < BasicMenu
        def initialize(parent)
          super()
          @parent = parent
          @font = ImageManager.font(:basic,30)
          
          # NOTE: Trying out an api for menu creation, as per the To-do list
          add ToggleSettingMenuItem.new("Fullscreen",:fullscreen)
          add ToggleSettingMenuItem.new("Previews",:show_previews)
          
          sets = ImageManager.tilesets
          index = 0
          title = lambda {"Tileset: #{Settings[:tileset][:dir]}"}
          
          add AdvancedMenuItem.new {
            @title = lambda{"Tileset: #{Settings[:tileset][:dir]}"}
            @incr_action = lambda{index += 1; index %= sets.size; Settings[:tileset] = sets[index]}
            @decr_action = lambda{index -= 1; index %= sets.size; Settings[:tileset] = sets[index]}
          }
          
          add  BackItem.new(self)
        end
        
        def back
          super
          ImageManager.load_tileset(Settings[:tileset])
        end
      end
    end
  end
end
