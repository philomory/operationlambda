require 'gosu'
require 'Noun'
require 'Constants'
require 'Shot'

module OperationLambda
  class Player < Noun
    attr_accessor :hostages_saved, :lives
    attr_reader :facing
  
    def initialize(game)
      @game = game
      #@map = @game.map
      @x = 0
      @y = 0
      @facing = :west
      @lives = 2
      @movement_delay = Timing::Cycle
      @last_moved = Time.now - @movement_delay
      @moving = nil
      @state = :standing
    end #def initialize
  
    def level_start(map,where)
      @map, @x, @y, @facing = map, where[:x], where[:y], where[:dir]
      @hostages_saved = 0
    end
  
    def draw
      case @state
      when :standing
        xpos = @x * Sizes::TileWidth
        ypos = @y * Sizes::TileHeight
        ImageManager.tile("Player-#{@facing}").static.draw(xpos,ypos,ZOrder::Player)
      when :moving
        x = @x
        y = @y
        t = [(Time.now - @last_moved) / @movement_delay,0.999].min
        tile = ImageManager.tile("Player-#{@facing}")
        frame = (tile.size * t).floor
        y -= t if @facing == :north
        y += t if @facing == :south
        x += t if @facing == :east
        x -= t if @facing == :west
        xpos = x * Sizes::TileWidth
        ypos = y * Sizes::TileHeight
        ImageManager.tile("Player-#{@facing}").frame(frame).draw(xpos,ypos,ZOrder::Player)
      when :shooting
        xpos = @x * Sizes::TileWidth
        ypos = @y * Sizes::TileHeight
        ImageManager.tile("Player-shooting-#{@facing}").static.draw(xpos,ypos,ZOrder::Player)
      end
    end #def draw
  
    def stop
      @state = :standing
    end
  
    def moving
      @state == :moving
    end
  
    def update
      if Time.now - @last_moved > @movement_delay
        case @state
        when :moving
          destination = self.send(@facing)
          @y -= 1 if @facing == :north
          @y += 1 if @facing == :south
          @x += 1 if @facing == :east
          @x -= 1 if @facing == :west
          @state = :standing
          destination.playerEnteredTile(self)
        when :shooting
          @state = :standing
        else
        end
      end
    end
  
    def pressedMovementKey(direction)
      return if Time.now - @last_moved < @movement_delay
      if @facing == direction then
        destination = self.send(direction)
        if destination.empty? || destination.collectible? || destination.pushed(direction) then #Short-circuit evaluation is relied on here
          @state = :moving
        end
      else
        @facing = direction
      end
      @last_moved = Time.now
    end
  
    def shoot
      return if (not @game.shot.empty?) or Time.now - @last_moved < @movement_delay
      case @facing
      when :north
        xpos = (@x + 0.5) * Sizes::TileWidth
        ypos = (@y * Sizes::TileHeight)
      when :south
        xpos = (@x + 0.5) * Sizes::TileWidth
        ypos = ((@y+1) * Sizes::TileHeight) 
      when :east
        xpos = ((@x+1) * Sizes::TileWidth)
        ypos = (@y + 0.5) * Sizes::TileHeight
      when :west
        xpos = (@x * Sizes::TileWidth)
        ypos = (@y + 0.5) * Sizes::TileHeight
      end
      @state = :shooting
      @game.shot = [Shot.new(@game,xpos,ypos,@facing)]
      @last_moved = Time.now
    end #def shoot
  
    def rotate
      return if Time.now - @last_moved < @movement_delay
      self.send(@facing).rotate
      @last_moved = Time.now
    end #def rotate
  
  end #class Player
end #module OperationLambda