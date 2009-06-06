require 'Screen'
require 'Constants'
require 'Platform'
require 'Menu/EditorMenu'
require 'LevelBuilder/EditorMap'
require 'LevelBuilder/BuilderThings'
require 'LevelBuilder/ToolPalette'
require 'LevelBuilder/Cursor'

module OperationLambda
  module LevelBuilder
    class Editor < Screen
      include BuilderThings
      
      private_class_method :new
      
      def self.load(parent,levelset,level)
        editor = new(parent,levelset)
        editor.load(level)
        editor
      end
      
      def self.create(parent,levelset)
        editor = new(parent,levelset)
        editor.anew
        editor
      end
      
      
      
      attr_accessor :things, :auto_draw
      attr_reader :level, :parent
      def initialize(parent,levelset)
        @parent = parent
        @levelset = levelset
        @nextKey = MainWindow.char_to_button_id(']')
        @prevKey = MainWindow.char_to_button_id('[')
        @tool_pal = ToolPalette.new(self)
        @cur = Cursor.new(0,0)
        @auto_draw = false
        @key_stack = []
        @move_delay = 0.2
        @last_moved = Time.now - @move_delay
      end #def initialize

      def anew
        @map = EditorMap.new(Sizes::TilesWide,Sizes::TilesHigh)
        @map[0,0] = BuilderThings::PlayerStart.new
        @player_x, @player_y, @player_o = 0,0,:north
        @level = @levelset.metadata['levels'] + 1
        @has_file = false
      end

      def load(level)
        level_data = @levelset.load_level(level)
        @map = EditorMap.new(Sizes::TilesWide,Sizes::TilesHigh,level_data)
        player_pos = @map.player_pos
        @player_x, @player_y = player_pos[:x],player_pos[:y]  
        @level = level
        @has_file = true
      end

      def has_file?
        @has_file ? true : false
      end

      def draw
        @map.draw
        @cur.draw
        @tool_pal.draw
        #xpos = @player_x * Sizes::TileWidth
        #ypos = @player_y * Sizes::TileHeight 
        #ImageManager.tile("Player-#{@player_o}").static.draw(xpos,ypos,ZOrder::Player)
      end

      def update
        return unless Time.now - @last_moved > @move_delay
        active_key = @key_stack[0]
        should_place_thing = false
        if active_key
          @last_moved = Time.now
          case active_key
          when *(Settings[:key_config][:editor].keys)
            action = Settings[:key_config][:editor][active_key]
            case action
            when :north,:south,:east,:west
              @cur.send(action)
            when :rotate
              @tool_pal.current_tool.rotate
              @auto_draw = false
            when :toggle_auto
              @auto_draw = !@auto_draw
            when :color
              @tool_pal.current_tool.cycle_color
            when :erase
              @auto_draw = false
              case @map[@cur.x,@cur.y]
              when BuilderThings::PlayerStart
              when BuilderThings::Space
              when BuilderThings::Empty
                @map[@cur.x,@cur.y] = BuilderThings::Space.new
              else
                @map[@cur.x,@cur.y] = BuilderThings::Empty.new
              end
            when :place
              @auto_draw = false
              should_place_thing = true
            end
          when @nextKey
            @auto_draw = false
            @tool_pal.next
          when @prevKey
            @auto_draw = false
            @tool_pal.prev
          end
        
          if @auto_draw or should_place_thing
            place_thing
          end
        end
      end #def update
     
      def place_thing
        c_tool = @tool_pal.current_tool
        if c_tool.noun == "PlayerStart"
          if @map[@cur.x,@cur.y].noun == "Empty"
            @map[@player_x,@player_y] = BuilderThings::Empty.new
            @player_x, @player_y = @cur.x, @cur.y
            @player_o = c_tool.orientation
            @map[@cur.x,@cur.y] = c_tool.dup
          end
        else
          unless @cur.x == @player_x and @cur.y == @player_y
            @map[@cur.x,@cur.y] = c_tool.dup
          end
        end
      end
      
      def button_down(id)
        case id
        when Gosu::KbEscape
            MainWindow.current_screen = Menu::EditorMenu.new(self)
        end
        @key_stack.unshift(id).uniq!
      end #def button_down

      def button_up(id)
        @key_stack.delete(id)
      end
      
      def save
        save_as_level(@level)
      end
      
      def save_copy
        level = @levelset.metadata['levels'] + 1
        save_as_level(level)
        @levelset.commit
        return level
      end
      
      def revert
      end

      private
      def save_as_level(level)
        level_data = {
          :places => @map.places.map {|column| column.map {|obj| obj.key} },
          :time   => @map.time
        }
        @levelset.save_level(level_data,level)
      end

    end
  end
end