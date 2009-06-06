require 'Thing'

module OperationLambda
  module Things
    class Bomb < Thing
    
      def movable?
        false
      end #def movable?
    
      def empty?
        false
      end #def empty?
    
      def collectible?
        true
      end
    
      def hitWithShot!(shot)
        shot.live = false
        @map.game.player_dies
      end
    
      def laserGoingDirection_ofColor(direction,color)
        @map.game.player_dies
      end
    
      def playerEnteredTile(player)
        @map.game.player_dies
      end
    
    end #class Bomb
  end #module Things
end #module OperationLambda