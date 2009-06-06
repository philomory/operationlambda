require 'helper'
require 'BaseMap'
require 'LevelBuilder/BuilderThings'

module OperationLambda
  module LevelBuilder
    class EditorMap < BaseMap
      
      include BuilderThings
      
      DefaultLevelHash = {
        :time => 300,
        :places => Array.new(Sizes::TilesWide) {Array.new(Sizes::TilesHigh) {'Empty'}}
      }

      attr_accessor :player_pos, :time
      
      def initialize(width,height,level_hash = DefaultLevelHash)
        super(width,height)
        level_hash[:places].each_with_index do |column,x|
          column.each_with_index do |key,y|
            if key =~ /^Player-/
              @player_pos = {:x => x,:y => y}
            end
            self[x,y] = KeyToThingHash[key].call
          end
        end 
        @time = level_hash[:time]
      end #def initialize
      
      KeyToThingHash               = {
        'Space'                        => lambda {Space.new}, #Bret calls this 'Empty',
        'Empty'                        => lambda {Empty.new}, #Bret calls this 'Floor',

        'Player-west'                  => lambda {p = PlayerStart.new;p.orientation = :west;p},
        'Player-east'                  => lambda {p = PlayerStart.new;p.orientation = :east;p},
        'Player-north'                 => lambda {p = PlayerStart.new;p.orientation = :north;p},
        'Player-south'                 => lambda {p = PlayerStart.new;p.orientation = :south;p},
        'Hostage-west'                 => lambda {h = Hostage.new;h.orientation = :west;h},
        'Hostage-east'                 => lambda {h = Hostage.new;h.orientation = :east;h},
        'Hostage-north'                => lambda {h = Hostage.new;h.orientation = :north;h},
        'Hostage-south'                => lambda {h = Hostage.new;h.orientation = :south;h},

        'Mirror-normal'                => lambda {m = Mirror.new;m.orientation = :normal;m},
        'Mirror-flipped'               => lambda {m = Mirror.new;m.orientation = :flipped;m},

        'PushableBrick'                => lambda {PushableBrick.new},
        'Bomb'                         => lambda {Bomb.new},
        'EscapeHatch'                  => lambda {EscapeHatch.new},

        'Brick'                        => lambda {Brick.new},
        'CrackedBrick'                 => lambda {CrackedBrick.new},

        'CornerSE'                     => lambda {c = Corner.new;c.orientation = :se;c},
        'CornerNE'                     => lambda {c = Corner.new;c.orientation = :ne;c},
        'CornerNW'                     => lambda {c = Corner.new;c.orientation = :nw;c},
        'CornerSW'                     => lambda {c = Corner.new;c.orientation = :sw;c},

        'Generator-blue-on'            => lambda {g = Generator.new;g.orientation = :blue;g},
        'Generator-red-on'             => lambda {g = Generator.new;g.orientation = :red;g},
        'Generator-purple-on'          => lambda {g = Generator.new;g.orientation = :purple;g},

        'Laser-blue-west-on'           => lambda {l = Laser.new;l.color = :blue;l.orientation =:west;l},
        'Laser-blue-east-on'           => lambda {l = Laser.new;l.color = :blue;l.orientation =:east;l},
        'Laser-blue-north-on'          => lambda {l = Laser.new;l.color = :blue;l.orientation =:north;l},
        'Laser-blue-south-on'          => lambda {l = Laser.new;l.color = :blue;l.orientation =:south;l},
        'Laser-red-west-on'            => lambda {l = Laser.new;l.color = :red;l.orientation = :west;l},
        'Laser-red-east-on'            => lambda {l = Laser.new;l.color = :red;l.orientation = :east;l},
        'Laser-red-north-on'           => lambda {l = Laser.new;l.color = :red;l.orientation = :north;l},
        'Laser-red-south-on'           => lambda {l = Laser.new;l.color = :red;l.orientation = :south;l},
        'Laser-purple-west-on'         => lambda {l = Laser.new;l.color = :purple;l.orientation = :west;l},
        'Laser-purple-east-on'         => lambda {l = Laser.new;l.color = :purple;l.orientation = :east;l},
        'Laser-purple-north-on'        => lambda {l = Laser.new;l.color = :purple;l.orientation = :north;l},
        'Laser-purple-south-on'        => lambda {l = Laser.new;l.color = :purple;l.orientation = :south;l},

        'Switch-blue-vertical'         => lambda {s = Switch.new;s.color = :blue;s.orientation = :vertical;s},
        'Switch-blue-horizontal'       => lambda {s = Switch.new;s.color = :blue;s.orientation = :horizontal;s},   
        'Switch-red-vertical'          => lambda {s = Switch.new;s.color = :red;s.orientation = :vertical;s},  
        'Switch-red-horizontal'        => lambda {s = Switch.new;s.color = :red;s.orientation = :horizontal;s},
        'Switch-purple-vertical'       => lambda {s = Switch.new;s.color = :purple;s.orientation = :vertical;s},
        'Switch-purple-horizontal'     => lambda {s = Switch.new;s.color = :purple;s.orientation = :horizontal;s},

        'Frame-blue-west-closed'       => lambda {f = Frame.new;f.color = :blue;f.orientation = :west;f},
        'Frame-blue-east-closed'       => lambda {f = Frame.new;f.color = :blue;f.orientation = :east;f},
        'Frame-blue-north-closed'      => lambda {f = Frame.new;f.color = :blue;f.orientation = :north;f},
        'Frame-blue-south-closed'      => lambda {f = Frame.new;f.color = :blue;f.orientation = :south;f},
        'Gate-blue-horizontal'         => lambda {g = Gate.new;g.color = :blue;g.orientation = :horizontal;g},
        'Gate-blue-vertical'           => lambda {g = Gate.new;g.color = :blue;g.orientation = :vertical;g},

        'Frame-red-west-closed'        => lambda {f = Frame.new;f.color = :red;f.orientation = :west;f},
        'Frame-red-east-closed'        => lambda {f = Frame.new;f.color = :red;f.orientation = :east;f},
        'Frame-red-north-closed'       => lambda {f = Frame.new;f.color = :red;f.orientation = :north;f},
        'Frame-red-south-closed'       => lambda {f = Frame.new;f.color = :red;f.orientation = :south;f},
        'Gate-red-horizontal'          => lambda {g = Gate.new;g.color = :red;g.orientation = :horizontal;g},
        'Gate-red-vertical'            => lambda {g = Gate.new;g.color = :red;g.orientation = :vertical;g},

        'Frame-purple-west-closed'     => lambda {f = Frame.new;f.color = :purple;f.orientation = :west;f},
        'Frame-purple-east-closed'     => lambda {f = Frame.new;f.color = :purple;f.orientation = :east;f},
        'Frame-purple-north-closed'    => lambda {f = Frame.new;f.color = :purple;f.orientation = :north;f},
        'Frame-purple-south-closed'    => lambda {f = Frame.new;f.color = :purple;f.orientation = :south;f},
        'Gate-purple-horizontal'       => lambda {g = Gate.new;g.color = :purple;g.orientation = :horizontal;g},
        'Gate-purple-vertical'         => lambda {g = Gate.new;g.color = :purple;g.orientation = :vertical;g}
      }

      KeyToThingHash.default_proc = lambda {|h,key| raise "No match for key '#{key}' in EditorMap::KeyToThingHash!"}

    end #class EditorMap
  end #module LevelBuilder
end #module OperationLambda