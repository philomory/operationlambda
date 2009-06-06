module OperationLambda
  module LevelBuilder
    class Cursor
      attr_accessor :x, :y
      def initialize(x,y)
        @x,@y = x,y
        @color = 0xFFFF0000
      end
      def draw
        xpos = @x * Sizes::TileWidth
        ypos = @y * Sizes::TileHeight
        ImageManager.image('Cursor').draw(xpos,ypos,ZOrder::Cursor)
      end
      
      def north
        if @y >= 1
          @y -= 1
        end
      end
      
      def south
        if @y <= Sizes::TilesHigh - 2
          @y += 1
        end
      end
      
      def west
        if @x >= 1
          @x -= 1
        end
      end
      
      def east
        if @x <= Sizes::TilesWide - 2
          @x += 1
        end
      end
      
    end
  end
end