require 'Sequence'

module OperationLambda
  
  # A Sequence used to fade from one Screen to another.
  class FadeSequence < Sequence
    def initialize(from,to)
      @from, @to = from, to
      @loop_final = false
      
      subseq(0.3) do |portion|
        @from.draw
        a = (portion * 0xFF).floor
        c = (a * 0x01000000)
        self.fill(c)
      end
      
      subseq(0.3) do |portion|
        @to.draw
        a = ((1-portion) * 0xFF).floor
        c = (a * 0x01000000)
        self.fill(c)
      end
    end
    
    def done
      MainWindow.immediate_set_screen(@to)
      @to.draw
    end
    
    def should_play_music?
      @from.should_play_music? && @to.should_play_music?
    end  
  end
end