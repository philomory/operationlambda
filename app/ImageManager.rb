require 'gosu'
require 'YAML'

require 'Platform'
require 'Tileset'
require 'EmptyImageStub'

module OperationLambda
  
  # This module is responsible for loading, and supplying to other classes,
  # all the images (and for some reason, fonts) used by the game. ImageManager
  # and it's helper classes Tileset and Tile are the only classes that ever
  # call Gosu::Image.new, or have anything to do with images files on disk.
  #
  # TODO: add more comments to this file.
  module ImageManager
    ImagesDir = File.join(Platform::ApplicationMediaDir,'images')
    StandardDir = File.join(ImagesDir,'standard')
    FontsToTry = {
      :menu  => [File.join(Platform::ApplicationFontDir,"ArmyHollowWide.ttf"),"Army Hollow Wide","Army Hollow","Stencil Outline","Army Hollow Expanded","Army Wide","Army","Stencil"],
      :basic => []
    }
    FontsUsed = {}
    @user_tileset = {}
    StandardImages = {}
    LoadedGosuFonts = {}

    module_function

    def load_images
      missing = 'Missing.png'
      self.const_set(:MissingImage,Gosu::Image.new(MainWindow.instance,File.join(StandardDir,missing),true))
      self.const_set(:MissingTile,Tile.new([missing],StandardDir))
      self.const_set(:StandardTileset,Tileset.new('OperationLambda',Platform::ApplicationTilesetDir))
      standard_defs_file = File.join(StandardDir,'standard.yaml')
      standard_defs = YAML.load_file(standard_defs_file)
      window = MainWindow.instance
      standard_defs.each do |key,file|
        path = File.join(StandardDir,file)
        StandardImages[key] = Gosu::Image.new(window,path,true)
      end
    end

    def load_tileset(set)
      if set[:cat] == :user
        dir = Platform::UserTilesetDir
      else
        dir = Platform::ApplicationTilesetDir
      end
      @user_tileset = Tileset.new(set[:dir],dir)
    end

    def unload_tileset
      @user_tileset = nil
    end  

    def tilesets
      ts  = self.tilesets_in(Platform::ApplicationTilesetDir).map{|dir| {:dir => dir, :cat => :app}}
      (ts.concat(self.tilesets_in(Platform::UserTilesetDir).map{|dir| {:dir => dir, :cat => :user}})) rescue nil
      return ts
    end

    def tilesets_in(path)
      (Dir.entries(path) - ['.','..']).map {|item| File.join(path,item)}.select {|path| File.directory?(path)}.map {|dir| File.basename(dir)}
    end

    def tile(key)
      @user_tileset[key] || StandardTileset[key] || MissingTile
    end

    def image(key)
      return StandardImages[key] || raise("No image available for #{key} in #{StandardImages.inspect}")
    end

    def empty(w,h)
      stub = EmptyImageStub.new(w,h)
      return Gosu::Image.new(MainWindow.instance,stub,true)
    end



    def font(cat,size)
      if !Settings[:use_fonts]
        return basic_font(size)
      else
        return custom_font(cat,size)
      end
    end #def font(cat,size)

    private    
    def self.basic_font(size)
      name = Gosu::default_font_name
      if LoadedGosuFonts.include?([name,size])
        return LoadedGosuFonts[[name,size]]
      else
        fon = Gosuy::Font.new(MainWindow.instance,name,size)
        LoadedGosuFonts[[name,size]] = fon
        return fon
      end
    end
    
    def self.custom_font(cat,size)
      if FontsUsed.include?(cat)
        return load_used_font(cat,size)
      else
        return try_to_load_new_font(cat,size)
      end
    end
    
    def self.load_used_font(cat,size)
      name_or_path = FontsUsed[cat]
      if LoadedGosuFonts.include?([name_or_path,size])
        return LoadedGosuFonts[[name_or_path,size]]
      else
        fon = Gosu::Font.new(MainWindow.instance,name_or_path,size)
        LoadedGosuFonts[[name_or_path,size]] = fon
        return fon
      end
    end
    
    # This is ugly, but functional!
    def self.try_to_load_new_font(cat,size)
      begin
        result = FontsToTry[cat].find do |name_or_path|
          begin
            add_font(cat,name_or_path,size)
            true
          rescue
            false
          end #inner begin
        end #find
        add_font(cat,Gosu::default_font_name,size) unless result
      rescue
        add_font(cat,Gosu::default_font_name,size)
      end #outer begin
      name = FontsUsed[cat]
      return LoadedGosuFonts[[name,size]]
    end
    
    def self.add_font(cat,name_or_path,size)
      fon = Gosu::Font.new(MainWindow.instance,name_or_path,size)
      fon.text_width('1')
      FontsUsed[cat] = name_or_path
      LoadedGosuFonts[[name_or_path,size]] = fon
    end
    
  end
end
