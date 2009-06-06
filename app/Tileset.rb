require 'YAML'
require 'Tile'

module OperationLambda
  class Tileset
    def initialize(name,folder)
      @name = name
      @folder = File.join(folder,@name)
      @tiles = {}
      tileset_def_file = File.join(@folder,"metadata.yaml")
      tileset_defs = YAML.load_file(tileset_def_file)
      tileset_defs[:tiles].each do |key,frames|
        begin
          tile = Tile.new(frames,@folder)
          @tiles[key] = tile
        rescue
          warn "Cannot make sense of mapping\n\t#{key} => #{frames}\nin file #{tileset_def_file}"
          warn $!.message
          warn $!.backtrace
        end
      end
      tileset_defs[:alias].each do |key,ref|
        @tiles[key] = @tiles[ref]
      end if tileset_defs.has_key? :alias
    end
    
    def [](key)
      if has_key?(key)
        @tiles[key]
      end
    end
    
    def has_key?(key)
      @tiles.has_key?(key)
    end
    
  end
end
