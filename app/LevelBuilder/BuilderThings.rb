require 'Noun'

module OperationLambda
  module LevelBuilder
    module BuilderThings
      class BuilderThing < Noun
        Colors = [:blue,:red,:purple]
        
        def initialize
          @orientation_index = 0
          @color_index = 0
        end #def initialize
        
        def key
          self.noun
        end
        
        def possible_orientations
          false
        end
        
        def has_color?
          false
        end
        
        def rotate
          if possible_orientations
            @orientation_index = (@orientation_index + 1) % possible_orientations.size
          end
        end
        
        def orientation
          if possible_orientations
            possible_orientations[@orientation_index]
          end
        end
        
        def orientation=(dir)
          if possible_orientations && possible_orientations.include?(dir)
            @orientation_index = possible_orientations.index(dir)
          else
            raise "Invalid orientation #{dir} for BuilderThing #{self.noun}!"
          end
        end
        
        def cycle_color
          if has_color?
            @color_index = (@color_index + 1) % 3
          end
        end
        
        def color
          if has_color?
            Colors[@color_index]
          end
        end
        
        def color=(c)
          if has_color? && Colors.include?(c)
            @color_index = Colors.index(c)
          else
            raise "Invalid color #{c} for BuilderThing #{self.noun}!"
          end
        end
        
      end #class BuilderThing
      
      class Bomb < BuilderThing
        #def to_bigboard; 0x5000; end
      end
      class Brick < BuilderThing
        #def to_bigboard; 0x9000; end
      end
      class Corner < BuilderThing
        def possible_orientations; [:se,:ne,:nw,:sw]; end
        def key; "Corner#{orientation.to_s.upcase}"; end
        #def to_bigboard; [0x9100,0x9200,0x9300,0x9400][@orientation_index]; end
      end
      
      class CrackedBrick < BuilderThing
        #def to_bigboard; 0xa000; end
      end
      
      class Empty < BuilderThing
        #def to_bigboard; 0x0001; end
      end
      
      class EscapeHatch < BuilderThing
        #def to_bigboard; 0x7000; end
      end
      
      class Frame < BuilderThing
        def possible_orientations; [:north,:east,:south,:west]; end
        def has_color?; true; end
        def key; "Frame-#{color}-#{orientation}-closed"; end
      end
      
      class Gate < BuilderThing;
        def possible_orientations; [:vertical,:horizontal]; end
        def has_color?; true; end
        def key; "Gate-#{color}-#{orientation}"; end
      end
      
      class Generator < BuilderThing
        def has_color?; true; end
        def key; "Generator-#{color}-on"; end
        #def to_bigboard; [0xb400,0xb800,0xbc00][@color_index]; end
      end
      
      class Hostage < BuilderThing
        def possible_orientations; [:north,:east,:south,:west]; end
        def key; "Hostage-#{orientation}"; end
        #def to_bigboard; [0x0024,0x0022,0x0026,0x0020][@orientation_index]; end
      end
      
      class Laser < BuilderThing
        def possible_orientations; [:north,:east,:south,:west]; end
        def has_color?; true; end
        def key; "Laser-#{color}-#{orientation}-on"; end
        #def to_bigboard;
        #  [[0x9404,0x9402,0x9406,0x9400],
        #   [0x9804,0x9802,0x9806,0x9800],
        #   [0x9c04,0x9c02,0x9c06,0x9c00]
        #  ][@color_index][@orientation_index]
        #end
      end
      
      class Mirror < BuilderThing
        def possible_orientations; [:normal,:flipped]; end
        def key; "Mirror-#{orientation}"; end
        #def to_bigboard; [0x1180,0x1280][@orientation_index]; end
      end
      
      class PushableBrick < BuilderThing
        #def to_bigboard; 0x4000; end
      end
      
      class Space < BuilderThing
        #def to_bigboard; 0x0000; end
      end
      
      class Switch < BuilderThing
        def possible_orientations; [:vertical,:horizontal]; end
        def has_color?; true; end
        def key; "Switch-#{color}-#{orientation}"; end
        #def to_bigboard
        #  [[0xe400,0xe404],
        #   [0xe800,0xe804],
        #   [0xec00,0xec04]
        #  ][@color_index][@orientation_index]
        #end
      end
    
      class PlayerStart < BuilderThing
        def possible_orientations; [:north,:east,:south,:west]; end
        def key; "Player-#{orientation}"; end
        #def to_bigboard; [0x0014,0x0012,0x0016,0x0010][@orientation_index]; end
      end
    
    end #module BuilderThings
  end #module LevelBuilder
end #module OperationLambda
      