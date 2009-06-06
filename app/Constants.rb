module OperationLambda
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
  
  module Timing
    Cycle = 0.25 # seconds
  end
  
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
  