require 'Constants'
require 'Levelset/BoardData'

module OperationLambda
  class Levelset
    module Bigboard
      include BoardData
      def included(other)
        raise "Bigboard cannot be loaded without a 'file' key!" unless @details['file']
      end
      
      def load_level(level)
        data = read_level_data(level)
        return level_for_data(data)
      end
      
      def read_level_data(level)
        bigboard = File.new(File.join(@directory,@details['file']))
        bigboard.pos = (level - 1) * (BoardSize + Bytes)
        return bigboard.read(BoardSize + Bytes)
      end
      
    end
  end
end