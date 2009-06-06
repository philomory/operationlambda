module OperationLambda
  class SubSequence
    def initialize(duration,&block)
      @duration, @block = duration, block
    end
    
    def draw
      @start_time ||= Time.now
      @block.call(portion)
    end
    
    def restart
      @start_time = nil
    end
    
    def portion
      if @start_time
        [((Time.now - @start_time) / @duration),1.0].min
      else
        0.0
      end
    end
    
  end
end