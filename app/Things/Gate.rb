require 'Thing'

module OperationLambda
  module Things
    class Gate < Thing
          
      def initialize(map,x,y,color,dir)
        super(map,x,y)
        @orientation, @color = dir, color
      end #def initialize
      
      def key
        "Gate-#{@color}-#{@orientation}"
      end
      
      def movable?
        false
      end #def movable?

      def empty?
        false
      end #def empty?

    end #class Gate
  end #module Things
end #module OperationLambda