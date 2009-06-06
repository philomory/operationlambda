module OperationLambda
  class Noun
    attr_reader :x, :y
  
    def noun
      self.class.to_s.match(/(?:.*::)+(.*?)$/).captures[0]
    end
  
    def north
      @map[x,y-1]
    end #def north
  
    def south
      @map[x,y+1]
    end #def south
  
    def east
      @map[x+1,y]
    end #def east
  
    def west
      @map[x-1,y]
    end #def west
  
  end #class Noun
end #module OperationLambda
