require 'Thing'

module OperationLambda
  module Things
class Laser < Thing
    attr_reader :color, :direction
  
    def initialize(map,x,y,color,direction)
      super(map,x,y)
      @color, @direction = color, direction
    end #def initialize
  
    def key
      name = @map.laser_state[@color] ? "on" : "off"
      "Laser-#{@color}-#{@direction}-#{name}"
    end
  
    def fireLaser
      if @map.laser_state[@color] == true
        self.send(direction).laserGoingDirection_ofColor(@direction,@color)
      end
    end #def fireLaser
    
    def movable?
      false
    end #def movable?
    
    def empty?
      false
    end #def empty?
    
  end #class Laser
end #module Things
end #module OperationLambda