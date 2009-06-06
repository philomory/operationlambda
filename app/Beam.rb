require 'Constants'

module OperationLambda
  module Beam 
    def draw_beams(x,y)
      @laserbeams.each do |direction,color|
        unless color == :none
          ImageManager.tile("Beam-#{color}-#{direction}").static.draw(x,y,ZOrder::Lasers)
        end
      end
    end
  
    module_function
    def beam_composite(new_color,old_color)
      if old_color.in? [:none,new_color]
        return new_color
      else
        ([:red,:blue,:purple] - [new_color,old_color])[0]
      end
    end
  
  end #module Beam
end #module OperationLambda