require 'Thing'
require 'Constants'

module OperationLambda
  module Things
class Mirror < Thing
  
    attr_reader :angle
  
    def initialize(map,x,y,angle)
      super(map,x,y)
      @angle = angle
    end
  
    def key
      name = (@angle == 1) ? "normal" : "flipped"
      "Mirror-#{name}"
    end
  
    def rotate
      @angle = -(@angle)
    end #def rotate
  
    def laserGoingDirection_ofColor(direction,color)
      if @angle == 1
        dirs = [:west,:north] if direction == :east
        dirs = [:north,:west] if direction == :south
        dirs = [:east,:south] if direction == :west
        dirs = [:south,:east] if direction == :north
      else
        dirs = [:east,:north] if direction == :west
        dirs = [:north,:east] if direction == :south
        dirs = [:west,:south] if direction == :east
        dirs = [:south,:west] if direction == :north
      end
      final_color = beam_composite(color,@laserbeams[dirs[0]])
      @laserbeams[dirs[0]] = @laserbeams[dirs[1]] = final_color
      self.send(dirs[1]).laserGoingDirection_ofColor(dirs[1],color)
    end #def laserFromDirection_withColor
    
    def movable?
      true
    end #def movable?
    
    def empty?
      false
    end #def empty?
  
    def hitWithShot!(shot)
      @xcenter = (@x + 0.5) * Sizes::TileWidth
      @ycenter = (@y + 0.5) * Sizes::TileHeight
      return :first unless Gosu.distance(shot.x,shot.y,@xcenter,@ycenter) <= 4
      #remember, this is about which direction it's moving, not what edge it's crossing.A shot coming in from the
      #west is moving EAST, but one leaving from the north is moving north.
      newdir = nil
      if @angle == 1
        newdir = :north if shot.direction == :east and shot.x >= @xcenter
        newdir = :west if shot.direction == :south and shot.y <= @ycenter
        newdir = :south if shot.direction == :west and shot.x <= @xcenter
        newdir = :east if shot.direction == :north and shot.y >= @ycenter
      else
        newdir = :north if shot.direction == :west and shot.x <= @xcenter
        newdir = :west if shot.direction == :north and shot.y >= @ycenter
        newdir = :south if shot.direction == :east and shot.x >= @xcenter
        newdir = :east if shot.direction == :south and shot.y <= @ycenter
      end
      return :second if newdir.nil?
      shot.live = false
      shot.game.shot.push(Shot.new(shot.game,@xcenter,@ycenter,newdir))
      return :third
    end
    
  end #class Mirror
end #module Things
end #module OperationLambda