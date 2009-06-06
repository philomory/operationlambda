require 'Platform'
require 'Settings'
require 'Menu'
require 'Menu/SettingsMenus/GraphicsSettingsMenu'
require 'Menu/SettingsMenus/AudioSettingsMenu'
#require 'Menu/SettingsMenus/Gameplay'
require 'Menu/SettingsMenus/GameplayKeyConfigMenu'
#require 'Menu/SettingsMenus/EditorSettingsMenu'
require 'Menu/SettingsMenus/EditorKeyConfigMenu'

module OperationLambda
  module Menu
    class SettingsMenu < BasicMenu
      def initialize(parent)
        super()
        @parent = parent
        
        @font = ImageManager.font(:menu,30)
        @items_array = [
          MenuItem.new("Graphics") {MainWindow.current_screen = SettingsMenus::GraphicsSettingsMenu.new(self)},
          MenuItem.new("Audio") {MainWindow.current_screen = SettingsMenus::AudioSettingsMenu.new(self)},
          MenuItem.new("Gameplay") {MainWindow.current_screen = SettingsMenus::GameplayKeyConfigMenu.new(self)},
          MenuItem.new("Editor") {MainWindow.current_screen = SettingsMenus::EditorKeyConfigMenu.new(self)},
          MenuItem.new("Load Defaults") {Settings.load_defaults},
          BackItem.new(self)
        ]
      end
      
      def back
        Settings.save_settings
        MainWindow.current_screen = @parent
      end
    end
  end
end