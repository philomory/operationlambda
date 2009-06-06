require 'Thing'

module OperationLambda
  module Things
class PushableBrick < Thing
    
    def movable?
      true
    end #def movable?
    
    def empty?
      false
    end #def empty?
    
  end #class PushableBrick
end #module Things
end #module OperationLambda