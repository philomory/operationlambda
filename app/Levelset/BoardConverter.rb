if __FILE__ == $PROGRAM_NAME
  Dir.chdir('..')
end

require 'Platform'
require 'YAML'
require 'Levelset'
require 'Levelset/Smallboard'
require 'Levelset/Bigboard'
require 'Levelset/BoardData'

module OperationLambda
  class Levelset
    module BoardConverter
      module_function
      def convert(levelset,to_format)
        from_format = levelset.metadata['datatype']
        if from_format == to_format
          return
        elsif from_format == 'smallboard' and to_format == 'bigboard'
          smallboard_to_bigboard(levelset)
        elsif from_format == 'bigboard' and to_format == 'smallboard'
          bigboard_to_smallboard(levelset)
        else
          generic_convert(levelset,to_format)
        end
      end
      
      private_class_method
      def smallboard_to_bigboard(levelset)
        dir = levelset.directory
        meta = levelset.metadata
        smalls = meta['details']['files'].map {|file| File.join(dir,file)}
        big = File.join(dir,"bigboard")
        File.open(big,"w") do |bigfile|
          smalls.each do |small|
            File.open(small,"rb") do |smallfile|
              data = smallfile.read()
              bigfile.write(data)
            end
          end
        end
        meta['datatype'] = 'bigboard'
        meta['details'] = {'file' => 'bigboard'}
        File.open(File.join(dir,"metadata.yaml"),"w") do |f|
          YAML.dump(meta,f)
        end
      end
      
      def bigboard_to_smallboard(levelset)
        dir = levelset.directory
        meta = levelset.metadata
        bytes_per_level = BoardData::BoardSize + BoardData::Bytes # extra short is for time
        big = File.join(dir,meta['details']['file'])
        files = []
        File.open(big,"rb") do |bigfile|
          level = 1
          until bigfile.eof? do
            data = bigfile.read(bytes_per_level)
            smallname = "level#{level}.smallboard"
            small = File.join(dir,smallname)
            File.open(small,"w") do |smallfile|
              smallfile.write(data)
            end
            files.push(smallname)
            level += 1
          end
        end
        meta['datatype'] = 'smallboard'
        meta['details'] = {'files' => files}
        File.open(File.join(dir,"metadata.yaml"),"w") do |f|
          YAML.dump(meta,f)
        end
      end
      
      def generic_convert(levelset,to_format)
      end
      
      
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  l = OperationLambda::Levelset.new({:dir =>'OperationLambda copy',:cat => :user})
  OperationLambda::Levelset::BoardConverter.convert(l,'smallboard')
end
  
