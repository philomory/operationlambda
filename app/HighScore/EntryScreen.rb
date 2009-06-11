require 'HighScore/Manager'
require 'Screen'
require 'ImageManager'
require 'TextField'

module OperationLambda
  module HighScore
    
    # This screen allows the player to enter their name if they get a high score.
    class EntryScreen < Screen
      
      NameXOffset   = 150
      LevelXOffset  = 425
      ScoreXOffset  = 525
      
      TopYOffset    = 135
      YDelta        =  28
      
      def initialize(levelset,level,score)
        super()
        @levelset, @level, @score = levelset,level,score
        @background = ImageManager.image('HighScoreDisplay')
        raise "Should never get here!" unless Manager.high_score?(@levelset,@score)
        @scores = Manager.new_score_entry(@levelset,@score)
        @font = ImageManager.font(:basic,20)
        @name_entry_field = Gosu::TextInput.new
        self.text_input = @name_entry_field
      end
      
      def draw
        self.draw_background
        self.draw_scores
      end
      
      def draw_background
        @background.draw(0,0,ZOrder::Stars)
      end
      
      def draw_scores
        @scores.each_with_index do |entry,rank|
          ypos = TopYOffset + (rank * YDelta)
          if entry[:name] == :INSERT
            #@font.draw(    entry[:name ],NameXOffset ,ypos,ZOrder::Things)
            @font.draw(@name_entry_field.text,NameXOffset,ypos,ZOrder::Things)
            @font.draw_rel(@level,LevelXOffset,ypos,ZOrder::Things,1,0,1,1)
            @font.draw_rel(@score,ScoreXOffset,ypos,ZOrder::Things,1,0,1,1)
          else
            @font.draw(    entry[:name ],NameXOffset ,ypos,ZOrder::Things)
            @font.draw_rel(entry[:level],LevelXOffset,ypos,ZOrder::Things,1,0,1,1)
            @font.draw_rel(entry[:score],ScoreXOffset,ypos,ZOrder::Things,1,0,1,1)
          end
        end
      end
      
      def button_down(id)
        if id.in? [Gosu::KbEnter,Gosu::KbReturn]
          name = @name_entry_field.text
          if name == ""
            return
          else
            Manager.add_entry(@levelset,name,@level,@score)
            MainWindow.current_screen = MainWindow.main_menu
          end
        end
      end
    
    end
  end
end
