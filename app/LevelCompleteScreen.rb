require 'Screen'
require 'Constants'
require 'ImageManager'

module OperationLambda
  class LevelCompleteScreen < Screen
    ScoreXOffset      = 419
    LevelBonusYOffset = 159
    TimeBonusYOffset  = 207
    TotalScoreYOffset = 255
    
    # Scores is a hash of scores to display, with three keys: :level_bonus, :time_bonus,
    # and :total_score.
    def initialize(parent,scores)
      @parent = parent
      @scores = scores
      @font = ImageManager.font(:basic,20)
    end
    
    def draw
      ImageManager.image('Stars').draw(0,0,ZOrder::Stars)
      ImageManager.image('LevelComplete').draw(0,0,ZOrder::Floor)
      @font.draw_rel(@scores[:level_bonus],ScoreXOffset,LevelBonusYOffset,ZOrder::Things,1,0,1,1)
      @font.draw_rel(@scores[:time_bonus],ScoreXOffset,TimeBonusYOffset,ZOrder::Things,1,0,1,1)
      @font.draw_rel(@scores[:total_score],ScoreXOffset,TotalScoreYOffset,ZOrder::Things,1,0,1,1)
    end
    
    def button_down(id)
      MainWindow.current_screen = @parent;
      @parent.start_next_level
    end
    
    def should_play_music?
      true
    end
  end
end
