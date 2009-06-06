require 'Thing'
require 'Constants'

module OperationLambda
  module Things
class CrackedBrick < Thing
    
    def movable?
      false
    end #def movable?
    
    def empty?
      false
    end #def empty?
  
    def hitWithShot!(shot)
      unless @crumbling
        shot.live = false
        @shottime = Time.now
        @crumbling = true
        @map.crumbling.push(self)
      end
    end #def hitWithShot!
    
    def key
      if @crumbling
        "CrumblingBrick"
      else
        "CrackedBrick"
      end
    end
    
    def frame_fraction
      if @crumbling
        (Time.now - @shottime) / Timing::Cycle
      else
        0
      end
    end
    
    def update
      if @crumbling and Time.now - @shottime >= Timing::Cycle
        @map[@x,@y] = Empty.new(@map,@x,@y)
      end
    end
    
  end #class CrackedBrick
end #module Things
end #module OperationLambda