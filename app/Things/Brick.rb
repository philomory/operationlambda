require 'Thing'

module OperationLambda
  module Things
class Brick < Thing
    
    def movable?
      false
    end #def movable?
    
    def empty?
      false
    end #def empty?
    
  end #class Brick
end #module Things
end #module OperationLambda