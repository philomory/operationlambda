# This code comes from sample code Julian Raschke posted on the Gosu
# forums, implimenting a simple framerate counter.

module OperationLambda
  module Counter
    class FPSCounter
      attr_reader :fps

      def initialize
        @current_second = Gosu::milliseconds / 1000
        @accum_fps = 0
        @fps = 0
      end

      def register_tick
        @accum_fps += 1
        current_second = Gosu::milliseconds / 1000
        if current_second != @current_second
          @current_second = current_second
          @fps, @accum_fps = @accum_fps, 0
        end
      end
    end
  end
end