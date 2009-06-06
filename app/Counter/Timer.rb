module OperationLambda
  module Counter
    class Timer
      def initialize
        @clock = 0.0
        @running = false
      end

      def time
        if @running
          @clock + (Time.now - @start_time)
        else
          @clock
        end
      end

      def start
        unless @running
          @start_time = Time.now
          @running = true
        end
      end

      def pause
        if @running
          @clock += (Time.now - @start_time)
          @running = false
        end
      end

      def reset
        @clock = 0.0
        if @running
          @start_time = Time.now
        end
      end
    end
  end
end