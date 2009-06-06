require 'gosu'
require 'Noun'
require 'Beam'

module OperationLambda
  module Things
    class Thing < Noun
      include Beam
      #class << self; attr_accessor :image end  
      attr_reader :laserbeams

      def initialize(map,x,y)
        @map,@x,@y = map,x,y
        @laserbeams = {:north => :none, :south => :none, :east => :none, :west => :none}
      end #def initialize
  
      def inspect
        return "<#{self.class}:#{@x},#{@y}>"
      end

      def key
        self.noun
      end
      
      def remove_lasers
        @laserbeams = {:north => :none, :south => :none, :east => :none, :west => :none}
      end

      def laserGoingDirection_ofColor(direction,color)
          #puts self.class.to_s + "needs to impliment laserFromDirection_withColor."
      end #def laserFromDirection_withColor
      
      def playerEnteredTile(player)
          #puts self.class.to_s + "needs to impliment playerEnterFromDirection."
      end #def playerEnterFromDirection
  
      def movable?
        puts self.class.to_s + "needs to impliment movable?"
      end #def movable?
  
      def empty?
        puts self.class.to_s + "needs to impliment empty?"
      end #def empty?
  
      def collectible?
        false
      end
  
      def lasered?
        !(@laserbeams.values - [:none]).empty?
      end
  
      def rotate
      end
  
      def crushed
      end
  
      def hitWithShot!(shot)
        if self.empty? == false
          shot.live = false
        end      
      end
  
      def pushed(direction)
        if self.movable? then
          if self.send(direction).empty?
            oldx, oldy = @x, @y
            @y -= 1 if direction == :north
            @y += 1 if direction == :south
            @x += 1 if direction == :east
            @x -= 1 if direction == :west
            @map[@x,@y] = self
            @map[oldx,oldy] = Empty.new(@map,oldx,oldy)
            return true
          end
        end
        return false
      end #def move
  
      def frame_fraction
        0
      end
  
    end #class Thing
  end #module Things
end #module OperationLambda