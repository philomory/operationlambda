require 'Menu/SettingsMenus/KeyConfigMenu'

module OperationLambda
  module Menu
    module SettingsMenus
      class EditorKeyConfigMenu < KeyConfigMenu

        def context
          :editor
        end

        def keys
          [[:north,"Go North"], [:south,"Go South"], [:east, "Go East"],
          [:west, "Go West"], [:place, "Place Tile"], [:rotate, "Rotate Tile"],
          [:color,"Cycle Color"],[:toggle_auto,"Toggle Auto-draw"],[:erase,"Erase Tile"]]
        end
      end
    end
  end
end