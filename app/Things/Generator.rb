require 'Thing'

module OperationLambda
  module Things
    class Generator < Thing

      def initialize(map,x,y,color)
        super(map,x,y)
        @color = color
        @state = :on
      end

      def key
        "Generator-#{@color}-#{@state}"
      end

      def movable?
        false
      end #def movable?

      def empty?
        false
      end #def empty?

      def hitWithShot!(shot)
        shot.live = false
        @state = :off
        @map.laser_state[@color] = false
      end

      def laserGoingDirection_ofColor(direction,color)
        @state = :off
        @map.laser_state[@color] = false
      end #def laserGoingDirection_withColor

    end #class Generator
  end #module Things
end #module OperationLambda