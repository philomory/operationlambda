require 'Counter/Timer'

module OperationLambda
  module Counter
    class Countdown < Timer
      def initialize(duration)
        @duration = duration
        super()
      end
      
      def time_remaining
        [@duration - self.time,0].max
      end
    end
  end
end