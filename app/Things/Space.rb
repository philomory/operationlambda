require 'Thing'

module OperationLambda
  module Things
    class Space < Thing
    
      def movable?
        false
      end #def movable?
    
      def empty?
        false
      end #def empty?
    
    end #class Space
  end #module Things
end #module OperationLambda