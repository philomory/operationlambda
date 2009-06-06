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
          SwitchAllows[@orientation].each {|dir| @laserbeams[dir] = color}
          @map.switch_state[@color] = (color == @color)
          self.send(direction).laserGoingDirection_ofColor(direction,color)
        end
      end #def laserGoingDirection_ofColor
      
      
    end #class Switch
  end #module Things
end #module OperationLambda