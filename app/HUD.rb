module OperationLambda
  class HUD
    HostageOverlayXOffset = 426
    HostageOverlayYOffset = 14
    HostageXOffset = 6
    HostageYOffset = 4
    Col1XOffset = 160
    Col2XOffset = 300
    Row1YOffset = 7
    Row2YOffset = 35
    
    def initialize (game,ypos)
      @game,@ypos = game,ypos
      @font = ImageManager.font(:basic,20)
      @hud = ImageManager.image('HUD')
      num_hostages = @game.map.hostages
      @hostages_overlay = ImageManager.image("HUD-Hostage-#{num_hostages}") if num_hostages > 0
      @hostage_image = ImageManager.tile('Hostage-north').static
    end #def intialize
    
    def draw
      self.draw_hud
      self.draw_score
      self.draw_level
      self.draw_lives
      self.draw_time
      self.draw_hostages if @game.map.hostages > 0
    end
    
    def draw_hud
      @hud.draw(0,@ypos,1)
    end
      
    def draw_score
      @font.draw_rel(@game.score,Col1XOffset,@ypos+Row1YOffset,2,1,0,1,1)
    end
      
    def draw_level
      @font.draw_rel(Settings[:level],Col1XOffset,@ypos+Row2YOffset,2,1,0,1,1)
    end
    
    def draw_lives
      @font.draw_rel(@game.player.lives,Col2XOffset,@ypos+Row1YOffset,2,1,0,1,1)
    end
    
    def draw_time
      time = @game.time_remaining
      minutes = time / 60
      seconds = time % 60
      tstring = "#{minutes}:#{seconds.to_s.rjust(2,"0")}"
      @font.draw_rel(tstring,Col2XOffset,@ypos+Row2YOffset,2,1,0,1,1)
    end
    
    def draw_hostages
      @hostages_overlay.draw(HostageOverlayXOffset,@ypos+HostageOverlayYOffset,2)
      ypos = HostageOverlayYOffset + HostageYOffset + @ypos
      (1..@game.player.hostages_saved).each do |n|
        xpos = HostageOverlayXOffset + HostageXOffset + (Sizes::TileWidth * (n-1))
        @hostage_image.draw(xpos,ypos,3)
      end
      # hostages drawn into overlay at regular tile width interval
    end
    
  end #class HUD
end #module OperationLambda