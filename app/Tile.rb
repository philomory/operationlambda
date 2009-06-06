require 'gosu'
require 'Constants'

module OperationLambda
  class Tile
    def initialize(frames,folder)
      @frames = if frames.is_a? Array
        frames.map {|frame| image_from_file(File.join(folder,frame)) or ImageManager::MissingImage}
      else
        frames_from_file(File.join(folder,frames)) or [ImageManager::MissingImage]
      end 
    end    
    
    def image_from_file(file)
      begin
        Gosu::Image.new(MainWindow.instance,file,true)
      rescue
        warn "could not load image from file '#{file}'"
      end
    end #def image_from_file(file)
    
    def frames_from_file(file)
      begin 
        Gosu::Image.load_tiles(MainWindow.instance,file,Sizes::TileWidth,Sizes::TileHeight,true)
      rescue
        warn "could not load animate frames from file '#{file}'"
        warn $!
      end
    end
    
    def size
      @frames.size
    end
    
    def frame(index,fractional=false)
      if fractional
        index = index * @frames.size
      end
      @frames[index % size]
    end
    
    def static
      frame 0
    end
    
    def draw(*args)
      warn_once
      self.static.draw(*args)
    end
    
    def warn_once
      warn "Warning: calling draw directly on tiles needs to be phased out since it
      messes with the animation syntax."
      def warn_once; nil; end;
    end
  end
end