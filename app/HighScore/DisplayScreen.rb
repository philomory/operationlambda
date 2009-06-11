require 'HighScore/Manager'
require 'Screen'
require 'ImageManager'
require 'Menu/ConfirmMenu'

module OperationLambda
  module HighScore
    
    # This Screen displays high scores. There are three categories to select
    # from horizontally: the top scores collected across every levelset,
    # the top scores for individual levelsets that are included with Operation
    # Lambda, and the top scores for third-party, user-installed levelsets.
    # In the second and third columns, the up and down keys can be used to
    # select which individual levelset to look at.
    class DisplayScreen < Screen
      
      NameXOffset   = 150
      LevelXOffset  = 425
      ScoreXOffset  = 525
      
      TopYOffset    = 135
      YDelta        =  28
      
      def initialize(parent)
        super()
        @parent = parent
        @background = ImageManager.image('HighScoreDisplay')
        @prompt = ImageManager.image('HSPrompt')
        @scores = Manager.top_scores
        @font = ImageManager.font(:basic,20)
        @menu_font = ImageManager.font(:menu,16)
        @subheading_font = ImageManager.font(:basic,15)
        @levelsets = [[:all],Levelset.app_levelsets,Levelset.user_levelsets]
        @selected_category = 0
        @selected_levelset = [0,0,0]
        @selection_changed = false
      end
      
      def update
        if @selection_changed
          self.update_scores
          @selection_changed = false
        end
      end
      
      def draw
        self.draw_background
        self.draw_categories
        self.draw_scores
      end
      
      def draw_background
        @background.draw(0,0,ZOrder::Stars)
        @prompt.draw(174,356,ZOrder::Things)
      end
      
      def draw_categories
        ["Top Scores","Standard","Third-party"].each_with_index do |title,index|
          c = (@selected_category == index ? 0xFFFFFFFF : 0xFF666666)
          y = 15
          x = (index * (Sizes::WindowWidth / 2)) - ((index-1) * 20)
          rx = index * 0.5
          @menu_font.draw_rel(title,x,y,ZOrder::Things,rx,0,1,1,c)
        end
        unless @selected_category == 0
          x = Sizes::WindowWidth / 2
          y = 40
          c = 0xffbb0000
          text = (self.selected_levelset.metadata['title'] rescue 'no levelset available')
          @subheading_font.draw_rel(text,x,y,ZOrder::Things,0.5,0,1,1,c)
        end
      end
          
      def draw_scores
        @scores.each_with_index do |entry,rank|
          ypos = TopYOffset + (rank * YDelta)
          @font.draw(    entry[:name ],NameXOffset ,ypos,ZOrder::Things)
          @font.draw_rel(entry[:level],LevelXOffset,ypos,ZOrder::Things,1,0,1,1)
          @font.draw_rel(entry[:score],ScoreXOffset,ypos,ZOrder::Things,1,0,1,1)
        end
      end
      
      def button_down(id)
        case id
        when Gosu::KbLeft
          ((@selected_category -= 1) && @selection_changed = true) if @selected_category > 0
        when Gosu::KbRight
          ((@selected_category += 1) && @selection_changed = true) if @selected_category < 2
        when Gosu::KbDown
          if @levelsets[@selected_category].size > 1
            @selected_levelset[@selected_category] += 1
            @selected_levelset[@selected_category] %= @levelsets[@selected_category].size
            @selection_changed = true
          end
        when Gosu::KbUp
          if @levelsets[@selected_category].size > 1
            @selected_levelset[@selected_category] -= 1
            @selected_levelset[@selected_category] %= @levelsets[@selected_category].size
            @selection_changed = true
          end
        when Gosu::KbDelete
          ls = self.selected_levelset
          case ls
          when :all
            MainWindow.current_screen = Menu::ConfirmMenu.new(self,"Are you sure you wish to clear all high scores?") {Manager.clear_all_scores; self.update_scores}
          when :none
          else
            title = ls.metadata['title']
            MainWindow.current_screen = Menu::ConfirmMenu.new(self,"Are you sure you wish to clear high scores for #{title}?") {Manager.write_default_levelset_scores(ls); self.update_scores}
          end
        when Gosu::KbEscape
          MainWindow.current_screen = @parent
        end
      end
    
      def update_scores
        levelset = self.selected_levelset
        if levelset == :all
          @scores = Manager.top_scores
        elsif levelset
          @scores = Manager.levelset_scores(levelset)
        else
          @scores = []
        end
      end
    
      def selected_levelset
        index = @selected_levelset[@selected_category]
        levelsets = @levelsets[@selected_category]
        levelset = levelsets[index]
        return levelset
      end
    
    end
  end
end
