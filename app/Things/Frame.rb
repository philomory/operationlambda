require 'Thing'

module OperationLambda
  module Things
    class Frame < Thing
  
      def initialize(map,x,y,color,edge)
        super(map,x,y)
        @edge, @color,@state = edge, color, true
      end #def initialize
      
      def updateState
        @state = (@map.switch_state[@color] == 0)
        dest = nil
        if @edge == :north
          dest = self.south
          orient = :vertical
        elsif @edge == :west
          dest = self.east
          orient = :horizontal
        end
        return if dest.nil?
        if @state == true
          dest.crushed
          @map[dest.x,dest.y] = Gate.new(@map,dest.x,dest.y,@color,orient)
        elsif @state == false and dest.class == Gate
          @map[dest.x,dest.y] = Empty.new(@map,dest.x,dest.y)
        end 
      end #def updateState
      
      def key
        name = @state ? :closed : :open
        "Frame-#{@color}-#{@edge}-#{name}"
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