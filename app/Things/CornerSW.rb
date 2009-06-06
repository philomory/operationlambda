require 'Thing'
require 'Shot'

module OperationLambda
  module Things
class CornerSW < Thing
  
    def laserGoingDirection_ofColor(direction,color)
      return if direction.in? [:north,:east]
      dirs = [:east,:north] if direction == :west
      dirs = [:north,:east] if direction == :south
      final_color = beam_composite(color,@laserbeams[dirs[0]])
      @laserbeams[dirs[0]] = @laserbeams[dirs[1]] = final_color
      self.send(dirs[1]).laserGoingDirection_ofColor(dirs[1],color)
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
      if shot.direction == :east then
        if shot.x < @xcenter then
          shot.live = false
        end
        return
      elsif shot.direction == :north then
        if shot.y > @ycenter then
          shot.live = false
        end
        return
      end
      return unless Gosu.distance(shot.x,shot.y,@xcenter,@ycenter) <= 4
      newdir = :north if shot.direction == :west
      newdir = :east if shot.direction == :south
      shot.live = false
      shot.game.shot.push(Shot.new(shot.game,@xcenter,@ycenter,newdir))
      return
    end #def hitWithShot! 
    
  end #class CornerSW
end #module Things
end #module OperationLambda