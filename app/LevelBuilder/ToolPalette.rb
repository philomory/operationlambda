require 'LevelBuilder/BuilderThings'
require 'Constants'
require 'ImageManager'

module OperationLambda
  module LevelBuilder
    class ToolPalette
      include BuilderThings
      def initialize(parent)
        @parent = parent
        @tools = [Space,Empty,Brick,Corner,CrackedBrick,PushableBrick,Bomb,Mirror,Laser,
          Generator,Switch,Frame,Gate,Hostage,EscapeHatch,PlayerStart
        ].map{|thing| thing.new}
        @selection_index = 0
        @font = ImageManager.font(:basic,10)
      end
      
      def next
        @selection_index = (@selection_index + 1) % @tools.size
      end
      
      def prev
        @selection_index = (@selection_index - 1) % @tools.size
      end
      
      def current_tool
        @tools[@selection_index]
      end
      
      def draw
        @tools.each_with_index do |tool,index|
          xpos = index * Sizes::TileWidth
          ypos = Sizes::WindowHeight - Sizes::HUDHeight
          if index == @selection_index
            color = 0xffffffff
          else
            color = 0xff999999
          end
          unless tool.noun == 'Space'
            ImageManager.tile('Floor').static.draw(xpos,ypos,ZOrder::Floor,1,1,color)
          end
          ImageManager.tile(tool.key).static.draw(xpos,ypos,ZOrder::Things,1,1,color)
        end
        y = Sizes::WindowHeight - (Sizes::HUDHeight / 2)
        x = 500
        0xffff0000
        if @parent.auto_draw
          color = 0xffff0000
          message = "auto-draw on"
        else
          color = 0xff888888
          message = "auto-draw off"
        end
        @font.draw(message,x,y,ZOrder::Lasers,1,1,color)
      end
      
    end
  end
end