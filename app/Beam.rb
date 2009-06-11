require 'Constants'

module OperationLambda
  
  # A module which is included into Thing to allow laserbeams to be drawn. It
  # also provides a utility function for calculating the color that results
  # from two overlapping beams.
  #
  # This is a pretty terrible module, and if I were doing this from scratch
  # I'd definitely want to do it differently. As it is, I'll probably leave it
  # alone until/unless I decide I need to add laser paths into the level
  # previews.
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