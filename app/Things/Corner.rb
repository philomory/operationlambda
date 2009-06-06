require 'Thing'
require 'Shot'

module OperationLambda
  module Things
    class CornerNE < Thing

      def initialize(orientation,*args)
        super(*args)
        case orientation
        when :nw
          @open_sides = [:south,:east]
        when :ne
          @open_sides = [:south,:west]
        when :sw
          @open_sides = [:north,:east]
        when :se
          @open_sides = [:north,:west]
        end
      end


      def laserGoingDirection_ofColor(direction,color)
        return if direction.in? @open_sides
        final_color = beam_composite(color,@laserbeams[@open_sides[0]])
        @laserbeams[@open_sides[0]] = @laserbeams[@open_sides[1]] = final_color
        next_dir = (@open_sides - direction.opposite)[0]
        self.send(next_dir).laserGoingDirection_ofColor(next_dir,color)
      end #def laserFromDirection_withColor

      def movable?
        false
      end #def movable?

      def empty?
        false
      end #def empty?

      def hitWithShot!(shot)
        @xcenter = (@x + 0.5) * Sizes::TileWidth
        @ycenter = (@y + 0.5) * Sizes::TileHeight
        #remember, this is about which direction it's moving, not what edge it's crossing.A shot coming in from the
        #west is moving EAST, but one leaving from the north is moving north.
        if shot.direction == :west then
          if shot.x > @xcenter then
            shot.live = false
          end
          return
        elsif shot.direction == :south then
          if shot.y < @ycenter then
            shot.live = false
          end
          return
        end
        return unless Gosu.distance(shot.x,shot.y,@xcenter,@ycenter) <= 4
        newdir = :west if shot.direction == :north
        newdir = :south if shot.direction == :east
        shot.live = false
        shot.game.shot.push(Shot.new(shot.game,@xcenter,@ycenter,newdir))
        return
      end #def hitWithShot!

    end #class CornerNE
  end #module Things
end #module OperationLambda

