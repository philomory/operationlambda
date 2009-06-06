require 'Thing'

module OperationLambda
  module Things
    class Hostage < Thing

      def initialize(map,x,y,direction)
        super(map,x,y)
        @direction = direction
      end

      def key
        "Hostage-#{@direction}"
      end

      def movable?
        false
      end #def movable?

      def empty?
        false
      end #def empty?

      def collectible?
        true
      end

      def playerEnteredTile(player)
        player.hostages_saved += 1
        @map[@x,@y] = Empty.new(@map,@x,@y)
      end

      def hitWithShot!(shot)  
        shot.game.player_dies
      end

      def crushed
        @map.game.player_dies
      end

      def laserGoingDirection_ofColor(direction,color)
        final_color = beam_composite(color,@laserbeams[direction])
        @laserbeams[:north] = @laserbeams[:south] = final_color if direction.in? [:north,:south]
        @laserbeams[:east] = @laserbeams[:west] = final_color if direction.in? [:east,:west]
        self.send(direction).laserGoingDirection_ofColor(direction,color)
        @map.game.player_dies(final_color)
      end #def laserGoingDirection_withColor

    end #class Hostage
  end #module Things
end #module OperationLambda