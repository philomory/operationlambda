require 'Constants'
require 'Levelset/BoardData'

module OperationLambda
  class Levelset
    module Smallboard
      include BoardData
      #def included(other)
      #
      #end
      
      def load_level(level)
        data = read_level_data(level)
        return level_for_data(data)
      end
      
      def read_level_data(level)
        smallboard_path = File.join(@directory,@details['files'][level-1])
        smallboard = File.open(smallboard_path,"rb")
        data = smallboard.read
        smallboard.close
        return data
      end
      
      def save_level(level_data,level)
        data = data_for_level(level_data)
        write_level_data(data,level)
        @metadata['levels'] = @details['files'].size
        commit
      end
      
      def write_level_data(data,level)
        if @details['files'][level-1]
          smallboard_path = File.join(@directory,@details['files'][level-1])
          File.open(smallboard_path,"w") {|file| file.write(data)}
        else
          new_file_name = "level#{level}.smallboard"
          smallboard_path = File.join(@directory,new_file_name)
          File.open(smallboard_path,"w") {|file| file.write(data)}
          @details['files'] << new_file_name
          @metadata['levels'] += 1
        end
      end
      
    end
  end
end