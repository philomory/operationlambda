require 'Constants'
require 'helper'

module OperationLambda
  class BaseMap
    attr_accessor :width, :height, :places

    def initialize(width,height)
      @height, @width = height, width
      @places = Array.new(@width) {Array.new(@height)}
      @background_image = ImageManager.image('Stars')
      @floor_image = ImageManager.tile('Floor').static
    end #def initialize
  
    def [](x,y)
      if x.in?(0...Sizes::TilesWide) and y.in?(0...Sizes::TilesHigh) then
        return @places[x][y]
      else
        return Brick.new(self,0,0) #sanity
      end
    end
    
    def []=(x,y,val)
      if x.in?(0...Sizes::TilesWide) and y.in?(0...Sizes::TilesHigh) then
        @places[x][y] = val
      else
        warn "Trying to set non-existent map space: x:#{x}, y:#{y}, value:#{val}\n"
      end
    end
    
    def each
      @places.each do |col|
        col.each do |obj|
          yield obj
        end
      end
    end
  
    def each_with_coords
      @places.each_with_index do |col,x|
        col.each_with_index do |obj,y|
          yield obj,x,y
        end
      end
    end
  
    def draw
      @background_image.draw(0,0,ZOrder::Stars)
      self.each_with_coords do |obj,x,y|
        xpos = x * Sizes::TileWidth
        ypos = y * Sizes::TileHeight
        @floor_image.draw(xpos,ypos,ZOrder::Floor) unless (obj.noun == 'Space')
        ImageManager.tile(obj.key).static.draw(xpos,ypos,ZOrder::Things)
      end
    end  
      
  end #class Map
end #module OperationLambda