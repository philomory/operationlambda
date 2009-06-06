require 'Constants'
require 'helper'

module OperationLambda
  class Shot
  
    attr_accessor :x, :y, :direction, :length, :live, :game
  
    def inspect
      return "#{@x},#{@y},#{@direction},#{@length},#{@live}"
    end
  
    def initialize(game,x,y,facing)
      @game, @x, @y, @direction = game, x, y, facing
      @map = @game.map
      @player = @game.player
      @length = 0
      @live = true
      @image = ImageManager.image('Shot')
    end
  
    def update
      if @live == true then
        @y -= (Sizes::TileHeight/5) if @direction == :north
        @y += (Sizes::TileHeight/5) if @direction == :south
        @x += (Sizes::TileWidth/5) if @direction == :east
        @x -= (Sizes::TileWidth/5) if @direction == :west
        @length += 0.2 if @length < 1
        x = (@x / Sizes::TileWidth).to_int
        y = (@y / Sizes::TileHeight).to_int
        if x == @player.x and y == @player.y then
          @game.player_dies
        end

        @map[x,y].hitWithShot!(self) #has the potential to reach back up and modify me
        return self
      else
        @length -= 0.2
        return nil if @length <= 0
        return self
      end
    end #def update
  
    def draw
      xf,yf = 1,1
      yf =  @length * Sizes::TileHeight / 2 if @direction == :north
      yf = -@length * Sizes::TileHeight / 2 if @direction == :south 
      xf = -@length * Sizes::TileWidth  / 2  if @direction == :east
      xf =  @length * Sizes::TileWidth  / 2  if @direction == :west
      @image.draw(@x,@y,ZOrder::Shot,xf,yf)
      
    end #def draw
  
  end #class Shot
end #module OperationLambda