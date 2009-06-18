require 'Constants'
#require 'Brick'
require 'helper'
require 'BaseMap'

module OperationLambda
  # This class represents a map on which the game will be played. It has
  # a *ton* of attr_accessors; some of them should probably be made read-only,
  # or disappear altogether if possible.
  class GameplayMap < BaseMap
    attr_accessor :player_start, :lasers, :laser_state, :hostages,:game, :time
    attr_accessor :switch_state, :gates, :crumbling

    def initialize(game,width,height,level_hash)
      super(width,height)
      @game = game
      @player_start = {:x => 0, :y => 0,:dir => :east}
      @hostages = 0
      @lasers = []
      @crumbling = []
      @laser_state = {:red => true, :blue => true, :purple => true} #true is on, false is off.
      @gates = []
      @switch_state = {:red => 0, :blue => 0, :purple => 0}
      @time = level_hash[:time]
      #self.each_with_coords do |,x,y| # TODO: Abstract away Grid class and use it more widely.
      #  self[x,y] = KeyToThingHash[key].call(self,x,y)
      #end
      level_hash[:places].each_with_index do |column,x|
        column.each_with_index do |key,y|
          self[x,y] = KeyToThingHash[key].call(self,x,y)
        end
      end
    end #def initialize
  
    
    # Surely only one of these two methods is necessary?
    # TODO: Investigate canPushThing_inDirection vs canPushThingAtX_andY_inDirection
    def canPushThing_inDirection(thing,direction)
      if thing.movable? then
        destination = thing.send(direction)
        if destination.empty? then
          return true
        end
      else
        return false
      end #if destination.empty?
    end #def canPushThing_inDirection
  
    def canPushThingAtX_andY_inDirection(x,y,direction)
      return canPushThing_inDirection(self[x,y],direction)
    end #def canPushThingAtX_andY_inDirection
  
    # I think the only differnce between this and just calling 'super'
    # is the call to draw_beams. This is stupid.
    # TODO: Refactor this.
    def draw
      @background_image.draw(0,0,ZOrder::Stars)
      self.each_with_coords do |obj,x,y|
        xpos = x * Sizes::TileWidth
        ypos = y * Sizes::TileHeight
        @floor_image.draw(xpos,ypos,ZOrder::Floor) unless (obj.noun == 'Space')
        ImageManager.tile(obj.key).frame(obj.frame_fraction,true).draw(xpos,ypos,ZOrder::Things)
        obj.draw_beams(xpos,ypos)
      end 
    end
    
    def remove_lasers
      self.each {|thing| thing.remove_lasers}
    end
    
    # This hash maps 'keys' (poor word choice, in this context it means Strings
    # which uniquely identify various kinds of objects; identifying class, as
    # well as the initial values for various instance variables) to lambdas
    # create an instance of the appropriate class with the appropriate parameters
    # to the constructor. The result of calling such a lambda is an instance of
    # a subclass of Thing. Hence, KeyToThingHash.
    KeyToThingHash               = {
      'Space'                        => lambda {|map,x,y| Things::Space.new(map,x,y)}, #Bret calls this 'Empty',
      'Empty'                        => lambda {|map,x,y| Things::Empty.new(map,x,y)}, #Bret calls this 'Floor',
                                     
      'Player-west'                  => lambda {|map,x,y| map.player_start = {:x => x, :y => y,:dir => :west}; Things::Empty.new(map,x,y)},
      'Player-east'                  => lambda {|map,x,y| map.player_start = {:x => x, :y => y,:dir => :east}; Things::Empty.new(map,x,y)},
      'Player-north'                 => lambda {|map,x,y| map.player_start = {:x => x, :y => y,:dir => :north}; Things::Empty.new(map,x,y)},
      'Player-south'                 => lambda {|map,x,y| map.player_start = {:x => x, :y => y,:dir => :south}; Things::Empty.new(map,x,y)},
      'Hostage-west'                 => lambda {|map,x,y| map.hostages += 1; Things::Hostage.new(map,x,y,:west)},
      'Hostage-east'                 => lambda {|map,x,y| map.hostages += 1; Things::Hostage.new(map,x,y,:east)},
      'Hostage-north'                => lambda {|map,x,y| map.hostages += 1; Things::Hostage.new(map,x,y,:north)},
      'Hostage-south'                => lambda {|map,x,y| map.hostages += 1; Things::Hostage.new(map,x,y,:south)},
                                     
      'Mirror-normal'                => lambda {|map,x,y| Things::Mirror.new(map,x,y,1)},
      'Mirror-flipped'               => lambda {|map,x,y| Things::Mirror.new(map,x,y,-1)},
                                     
      'PushableBrick'                => lambda {|map,x,y| Things::PushableBrick.new(map,x,y)},
      'Bomb'                         => lambda {|map,x,y| Things::Bomb.new(map,x,y)},
      'EscapeHatch'                  => lambda {|map,x,y| Things::EscapeHatch.new(map,x,y)},
                                     
      'Brick'                        => lambda {|map,x,y| Things::Brick.new(map,x,y)},
      'CrackedBrick'                 => lambda {|map,x,y| Things::CrackedBrick.new(map,x,y)},
                                     
      'CornerSE'                     => lambda {|map,x,y| Things::CornerSE.new(map,x,y)},
      'CornerNE'                     => lambda {|map,x,y| Things::CornerNE.new(map,x,y)},
      'CornerNW'                     => lambda {|map,x,y| Things::CornerNW.new(map,x,y)},
      'CornerSW'                     => lambda {|map,x,y| Things::CornerSW.new(map,x,y)},
                                     
      'Generator-blue-on'            => lambda {|map,x,y| Things::Generator.new(map,x,y,:blue)},
      'Generator-red-on'             => lambda {|map,x,y| Things::Generator.new(map,x,y,:red)},
      'Generator-purple-on'          => lambda {|map,x,y| Things::Generator.new(map,x,y,:purple)},
                                     
      'Laser-blue-west-on'           => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:blue,:west); map.lasers.push(a); a},
      'Laser-blue-east-on'           => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:blue,:east); map.lasers.push(a); a},
      'Laser-blue-north-on'          => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:blue,:north); map.lasers.push(a); a},
      'Laser-blue-south-on'          => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:blue,:south); map.lasers.push(a); a},
      'Laser-red-west-on'            => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:red,:west); map.lasers.push(a); a},
      'Laser-red-east-on'            => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:red,:east); map.lasers.push(a); a},
      'Laser-red-north-on'           => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:red,:north); map.lasers.push(a); a},
      'Laser-red-south-on'           => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:red,:south); map.lasers.push(a); a},
      'Laser-purple-west-on'         => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:purple,:west); map.lasers.push(a); a},
      'Laser-purple-east-on'         => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:purple,:east); map.lasers.push(a); a},
      'Laser-purple-north-on'        => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:purple,:north); map.lasers.push(a); a},
      'Laser-purple-south-on'        => lambda {|map,x,y| a = Things::Laser.new(map,x,y,:purple,:south); map.lasers.push(a); a},
                                     
      'Switch-blue-vertical'         => lambda {|map,x,y| Things::Switch.new(map,x,y,:blue,:vertical)},
      'Switch-blue-horizontal'       => lambda {|map,x,y| Things::Switch.new(map,x,y,:blue,:horizontal)},   
      'Switch-red-vertical'          => lambda {|map,x,y| Things::Switch.new(map,x,y,:red,:vertical)},  
      'Switch-red-horizontal'        => lambda {|map,x,y| Things::Switch.new(map,x,y,:red,:horizontal)},
      'Switch-purple-vertical'       => lambda {|map,x,y| Things::Switch.new(map,x,y,:purple,:vertical)},
      'Switch-purple-horizontal'     => lambda {|map,x,y| Things::Switch.new(map,x,y,:purple,:horizontal)},
                                     
      'Frame-blue-west-closed'       => lambda {|map,x,y| a = Things::Frame.new(map,x,y,:blue,:west); map.gates.push(a); a},
      'Frame-blue-east-closed'       => lambda {|map,x,y| a = Things::Frame.new(map,x,y,:blue,:east); map.gates.push(a); a},
      'Frame-blue-north-closed'      => lambda {|map,x,y| a = Things::Frame.new(map,x,y,:blue,:north); map.gates.push(a); a},
      'Frame-blue-south-closed'      => lambda {|map,x,y| a = Things::Frame.new(map,x,y,:blue,:south); map.gates.push(a); a},
      'Gate-blue-horizontal'         => lambda {|map,x,y| Things::Gate.new(map,x,y,:blue,:horizontal)},
      'Gate-blue-vertical'           => lambda {|map,x,y| Things::Gate.new(map,x,y,:blue,:vertical)},
                                     
      'Frame-red-west-closed'        =>  lambda {|map,x,y| a = Things::Frame.new(map,x,y,:red,:west); map.gates.push(a); a},
      'Frame-red-east-closed'        =>  lambda {|map,x,y| a = Things::Frame.new(map,x,y,:red,:east); map.gates.push(a); a},
      'Frame-red-north-closed'       =>  lambda {|map,x,y| a = Things::Frame.new(map,x,y,:red,:north); map.gates.push(a); a},
      'Frame-red-south-closed'       =>  lambda {|map,x,y| a = Things::Frame.new(map,x,y,:red,:south); map.gates.push(a); a},
      'Gate-red-horizontal'          =>  lambda {|map,x,y| Things::Gate.new(map,x,y,:red,:horizontal)},
      'Gate-red-vertical'            =>  lambda {|map,x,y| Things::Gate.new(map,x,y,:red,:vertical)},
                                     
      'Frame-purple-west-closed'     =>  lambda {|map,x,y| a = Things::Frame.new(map,x,y,:purple,:west); map.gates.push(a); a},
      'Frame-purple-east-closed'     =>  lambda {|map,x,y| a = Things::Frame.new(map,x,y,:purple,:east); map.gates.push(a); a},
      'Frame-purple-north-closed'    =>  lambda {|map,x,y| a = Things::Frame.new(map,x,y,:purple,:north); map.gates.push(a); a},
      'Frame-purple-south-closed'    =>  lambda {|map,x,y| a = Things::Frame.new(map,x,y,:purple,:south); map.gates.push(a); a},
      'Gate-purple-horizontal'       =>  lambda {|map,x,y| Things::Gate.new(map,x,y,:purple,:horizontal)},
      'Gate-purple-vertical'         =>  lambda {|map,x,y| Things::Gate.new(map,x,y,:purple,:vertical)}
    }
    
  end #class GameplayMap
end #module OperationLambda


