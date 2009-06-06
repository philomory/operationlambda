require 'Sequence'
require 'ImageManager'
require 'Constants'

module OperationLambda
  class OutOfTimeSequence < Sequence
    TopMargin = 20
    
    def should_play_music?
      true
    end
    
    def draw_text(lines,color)
      lines.each_with_index do |line,index|
        height = 20 + (index * @font.height)
        @font.draw_rel(line,Sizes::WindowWidth/2,height,ZOrder::TopMessage,0.5,0,1,1,color)
      end
    end
    
    def initialize(parent)
      @parent = parent
      @loop_final = false
      @font = ImageManager.font("Georgia",100)
      
      subseq(0.33) do |portion|
        @parent.draw
        a = (portion * 0xFF).floor
        c = (a * 0x01000000) + 0xFFFFFF
        self.fill(c)
      end
      
      words = %w[Out Of Time!]
      1.upto words.size do |index|
        subseq(1.33) do |portion|
          self.fill(0xFFFFFFFF)
          lines = words[0...index]
          alpha = (Math.sin(Math::PI*portion).abs*256).to_i
          color = Gosu::Color.new(alpha,0x44,0x44,0x44)
          self.draw_text(lines,color)
        end
      end
      
      subseq(0.33) do |portion|
        @parent.draw
        a = ((1-portion) * 0xFF).floor
        c = (a * 0x01000000) + 0xFFFFFF
        self.fill(c)
      end
      
    end #def initialize
    
    def done
      @parent.out_of_time_finished
    end
    
  end #class OutOfTimeSequence
end #module OperationLambda