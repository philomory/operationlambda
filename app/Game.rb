require 'gosu'
require 'helper'
require 'Screen'
require 'Things'
OperationLambda::Things.load_things
require 'GameplayMap'
require 'Player'
require 'HUD'
require 'Constants'
require 'GameplayMap'
require 'Levelset'
require 'Settings'
require 'LevelCompleteScreen'
require 'VictoryScreen'
require 'Menu/PauseMenu'
require 'Counter/Countdown'
require 'OutOfTimeSequence'
require 'HighScore/Manager'
require 'HighScore/EntryScreen'

module OperationLambda
  
  # The Game class impliments the core gameplay logic of Operation Lambda.
  # It is currently in need of a cleanup.
  class Game < Screen
    attr_accessor :map, :shot, :player, :score, :timer

    def initialize(levelset,level,difficulty)
      super()
      @levelset,@difficulty = levelset, difficulty
      Settings[:levelset] = @levelset.key
      Settings[:level] = level
      @pause_menu = Menu::PauseMenu.new(self)
      @player = Player.new(self)
      @key_stack = Array.new
      @splash_duration = 2
      @score = 0
      self.first_start_level
    end #def initialize

    # The way Game#active_key works is, @key_stack is a stack of the keys
    # currently depressed, with the most recently depressed key on top.
    # active_key gets the topmost item on the stack for which there is an
    # associated key-mapping.
    #
    # The pupose of this is to allow the following, which mirrors the behavior
    # of the original Operation Lambda:
    # You begin not pressing any keys. If you press and hold left, you will
    # begin to move left. If you then press and begin to hold up, while still
    # holding down left as well, you will stop moving left and instead move up.
    # However, when you let go of the left key, you will begin moving up again.
    def active_key
      @key_stack.find {|key| Settings[:key_config][:gameplay].key?(key)}
    end #def active_key

    def update
      if @game_state == :play and self.time_remaining == 0 and @difficulty != :relaxed
        MainWindow.current_screen = OutOfTimeSequence.new(self)
        MainWindow.current_screen.update
        return
      end
      case @game_state
      when :play
        self.remove_lasers
        self.update_player
        self.update_shot
        self.update_crumbling
        self.update_lasers
        self.update_gates
      when :died
        if Time.now - @died_time > @splash_duration
          self.restart_level
        end
      end
    end #def update
    
    def out_of_time_finished
      @player.lives -= 1
      if @player.lives >= 0
        MainWindow.current_screen = self
        self.first_start_level
      else
        self.game_over
      end
    end
    
    def game_over
      if HighScore::Manager.high_score?(@levelset,@score)
        MainWindow.current_screen = HighScore::EntryScreen.new(@levelset,Settings[:level],@score)
      else
        MainWindow.current_screen = MainWindow.main_menu
      end
    end
    
    def first_start_level
      self.restart_level
      duration = case @difficulty
      when :relaxed
        @map.time * 2
      when :easy
        @map.time * 2
      when :normal
        @map.time
      when :hard
        @map.time * 0.75
      end
      @timer = Counter::Countdown.new(duration)
      @timer.start
    end
    
    def restart_level
      @game_state = :play
      @map = GameplayMap.new(self,Sizes::TilesWide,Sizes::TilesHigh,@levelset.load_level(Settings[:level]))
      @shot = []
      @player.level_start(@map,@map.player_start)
      @death_color = :none
      @hud = HUD.new(self)
      @died_time = Time.now - @splash_duration
    end
    
    def time_remaining
      @timer.time_remaining.to_i
    end
    
    # Something tells me that all of this logic should move into the Player
    # class, and that Player#update should recieve the active key as a
    # parameter.
    def update_player
      @player.update
      unless @player.moving
        action = Settings[:key_config][:gameplay][self.active_key]
        if action.in? [:north,:south,:east,:west] then
          @player.pressedMovementKey(action)
        elsif action == :shoot
          @player.shoot
        elsif action == :rotate
          @player.rotate
        elsif action.nil?
        else
          puts "Action '#{action}' not implimented!"
        end
      end
    end #def update_player

    def update_shot
      unless @shot.empty?
        @shot.map! do |part|
          part.update
        end
      end
      @shot.compact!
    end #def update_shot
    
    def update_crumbling
      @map.crumbling.each {|brick| brick.update}
    end

    def update_lasers
      @map.switch_state = {:red => 0, :blue => 0, :purple => 0}
      @map.lasers.each {|laser| laser.fireLaser}
      if (player_spot = @map[@player.x,@player.y]).lasered?
        color = (player_spot.laserbeams.values - [:none])[0]
        self.player_dies(color)
      end
    end #def update_lasers

    def update_gates
      @map.gates.each {|gate| gate.updateState}
      if @map[@player.x,@player.y].class == Things::Gate
        self.player_dies
      end
    end #def update_gates

    def remove_lasers
      @map.remove_lasers
    end

    def player_dies(color = :none)
      @died_time = Time.now
      @player.stop
      @death_color = color
      @game_state = :died
    end #def player_dies

    def player_wins
      @timer.pause
      scores = self.calculate_scores
      @timer.reset
      @key_stack.clear
      if Settings[:level] == @levelset.metadata['levels']
        MainWindow.current_screen = VictoryScreen.new
      else
        MainWindow.current_screen = LevelCompleteScreen.new(self,scores)
      end
    end

    def calculate_scores
      tbf = Score::TimeBonusFactors[@difficulty]
      lbf = Score::LevelBonusFactors[@difficulty]
      t = @timer.time_remaining.floor
      l = Settings[:level]
      tb = t * tbf
      lb = l * lbf
      time_bonus  = @timer.time_remaining.floor * Score::TimeBonusFactors[@difficulty]
      level_bonus = Settings[:level] * Score::LevelBonusFactors[@difficulty]
      @score += time_bonus + level_bonus
      return {
        :level_bonus => level_bonus,
        :time_bonus  => time_bonus,
        :total_score => @score
      }
    end

    def start_next_level
      Settings[:level] += 1
      @map = GameplayMap.new(self,Sizes::TilesWide,Sizes::TilesHigh,@levelset.load_level(Settings[:level]))
      @player.level_start(@map,@map.player_start)
      @hud = HUD.new(self)
      self.first_start_level
    end

    def draw
      if @game_state.in? [:play,:died,:time_up] then
        @map.draw
        @hud.draw
        @player.draw
        @shot.each {|part| part.draw} unless @shot.empty?
      end
      if @game_state == :died then
        t = (Time.now - @died_time) / @splash_duration
        a = (Math.sin(2*Math::PI*t).abs*256).to_i
        a = [0, [a,255].min].max
        r,g,b = RGB[@death_color]
        c = Gosu::Color.new(a,r,g,b)
        self.fill(c)
      end
      if @game_state == :time_up then
        t = (Time.now - @died_time) / @splash_duration
        a = (MATH.sin(2*Math::PI*t).abs*256).to_i
        a = [0, [a,255].min].max
        c = Gosu::Color.new(a,255,255,255)
        self.fill(c)
      end
    end #def draw

    def button_down(id)
      case id
      when Gosu::KbEscape
        @timer.pause
        MainWindow.current_screen = @pause_menu
      end
      @key_stack.unshift(id).uniq!
    end #def button_down

    def button_up(id)
      @key_stack.delete(id)
    end

    def should_play_music?
      true
    end

  end #class Game
end #module OperationLambda
