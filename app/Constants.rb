# The modules in this file represent various constants that are referred to
# throughout the codebase.

module OperationLambda
  
  # Sizes provides the base values describing the size of the playfield
  # and the window containing it.
  module Sizes
    TileHeight = 12*2
    TileWidth = 16*2
    TilesHigh = 14
    TilesWide = 20
    HUDHeight = 64
    TopMargin = 2
    BottomMargin = 2
    LeftMargin = 0
    RightMargin = 0
    MapHeight = (TileHeight * TilesHigh) + TopMargin + BottomMargin
    WindowHeight = MapHeight + HUDHeight
    MapWidth = TileWidth * TilesWide
    WindowWidth = MapWidth
  end #module Sizes


  # ZOrder provides constants for use in Z-coordinates for draw calls.
  module ZOrder
    Stars  = 0
    Floor  = 1
    Things = 2
    Player = 3
    Lasers = 4
    Shot   = 5
    Cursor = 5
    Splash = 6
    TopMessage = 99
    Fade = 100
  end #module ZOrder
  
  # This single value determines how frequently the player can move,
  # how long animations take, etc.
  module Timing
    Cycle = 0.25 # seconds
  end
  
  # Some constants describing the multiplier the various difficulty
  # levels apply to your score.
  module Score
    BonusFactors = {
      :relaxed =>  25,
      :easy    =>  50,
      :normal  => 100,
      :hard    => 200
    }
    
    TimeBonusFactors  = BonusFactors.dup
    LevelBonusFactors = BonusFactors.merge(BonusFactors) {|k,v| v*10}
    
  end
  
end #module OperationLambda
  