require 'Thing'

module OperationLambda
  module Things
    class Empty < Thing

      def laserGoingDirection_ofColor(direction,color)
        final_color = beam_composite(color,@laserbeams[direction])
        @laserbeams[:north] = @laserbeams[:south] = final_color if direction.in? [:north,:south]
        @laserbeams[:east] = @laserbeams[:west] = final_color if direction.in? [:east,:west]
        self.send(direction).laserGoingDirection_ofColor(direction,color)
      end #def laserGoingDirection_withColor

      def movable?
        false
      end #def movable?

      def empty?
        true
      end #def empty?

    end #class Empty
  end #module Things
end #module OperationLambda