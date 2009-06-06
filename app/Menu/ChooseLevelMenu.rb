require 'helper'
require 'Levelset'
require 'Constants'
require 'ImageManager'

module OperationLambda
  module Menu
    class ChooseLevelMenu < Screen
      PreviewScale = 0.25
      PreviewHeight = Sizes::MapHeight * PreviewScale #85
      PreviewWidth = Sizes::MapWidth * PreviewScale #160
      PreviewColumns = 3
      PreviewRows = 2
      PreviewHorizontalSpacing = (Sizes::WindowWidth - (PreviewColumns * PreviewWidth)) / (PreviewColumns + 1)
      PreviewTopMargin = 120
      PreviewVerticalSpacing = 40
      BorderColor = Gosu::Color.new(255,255,0,0)
      BorderWidth = 2
      
      def initialize(parent,levelset)
        @parent = parent
        @levelset = levelset
        
        @font = ImageManager.font(:basic,10)
        @last_level = @levelset.metadata['levels']
        @first_visible_level = 1
        @xsel, @ysel = 0, 0
        @level_images = Array.new
        @level_images[0] = ImageManager.image('Stars')
        @title = @levelset.metadata['title']
        @title_font = ImageManager.font(:menu,20)
      end

      def draw
        self.draw_title
        self.draw_previews
        self.draw_border
        self.draw_arrows
      end #def draw
      
      def draw_title
        x = Sizes::WindowWidth/2
        y = 20
        @title_font.draw_rel("Levelset: #{@title}",x,y,ZOrder::Things,0.5,0,1,1,0xFFFFFFFF)
      end
      
      def draw_previews
        ImageManager.image('Background').draw(0,0,ZOrder::Stars)
        (0...PreviewRows).each do |row|
          (0...PreviewColumns).each do |col|
            x =  PreviewHorizontalSpacing + (col * (PreviewHorizontalSpacing + PreviewWidth))
            y = PreviewTopMargin + (row * (PreviewVerticalSpacing + PreviewHeight))
            fy = y + PreviewHeight + 5
            level = first_visible_level + col + (row * PreviewColumns)
            if level <= @last_level
              self.set_preview(level)
              @level_images[level].draw(x,y,ZOrder::Things,PreviewScale,PreviewScale)
              @font.draw(self.level_label(level),x,fy,ZOrder::Things)
            end
          end
        end
      end # def draw_previews

      def set_preview(level) #needs to be overridden in some cases
        @level_images[level] ||= @levelset.preview_for_level(level)
      end

      def level_label(level) #needs to be overridden in some cases
        "Level #{level}"
      end

      def draw_arrows
        if @first_visible_level > 1 then
          x = Sizes::WindowWidth - PreviewHorizontalSpacing + 5
          y = PreviewTopMargin
          ImageManager.image('UpArrow').draw(x,y,ZOrder::Things)
        end
        if @first_visible_level+(PreviewColumns*PreviewRows) < @last_level
          x = Sizes::WindowWidth - PreviewHorizontalSpacing + 5
          y = PreviewTopMargin + ((PreviewRows-1) * (PreviewVerticalSpacing + PreviewHeight)) + PreviewHeight - 16
          ImageManager.image('DownArrow').draw(x,y,ZOrder::Things)
        end
      end
      
      def draw_border
        c = BorderColor
        b = BorderWidth
        x =  PreviewHorizontalSpacing + (@xsel * (PreviewHorizontalSpacing + PreviewWidth))
        y = PreviewTopMargin + (@ysel * (PreviewVerticalSpacing + PreviewHeight))
        ((x1,y1),(x2,y2),(x3,y3),(x4,y4)) = [[x-b,y-b],[x+PreviewWidth+b,y-b],[x-b,y+PreviewHeight+b],[x+PreviewWidth+b,y+PreviewHeight+b]]
        self.draw_quad(x1,y1,c,x2,y2,c,x3,y3,c,x4,y4,c,ZOrder::Floor)
      end
      
      def button_down(id)
        case id
        when Gosu::KbLeft
          @xsel = (@xsel-1) % PreviewColumns
        when Gosu::KbRight
          @xsel = (@xsel+1) % PreviewColumns
        when Gosu::KbUp
          if @ysel == 0
            if @first_visible_level > 1
              @first_visible_level -= PreviewColumns
            end
          else
            @ysel = @ysel-1
          end
        when Gosu::KbDown
          if @ysel == (PreviewRows - 1)
            if @first_visible_level + (PreviewColumns * PreviewRows) < 100
              @first_visible_level += PreviewColumns
            end
          else
            @ysel = @ysel+1
          end
        when *[Gosu::KbReturn, Gosu::KbEnter, Gosu::KbSpace]
          level = @first_visible_level + @xsel + @ysel*PreviewColumns
          self.selected(@levelset,level)
        when Gosu::KbEscape
          MainWindow.current_screen = @parent
        end
        
      end
      
      def selected(levelset,level)
        raise "Subclass must impliment 'selected(levelset,level)!"
      end
      
      private
      def first_visible_level
        @first_visible_level
      end
      
      def last_visible_level
        [@first_visible_level + 5,@last_level].min
      end
      
    end
  end
end