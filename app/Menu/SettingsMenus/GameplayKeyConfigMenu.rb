require 'Menu/SettingsMenus/KeyConfigMenu'

module OperationLambda
  module Menu
    module SettingsMenus
      class GameplayKeyConfigMenu < KeyConfigMenu

        def context
          :gameplay
        end

        def keys
          [[:north,"Go North"], [:south,"Go South"], [:east, "Go East"],
          [:west, "Go West"], [:shoot, "Fire Gun"], [:rotate, "Rotate Mirror"]]
        end
      end 
    end
  end
end