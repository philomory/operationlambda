require 'Platform'

module OperationLambda
  module Menu
    class ChooseLevelsetMenu < Screen
      PreviewScale = 0.25
      PreviewHeight = Sizes::MapHeight * PreviewScale #85
      PreviewWidth = Sizes::MapWidth * PreviewScale #160
      #PreviewHorizontalSpacing = (Sizes::WindowWidth - (PreviewColumns * PreviewWidth)) / (PreviewColumns + 1)
      PreviewTopMargin = 80
      PreviewLeftMargin = 20
      PreviewVerticalSpacing = 40
      BorderColor = Gosu::Color.new(255,255,0,0)
      BorderWidth = 2
      PreviewRows = (Sizes::WindowHeight - PreviewTopMargin) / (PreviewHeight + PreviewVerticalSpacing)
      
      def initialize(parent,&result_callback)
        @parent = parent
        @levelsets = []
        @levelset_previews = {:app => [], :user => []}
          
        #pdir = Dir.new(Platform::ApplicationLevelsetsDir)
        @app_levelsets = Levelset.app_levelsets #(pdir.entries - ['.','..']).map {|item| File.join(pdir.path,item)}.select {|path| File.directory?(path)}.map {|dir| Levelset.new({:dir => File.basename(dir), :cat => :app})}

        #pdir = Dir.new(Platform::UserLevelsetsDir)
        @user_levelsets = Levelset.user_levelsets #(pdir.entries - ['.','..']).map {|item| File.join(pdir.path,item)}.select {|path| File.directory?(path)}.map {|dir| Levelset.new({:dir => File.basename(dir), :cat => :user})}
        
        @levelsets = {:app => @app_levelsets,:user => @user_levelsets}
        @first_visible_levelset_index = 0
        @selection_index = 0
        @category = :app
        @font = ImageManager.font(:basic,20)
        @category_font = ImageManager.font(:menu,20)
        @background = ImageManager.image('Background')
      end

      def first_visible_levelset_index
        @first_visible_levelset_index
      end
      
      def last_visible_levelset_index
        [@first_visible_levelset_index + PreviewRows,@levelsets[@category].size].min - 1
      end

      def button_down(id)
        case id
        when Gosu::KbEscape
          MainWindow.current_screen = @parent
        when Gosu::KbDown
          @selection_index = (@selection_index + 1) % @levelsets[@category].size
          if @selection_index > self.last_visible_levelset_index
            @first_visible_levelset_index += 1
          elsif @selection_index == 0
            @first_visible_levelset_index = 0 
          end
        when Gosu::KbUp
          @selection_index = (@selection_index - 1) % @levelsets[@category].size
          if @selection_index < self.first_visible_levelset_index
            @first_visible_levelset_index -= 1
          elsif @selection_index == @levelsets[@category].size - 1
            @first_visible_levelset_index = @levelsets[@category].size - 2
          end
        when *[Gosu::KbRight,Gosu::KbLeft]
          @category = (@category == :app ? :user : :app)
        when *[Gosu::KbSpace,Gosu::KbEnter,Gosu::KbReturn]
          self.selected(@levelsets[@category][@selection_index])
        end
      end


      def update
      end


      def draw
        @background.draw(0,0,ZOrder::Stars)
        self.draw_previews
        self.draw_categories
        
        
      end
      
      def draw_previews
        (first_visible_levelset_index..last_visible_levelset_index).each do |index|
          levelset = @levelsets[@category][index]
          if levelset
            y = PreviewTopMargin + ((index - first_visible_levelset_index) * (PreviewVerticalSpacing + PreviewHeight))
            x = PreviewLeftMargin
            lx = x - 5
            rx = Sizes::WindowWidth - lx
            uy = y - 5
            dy = y + PreviewHeight + 5
            tx = x + PreviewWidth + 20
            c = (@selection_index == index ? 0xFF003355 : 0xFF000000)
            self.draw_quad(lx,uy,c,rx,uy,c,lx,dy,c,rx,dy,c,ZOrder::Floor)
            meta = levelset.metadata
            @levelset_previews[@category][index] ||= (@levelsets[@category][index].preview_for_level(1) rescue ImageManager.image('Stars'))
            @levelset_previews[@category][index].draw(PreviewLeftMargin,y,ZOrder::Things,PreviewScale,PreviewScale)
            @font.draw(meta['title'],tx,y+5,ZOrder::Splash)
            level_string = (meta['levels'] == 1 ? 'level' : 'levels')
            @font.draw("#{meta['levels']} #{level_string}",tx,y+30,ZOrder::Splash)
            case meta['authors'].length
            when 0
              author_string = "Author: Unknown"
            when 1
              author_string = "Author: #{meta['authors'][0]}"
            when (2..4)
              author_string = "Authors: #{meta['authors'].join(", ")}"
            else
              author_string = "Authors: #{meta['authors'][0..3].join(", ")}..."
            end
            @font.draw(author_string,tx,y+55,ZOrder::Splash)
          end
        end
      end
      
      def draw_categories
        x1 = Sizes::WindowWidth / 4
        x2 = Sizes::WindowWidth - x1
        y = PreviewTopMargin / 2  
        c = [0xFFFFFFFF,0xFF666666]
        c.reverse! if @category == :user
        @category_font.draw_rel("Standard",x1,y,ZOrder::Things,0.5,0,1,1,c[0])
        @category_font.draw_rel("Third-party",x2,y,ZOrder::Things,0.5,0,1,1,c[1])
      end
      
    end
  end
end