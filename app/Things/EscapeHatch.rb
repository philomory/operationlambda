require 'Thing'

module OperationLambda
  module Things
class EscapeHatch < Thing
    
    def movable?
      false
    end #def movable?
    
    def empty?
      false
    end #def empty?
  
    def collectible?
      @map.game.player.hostages_saved == @map.hostages
    end
  
    def playerEnteredTile(player)
      @map.game.player_wins
    end
    
  end #class EscapeHatch
end #module Things
end #module OperationLambda