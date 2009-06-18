require 'Thing'

module OperationLambda
  module Things
    class Switch < Thing

      SwitchAllows = {:vertical => [:east,:west], :horizontal => [:north,:south]}
      
      def initialize(map,x,y,color,dir)
        super(map,x,y)
        @orientation, @color = dir, color
      end #def initialize
      
      def key
        "Switch-#{@color}-#{@orientation}"
      end
      
      def hitWithShot!(shot)
        unless shot.direction.in? SwitchAllows[@orientation]
          shot.live = false
        end
      end
            
      def laserGoingDirection_ofColor(direction,color)
        if SwitchAllows[@orientation].include?(direction)
          # FIXME: Bug, does not react appropriately to two lasers of
          # different colors coming in at once!
          final_color = beam_composite(color,@laserbeams[direction])
          @map.switch_state[@color] -= 1 if @laserbeams[direction] == @color
          @map.switch_state[@color] += 1 if final_color == @color
          SwitchAllows[@orientation].each {|dir| @laserbeams[dir] = final_color}
          self.send(direction).laserGoingDirection_ofColor(direction,color)
        end
      end #def laserGoingDirection_ofColor
      
      
    end #class Switch
  end #module Things
end #module OperationLambda